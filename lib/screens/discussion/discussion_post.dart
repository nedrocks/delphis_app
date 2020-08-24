import 'dart:io';

import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/link/link_bloc.dart';
import 'package:delphis_app/bloc/mention/mention_bloc.dart';
import 'package:delphis_app/bloc/superpowers/superpowers_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/concierge_content.dart';
import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/data/repository/moderator.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/data/repository/post_content_input.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/notifiers/media_change_notifier.dart';
import 'package:delphis_app/screens/discussion/media/media_loaded_snippet.dart';
import 'package:delphis_app/screens/discussion/media/media_snippet.dart';
import 'package:delphis_app/screens/superpowers/superpowers_arguments.dart';
import 'package:delphis_app/widgets/animated_background_color/animated_background_color.dart';
import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:delphis_app/widgets/emoji_text/emoji_text.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:delphis_app/widgets/profile_image/profile_image_and_inviter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'post_title.dart';

typedef ConciergePostOptionPressed(
    Post post, ConciergeContent content, ConciergeOption option);

class DiscussionPost extends StatefulWidget {
  final Post post;
  final Participant participant;
  final Moderator moderator;
  final Discussion discussion;
  final Function(File, MediaContentType) onMediaTap;
  final Function(SuperpowersArguments) onModeratorButtonPressed;
  final Function(LocalPost) onLocalPostRetryPressed;

  const DiscussionPost(
      {Key key,
      @required this.participant,
      @required this.post,
      @required this.moderator,
      @required this.discussion,
      @required this.onModeratorButtonPressed,
      @required this.onLocalPostRetryPressed,
      @required this.onMediaTap})
      : super(key: key);

  @override
  _DiscussionPostState createState() => _DiscussionPostState();
}

class _DiscussionPostState extends State<DiscussionPost>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscussionBloc, DiscussionState>(
        builder: (context, discussionState) {
      return BlocBuilder<MentionBloc, MentionState>(
        builder: (context, mentionState) {
          if (mentionState.isReady()) {
            return AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 200),
              reverseDuration: Duration(milliseconds: 50),
              curve: Curves.decelerate,
              child: buildWithDeletionAnimation(
                context,
                buildWithInfo(context, discussionState, mentionState),
              ),
            );
          }
          return Container();
        },
      );
    });
  }

  Widget buildWithDeletionAnimation(BuildContext context, Widget child) {
    return BlocBuilder<SuperpowersBloc, SuperpowersState>(
      buildWhen: (prev, current) {
        return current != prev &&
            ((current is DeletePostSuccessState) ||
                (current is BanParticipantSuccessState));
      },
      builder: (context, state) {
        if ((state is DeletePostSuccessState &&
                state.post.id == this.widget.post.id ||
            (state is BanParticipantSuccessState &&
                state.participant.id == this.widget.post.participant.id))) {
          child = AnimatedBackgroundColor(
            child: child,
            startColor: Colors.red,
            endColor: Colors.transparent,
            duration: Duration(milliseconds: 2000),
            repeat: false,
          );
        }
        return child;
      },
    );
  }

  Widget buildWithInfo(BuildContext context, DiscussionState discussionState,
      MentionState mentionState) {
    /* Retrieve local post in order to render proper UI accordingly */
    LocalPost localPost;
    if (discussionState is DiscussionLoadedState &&
        discussionState.getDiscussion() != null &&
        (this.widget.post.isLocalPost ?? false)) {
      localPost = discussionState.localPosts
          .firstWhere((e) => e.post == this.widget.post, orElse: () => null);
    }
    final isModeratorAuthor = this.widget.participant?.userProfile?.id ==
        this.widget.moderator.userProfile.id;

    var textWidget = EmojiText(
      text: this.widget.post.isDeleted
          ? formatDeleteReason(this.widget.post.deletedReasonCode)
          : this.widget.post.content,
      style: Theme.of(context).textTheme.bodyText1,
    );

    /* Handle URL link tap and coloring */
    textWidget.setStyleOperator(LinkBloc.urlLinkRegex, (s, before, after) {
      var color = Colors.green;
      return s.copyWith(color: color, fontWeight: FontWeight.bold);
    });
    textWidget.setOnTap(LinkBloc.urlLinkRegex, (value) {
      BlocProvider.of<LinkBloc>(context).add(LinkChangeEvent(newLink: value));
    });

    /* Color and format mentioned entities */
    textWidget.setTextOperator(
        MentionState.mentionSpecialCharsRegexPattern,
        (s) => mentionState.decodePostContent(
            s, this.widget.post.mentionedEntities));
    textWidget.setTextOperator(
        MentionState.encodedMentionRegexPattern,
        (s) => mentionState.decodePostContent(
            s, this.widget.post.mentionedEntities));
    textWidget.setStyleOperator(MentionState.encodedMentionRegexPattern,
        (s, before, after) {
      var color = Colors.lightBlue;
      if (RegExp(MentionState.unknownMentionRegexPattern).hasMatch(after)) {
        color = Colors.grey;
      }
      return s.copyWith(color: color, fontWeight: FontWeight.bold);
    });

    Color postBackgroundColor = Colors.transparent;
    if (this.widget.post.postType == PostType.ALERT) {
      postBackgroundColor = Colors.grey.withAlpha(60);
    }

    return Container(
      padding: EdgeInsets.all(SpacingValues.medium),
      decoration: BoxDecoration(color: postBackgroundColor),
      child: Row(
        children: <Widget>[
          Align(
            child: buildLocalPostIndicator(context, discussionState, localPost),
          ),
          Expanded(
            child: Opacity(
              opacity: localPost != null ? 0.4 : 1.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    key: this.widget.key == null
                        ? null
                        : Key(
                            '${this.widget.key.toString()}-profile-image-padding-container'),
                    padding: EdgeInsets.only(right: SpacingValues.medium),
                    child: buildProfileImage(
                      context,
                      isModeratorAuthor,
                      this.widget.post.isDeleted,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        key: this.widget.key == null
                            ? null
                            : Key(
                                '${this.widget.key.toString()}-content-column'),
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Opacity(
                            opacity: this.widget.post.isDeleted ? 0.5 : 1.0,
                            child: PostTitle(
                              moderator: this.widget.moderator,
                              participant: this.widget.participant,
                              height: 20.0,
                              isModeratorAuthor: isModeratorAuthor,
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      top: SpacingValues.xxSmall),
                                  child: textWidget,
                                ),
                                buildMediaSnippet(context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  isSuperpowersAvailable() && localPost == null
                      ? Material(
                          type: MaterialType.circle,
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => this.widget.onModeratorButtonPressed(
                                SuperpowersArguments(
                                    discussion: this.widget.discussion,
                                    post: this.widget.post,
                                    participant: this.widget.participant)),
                            child: Container(
                              padding: EdgeInsets.all(SpacingValues.small),
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              clipBehavior: Clip.antiAlias,
                              child: Icon(Icons.more_vert,
                                  color: Colors.white, size: 24),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLocalPostIndicator(BuildContext context,
      DiscussionState discussionState, LocalPost localPost) {
    Widget render = Container();
    if (localPost == null) {
      return Container();
    } else if (localPost.isProcessing == true) {
      render = CupertinoActivityIndicator();
    } else if (localPost.error != null) {
      render = Material(
        type: MaterialType.circle,
        color: Colors.red,
        child: InkWell(
          onTap: () {
            this.widget.onLocalPostRetryPressed(localPost);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: Icon(Icons.error_outline, color: Colors.white, size: 20),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(right: SpacingValues.medium),
      child: render,
    );
  }

  Widget buildMediaSnippet(BuildContext context) {
    if (this.widget.post.isDeleted) {
      return Container();
    }
    var media = this.widget.post.media;
    if (!(media != null && media.assetLocation != null) &&
        !((this.widget.post.isLocalPost ?? false) &&
            this.widget.post.localMediaFile != null &&
            this.widget.post.localMediaContentType != null)) {
      return Container();
    }

    return ChangeNotifierProvider(
      create: (context) => MediaChangeNotifier(),
      child: Consumer<MediaChangeNotifier>(
        builder: (context, value, child) {
          if (value.hasData()) {
            return LoadedMediaSnippetWidget(
              key: Key('${this.widget.key}-loaded-snippet'),
              mediaContentType: value.mediaContentType,
              file: value.file,
              image: value.imageProvider,
              onTap: () =>
                  this.widget.onMediaTap(value.file, value.mediaContentType),
            );
          }

          return MediaSnippetWidget(
            key: Key('${this.widget.key}-media-snippet'),
            post: this.widget.post,
            onTap: this.widget.onMediaTap,
            onMediaLoaded: (file, image, type) {
              Provider.of<MediaChangeNotifier>(context, listen: false)
                  .setData(file, image, type);
            },
          );
        },
      ),
    );
  }

  bool isMeDiscussionModerator() {
    return this.widget.discussion?.isMeDiscussionModerator() ?? false;
  }

  bool isMePostAuthor() {
    return this
        .widget
        .discussion
        ?.meAvailableParticipants
        ?.where((e) => e.discussion.id == this.widget.discussion.id)
        ?.map((e) => e.participantID)
        ?.contains(this.widget.post.participant?.participantID);
  }

  bool isSuperpowersAvailable() {
    return (isMeDiscussionModerator() || isMePostAuthor()) &&
        this.widget.post.postType != PostType.CONCIERGE &&
        this.widget.post.postType != PostType.ALERT;
  }

  Widget buildProfileImage(
      BuildContext context, bool isModeratorAuthor, bool isDeleted) {
    if (isDeleted) {
      return Container(
          key: this.widget.key == null
              ? null
              : Key('${this.widget.key.toString()}-profile-image-container'),
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.transparent, width: 1.0),
          ),
          child: AnonProfileImage(
            height: 36,
            width: 36,
            borderShape: BoxShape.circle,
            border: Border.all(color: Colors.transparent, width: 1.0),
          ));
    }

    var profileImage = Container(
      key: this.widget.key == null
          ? null
          : Key('${this.widget.key.toString()}-profile-image-container'),
      width: isModeratorAuthor ? 38 : 36,
      height: isModeratorAuthor ? 38 : 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isModeratorAuthor
            ? null
            : (!(this.widget.participant?.isAnonymous ?? false)
                ? ChathamColors.whiteGradient
                : ChathamColors.gradients[gradientNameFromString(
                    this.widget.participant?.gradientColor)]),
        border: Border.all(color: Colors.transparent, width: 1.0),
      ),
      child: isModeratorAuthor
          ? ModeratorProfileImage(
              starTopLeftMargin: 24.5,
              starSize: 12,
              diameter: 36,
              profileImageURL:
                  this.widget.moderator.userProfile.profileImageURL)
          : ProfileImage(
              profileImageURL:
                  this.widget.participant?.userProfile?.profileImageURL,
              isAnonymous: this.widget.participant?.isAnonymous ?? false,
            ),
    );

    var inviterParticipant = this.widget.discussion.participants.firstWhere(
        (p) => p.id == this.widget.participant?.inviter?.id,
        orElse: () => null);
    if ((this.widget.participant?.isAnonymous ?? false) &&
        inviterParticipant != null) {
      var imageUrl = inviterParticipant?.userProfile?.profileImageURL;

      if (inviterParticipant?.id == this.widget.participant?.id ||
          imageUrl == null) {
        imageUrl =
            this.widget.discussion?.moderator?.userProfile?.profileImageURL;
      }

      return ProfileImageAndInviter(
          size: 20,
          child: profileImage,
          inviterImageURL: imageUrl,
          gradient: inviterParticipant.isAnonymous
              ? ChathamColors.gradients[inviterParticipant.gradientColor]
              : ChathamColors.whiteGradient);
    }

    return profileImage;
  }

  String formatDeleteReason(PostDeletedReason code) {
    switch (code) {
      case PostDeletedReason.UNKNOWN:
        return Intl.message("This post has been deleted.");
      case PostDeletedReason.MODERATOR_REMOVED:
        return Intl.message("This post has been deleted by the moderator.");
      case PostDeletedReason.PARTICIPANT_REMOVED:
        return Intl.message("This post has been deleted by its author.");
    }
    return "";
  }
}

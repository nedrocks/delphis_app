import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/bloc/notification/notification_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/screens/discussion/discussion_post_list_view.dart';
import 'package:delphis_app/screens/discussion/overlay/animated_discussion_popup.dart';
import 'package:delphis_app/screens/discussion/overlay/discussion_popup.dart';
import 'package:delphis_app/screens/discussion/overlay/participant_settings.dart';
import 'package:delphis_app/util/callbacks.dart';
import 'package:delphis_app/widgets/overlay/overlay_top_message.dart';
import 'package:delphis_app/widgets/text_overlay_notification/incognito_mode_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsOverlayDiscussionPostListView extends StatelessWidget {
  final ScrollController scrollController;
  final Discussion discussion;
  final bool isDiscussionVisible;

  final SuccessCallback onClose;

  const SettingsOverlayDiscussionPostListView({
    @required this.scrollController,
    @required this.discussion,
    @required this.onClose,
    this.isDiscussionVisible = false,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return AnimatedDiscussionPopup(
      child: DiscussionPostListView(
        discussion: this.discussion,
        scrollController: this.scrollController,
        isVisible: this.isDiscussionVisible,
      ),
      popup: DiscussionPopup(
        contents: ParticipantSettings(
          discussion: this.discussion,
          meParticipant: this.discussion.meParticipant,
          me: MeBloc.extractMe(BlocProvider.of<MeBloc>(context).state),
          onClose: (didUpdate) {
            if (didUpdate) {
              BlocProvider.of<NotificationBloc>(context).add(
                NewNotificationEvent(
                  notification: OverlayTopMessage(
                    child: IncognitoModeTextOverlay(
                      hasGoneIncognito: didUpdate
                          ? !this.discussion.meParticipant.isAnonymous
                          : this.discussion.meParticipant.isAnonymous,
                    ),
                    onDismiss: () {
                      BlocProvider.of<NotificationBloc>(context)
                          .add(DismissNotification());
                    },
                  ),
                ),
              );
            }
            this.onClose(didUpdate);
          },
        ),
      ),
      animationMillis: 500,
    );
  }
}

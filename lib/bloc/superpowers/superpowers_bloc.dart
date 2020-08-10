import 'package:delphis_app/bloc/notification/notification_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/widgets/overlay/overlay_top_message.dart';
import 'package:delphis_app/widgets/text_overlay_notification/incognito_mode_overlay.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

part 'superpowers_event.dart';
part 'superpowers_state.dart';

class SuperpowersBloc extends Bloc<SuperpowersEvent, SuperpowersState> {
  final NotificationBloc notificationBloc;
  final DiscussionRepository discussionRepository;
  final ParticipantRepository participantRepository;
  SuperpowersBloc({
    @required this.notificationBloc,
    @required this.discussionRepository,
    @required this.participantRepository,
  }) : super(ReadyState());

  @override
  Stream<SuperpowersState> mapEventToState(SuperpowersEvent event) async* {
    if (event is ResetEvent) {
      yield ReadyState();
    } else if (event is DeletePostEvent) {
      if (this.state is ReadyState) {
        yield LoadingState();
        try {
          var deletedPost = await discussionRepository.deletePost(
              event.discussion, event.post);
          yield DeletePostSuccessState(
              message: Intl.message("The post has been successfully deleted!"),
              post: deletedPost);
        } catch (error) {
          if (error is OperationException) {
            yield ErrorState(message: error.graphqlErrors[0].message);
          } else {
            yield ErrorState(message: error.toString());
          }
        }
      }
    } else if (event is BanParticipantEvent) {
      if (this.state is ReadyState) {
        yield LoadingState();
        try {
          var bannedParticipant = await participantRepository.banParticipant(
              event.discussion, event.participant);
          yield BanParticipantSuccessState(
            message:
                Intl.message("The participant has been successfully banned!"),
            participant: bannedParticipant,
          );
        } catch (error) {
          if (error is OperationException) {
            yield ErrorState(message: error.graphqlErrors[0].message);
          } else {
            yield ErrorState(message: error.toString());
          }
        }
      }
    } else if (event is CopyDiscussionLinkEvent) {
      if (this.state is ReadyState) {
        var link = event.discussion.discussionAccessLink.url;
        Clipboard.setData(ClipboardData(text: link));
        notificationBloc.add(NewNotificationEvent(
            notification: OverlayTopMessage(
          child: IncognitoModeTextOverlay(
              hasGoneIncognito: false,
              textOverride: Intl.message(
                  "An invitation link to this discussion was copied to clipboard!")),
          onDismiss: () {
            notificationBloc.add(DismissNotification());
          },
        )));
        yield ReadyState();
      }
    } else if (event is MuteParticipantEvent) {
      if (this.state is ReadyState) {
        yield LoadingState();
        try {
          var mutedParticipants = await participantRepository.muteParticipants(
            event.discussion,
            event.participants,
            event.muteForSeconds,
          );
          yield MuteUnmuteParticipantsSuccessState(
            message: Intl.message(
                "These participants have been successfully muted!"),
            participants: mutedParticipants,
          );
        } catch (error) {
          if (error is OperationException) {
            yield ErrorState(message: error.graphqlErrors[0].message);
          } else {
            yield ErrorState(message: error.toString());
          }
        }
      }
    } else if (event is UnmuteParticipantEvent) {
      if (this.state is ReadyState) {
        yield LoadingState();
        try {
          var unmutedParticipants =
              await participantRepository.unmuteParticipants(
            event.discussion,
            event.participants,
          );
          yield MuteUnmuteParticipantsSuccessState(
            message: Intl.message(
                "These participants have been successfully muted!"),
            participants: unmutedParticipants,
          );
        } catch (error) {
          if (error is OperationException) {
            yield ErrorState(message: error.graphqlErrors[0].message);
          } else {
            yield ErrorState(message: error.toString());
          }
        }
      }
    }
  }
}

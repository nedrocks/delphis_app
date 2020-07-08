import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

part 'superpowers_event.dart';
part 'superpowers_state.dart';

class SuperpowersBloc extends Bloc<SuperpowersEvent, SuperpowersState> {

  final DiscussionRepository discussionRepository;
  final ParticipantRepository participantRepository;

  SuperpowersBloc({
    @required this.discussionRepository,
    @required this.participantRepository
  }) : super(ReadyState());

  @override
  Stream<SuperpowersState> mapEventToState(SuperpowersEvent event) async* {
    if(event is ResetEvent) {
      yield ReadyState();
    }
    else if(event is DeletePostEvent) {
      if(this.state is ReadyState) {
        yield LoadingState();
        try {
          var deletedPost = await discussionRepository.deletePost(event.discussion, event.post);
          event.discussion.postsCache = event.discussion.postsCache
            .map((p) {
              if(p.id == event.post.id)
                return deletedPost;
              return p;
            })
            .toList();
          yield DeletePostSuccessState(
            message: Intl.message("The post has been successfully deleted!"),
            post: deletedPost
          );
        }
        catch (error) {
          if(error is OperationException) {
            yield ErrorState(message: error.graphqlErrors[0].message);
          }
          else {
            yield ErrorState(message: error.toString());
          }
        }
      }
    }
    else if(event is BanParticipantEvent) {
      if(this.state is ReadyState) {
        yield LoadingState();
        try {
          var bannedParticipant = await participantRepository.banParticipant(event.discussion, event.participant);
          event.discussion.postsCache = event.discussion.postsCache
            .map((p) {
              if(p.participant.id == event.participant.id)
                return p.copyWith(isDeleted: true, deletedReasonCode: PostDeletedReason.MODERATOR_REMOVED);
              return p;
            })
            .toList();
          yield BanParticipantSuccessState(
            message: Intl.message("The participant has been successfully banned!"),
            participant: bannedParticipant
          );
        }
        catch (error) {
          if(error is OperationException) {
            yield ErrorState(message: error.graphqlErrors[0].message);
          }
          else {
            yield ErrorState(message: error.toString());
          }
        }
      }
    }
  }

}
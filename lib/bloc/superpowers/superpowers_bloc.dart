import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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
          var deletedPostIndex = event.discussion.postsCache.indexWhere((element) => element.id == event.post.id);
          event.discussion.postsCache.replaceRange(deletedPostIndex, deletedPostIndex + 1, [deletedPost]);
          yield DeletePostSuccessState(
            message: Intl.message("The post has been successfully deleted!"),
            post: deletedPost
          );
        }
        catch (error) {
          yield ErrorState(message: error.toString());
        }
      }
    }
    else if(event is BanParticipantEvent) {
      if(this.state is ReadyState) {
        yield LoadingState();
        try {
          var bannedParticipant = await participantRepository.banParticipant(event.discussion, event.participant);
          yield BanParticipantSuccessState(
            message: Intl.message("The participant has been successfully banned!"),
            participant: bannedParticipant
          );
        }
        catch (error) {
          yield ErrorState(message: error.toString());
        }
      }
    }
  }

}
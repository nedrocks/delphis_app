import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'moderator_event.dart';
part 'moderator_state.dart';

class ModeratorBloc extends Bloc<ModeratorEvent, ModeratorState> {

  final DiscussionRepository discussionRepository;
  final ParticipantRepository participantRepository;

  ModeratorBloc({
    @required this.discussionRepository,
    @required this.participantRepository
  }) : super(ReadyState());

  @override
  Stream<ModeratorState> mapEventToState(ModeratorEvent event) async* {
    if(event is CloseEvent) {
      yield ReadyState();
    }
    else if(event is DeletePostEvent) {
      if(this.state is ReadyState) {
        
      }
    }
    else if(event is KickParticipantEvent) {
      if(this.state is ReadyState) {
        
      }
    }
  }

}
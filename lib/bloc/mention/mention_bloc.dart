import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/entity.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/util/display_names.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'mention_event.dart';
part 'mention_state.dart';

class MentionBloc extends Bloc<MentionEvent, MentionState> {
  MentionBloc() : super(MentionState());

  @override
  Stream<MentionState> mapEventToState(MentionEvent event) async* {
    if (event is AddMentionDataEvent) {
      yield this.state.copyWith(
            discussion: event.discussion ?? this.state.discussion,
            discussions: event.discussions ?? this.state.discussions,
          );
    } else {
      yield this.state;
    }
  }
}

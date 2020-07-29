part of 'upsert_discussion_bloc.dart';

abstract class UpsertDiscussionState extends Equatable {
  UpsertDiscussionInfo get info;
}

abstract class UpsertDiscussionLoadingState extends UpsertDiscussionState {
  DateTime get timestamp;

  List<Object> get props => [timestamp, info];
}

class UpsertDiscussionErrorState extends UpsertDiscussionState {
  final DateTime timestamp = DateTime.now();
  final UpsertDiscussionInfo info;
  final error;

  UpsertDiscussionErrorState(this.info, this.error);

  @override
  List<Object> get props => [timestamp, info, error];
}

class UpsertDiscussionReadyState extends UpsertDiscussionState {
  final DateTime timestamp = DateTime.now();
  final UpsertDiscussionInfo info;

  UpsertDiscussionReadyState(this.info);

  @override
  List<Object> get props => [info, timestamp];
}

class UpsertDiscussionCreateLoadingState extends UpsertDiscussionState {
  final DateTime timestamp = DateTime.now();
  final UpsertDiscussionInfo info;

  UpsertDiscussionCreateLoadingState(this.info);

  @override
  List<Object> get props => [info, timestamp];
}

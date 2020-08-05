part of 'discussion_list_bloc.dart';

abstract class DiscussionListState extends Equatable {
  final List<Discussion> activeDiscussions = [];
  final List<Discussion> archivedDiscussions = [];
  final List<Discussion> deletedDiscussions = [];

  DiscussionListState();

  @override
  List<Object> get props => [
        activeDiscussions.map((d) => d.id).toList(),
        archivedDiscussions.map((d) => d.id).toList(),
        deletedDiscussions.map((d) => d.id).toList(),
      ];
}

abstract class DiscussionListHasTimestamp extends DiscussionListState {
  DateTime get timestamp;
}

class DiscussionListInitial extends DiscussionListState {}

class DiscussionListError extends DiscussionListHasTimestamp {
  final List<Discussion> activeDiscussions;
  final List<Discussion> archivedDiscussions;
  final List<Discussion> deletedDiscussions;
  final error;
  final DateTime timestamp;

  DiscussionListError({
    @required this.activeDiscussions,
    @required this.archivedDiscussions,
    @required this.deletedDiscussions,
    @required this.error,
    @required this.timestamp,
  }) : super();

  @override
  List<Object> get props => [
        this.activeDiscussions.map((d) => d.id).toList(),
        this.archivedDiscussions.map((d) => d.id).toList(),
        this.deletedDiscussions.map((d) => d.id).toList(),
        this.error,
        this.timestamp,
      ];
}

class DiscussionListLoading extends DiscussionListHasTimestamp {
  final List<Discussion> activeDiscussions;
  final List<Discussion> archivedDiscussions;
  final List<Discussion> deletedDiscussions;
  final DateTime timestamp;

  DiscussionListLoading({
    @required this.activeDiscussions,
    @required this.archivedDiscussions,
    @required this.deletedDiscussions,
    @required this.timestamp,
  }) : super();

  @override
  List<Object> get props => [
        this.activeDiscussions.map((d) => d.id).toList(),
        this.archivedDiscussions.map((d) => d.id).toList(),
        this.deletedDiscussions.map((d) => d.id).toList(),
        this.timestamp,
      ];
}

class DiscussionListLoaded extends DiscussionListHasTimestamp {
  final List<Discussion> activeDiscussions;
  final List<Discussion> archivedDiscussions;
  final List<Discussion> deletedDiscussions;
  final DateTime timestamp;

  DiscussionListLoaded({
    @required this.activeDiscussions,
    @required this.archivedDiscussions,
    @required this.deletedDiscussions,
    @required this.timestamp,
  }) : super();

  @override
  List<Object> get props => [
        this.activeDiscussions.map((d) => d.id).toList(),
        this.archivedDiscussions.map((d) => d.id).toList(),
        this.deletedDiscussions.map((d) => d.id).toList(),
        this.timestamp,
      ];
}

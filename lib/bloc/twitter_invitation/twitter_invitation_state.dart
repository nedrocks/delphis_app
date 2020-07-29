part of 'twitter_invitation_bloc.dart';

abstract class TwitterInvitationState extends Equatable {
  const TwitterInvitationState();
}

class TwitterInvitationInitialState extends TwitterInvitationState {
  @override
  List<Object> get props => [];
}

abstract class TwitterInvitationLoadingState extends TwitterInvitationState {
  final DateTime timestamp;

  TwitterInvitationLoadingState({this.timestamp});

  @override
  List<Object> get props => [this.timestamp];
}

class TwitterInvitationErrorState extends TwitterInvitationState {
  final DateTime timestamp;
  final error;

  TwitterInvitationErrorState({this.timestamp, this.error});

  @override
  List<Object> get props => [this.timestamp, this.error];
}

class TwitterInvitationSearchLoadingState
    extends TwitterInvitationLoadingState {
  final String query;

  TwitterInvitationSearchLoadingState({timestamp, this.query})
      : super(timestamp: timestamp);
}

class TwitterInvitationInviteLoadingState
    extends TwitterInvitationLoadingState {
  TwitterInvitationInviteLoadingState({timestamp})
      : super(timestamp: timestamp);
}

class TwitterInvitationSearchSuccessState extends TwitterInvitationState {
  final DateTime timestamp;
  final String query;
  final List<TwitterUserInfo> autocompletes;

  const TwitterInvitationSearchSuccessState(
      {this.timestamp, this.query, this.autocompletes});

  @override
  List<Object> get props => [this.timestamp, this.query, this.autocompletes];
}

class TwitterInvitationInviteSuccessState extends TwitterInvitationState {
  final DateTime timestamp;
  final List<DiscussionInvite> invites;

  const TwitterInvitationInviteSuccessState({this.timestamp, this.invites});

  @override
  List<Object> get props => [this.timestamp, this.invites];
}

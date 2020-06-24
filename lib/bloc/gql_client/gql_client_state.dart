part of 'gql_client_bloc.dart';

abstract class GqlClientState extends Equatable {
  const GqlClientState();
}

class GqlClientInitial extends GqlClientState {
  @override
  List<Object> get props => [];
}

class GqlClientConnectingState extends GqlClientState {
  final GraphQLClient client;
  final SocketClient websocketGQLClient;
  // The clients do not have any sort of equality mechanism and the underlying
  // data structures are final so we can't change them. Use this for equatability.
  final String equatableID;
  // We shouldn't denormalize the data from the auth bloc but they are inter
  // dependent. We do receive updates from auth so we will update the state variable.
  final String authString;
  final bool isAuthed;

  const GqlClientConnectingState({
    @required this.equatableID,
    @required this.client,
    this.websocketGQLClient,
    this.isAuthed = false,
    this.authString,
  }) : super();

  @override
  List<Object> get props => [this.equatableID];
}

class GqlClientConnectedState extends GqlClientState {
  final GraphQLClient client;
  final SocketClient websocketGQLClient;
  // The clients do not have any sort of equality mechanism and the underlying
  // data structures are final so we can't change them. Use this for equatability.
  final String equatableID;
  // We shouldn't denormalize the data from the auth bloc but they are inter
  // dependent. We do receive updates from auth so we will update the state variable.
  final String authString;
  final bool isAuthed;

  const GqlClientConnectedState({
    @required this.equatableID,
    @required this.client,
    this.websocketGQLClient,
    this.isAuthed = false,
    this.authString,
  }) : super();

  @override
  List<Object> get props => [this.equatableID];
}

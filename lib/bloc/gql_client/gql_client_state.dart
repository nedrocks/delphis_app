part of 'gql_client_bloc.dart';

abstract class GqlClientState extends Equatable {
  const GqlClientState();
}

class GqlClientInitial extends GqlClientState {
  @override
  List<Object> get props => [];
}

class GqlClientConnectedState extends GqlClientState {
  final GraphQLClient client;
  final SocketClient websocketGQLClient;
  // The clients do not have any sort of equality mechanism and the underlying
  // data structures are final so we can't change them. Use this for equatability.
  final String equatableID;

  const GqlClientConnectedState({
    @required this.equatableID,
    @required this.client,
    this.websocketGQLClient,
  }) : super();

  @override
  List<Object> get props => [this.equatableID];
}

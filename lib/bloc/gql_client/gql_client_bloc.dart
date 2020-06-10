import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/constants.dart';
import 'package:delphis_app/tracking/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

part 'gql_client_event.dart';
part 'gql_client_state.dart';

class GqlClientBloc extends Bloc<GqlClientEvent, GqlClientState> {
  final AuthBloc authBloc;
  StreamSubscription websocketStateListener;

  GqlClientBloc({
    @required this.authBloc,
  }) : super() {
    this.authBloc.listen((state) {
      if (state is InitializedAuthState) {
        this.add(GqlClientAuthChanged(
            isAuthed: state.isAuthed, authString: state.authString));
      }
    });
  }

  GraphQLClient getClient() {
    final state = this.state;
    if (state is GqlClientConnectedState) {
      return state.client;
    } else {
      return null;
    }
  }

  SocketClient getWebsocketClient() {
    final state = this.state;
    if (state is GqlClientConnectedState) {
      return state.websocketGQLClient;
    } else {
      return null;
    }
  }

  @override
  GqlClientState get initialState => GqlClientInitial();

  @override
  Stream<GqlClientState> mapEventToState(
    GqlClientEvent event,
  ) async* {
    final currentState = this.state;
    if (event is GqlClientAuthChanged) {
      if (currentState is GqlClientConnectedState) {
        final currentClient = currentState.client;
        final currentSocketClient = currentState.websocketGQLClient;
        if (currentClient != null) {
          // There is no dispose required here.
        }
        if (currentSocketClient != null) {
          currentSocketClient.dispose();
        }
      }
      GraphQLClient gqlClient;
      SocketClient socketClient;
      final HttpLink httpLink = HttpLink(
        uri: Constants.gqlEndpoint,
      );
      final AuthLink authLink = AuthLink(getToken: () async {
        if (event.isAuthed) {
          return 'Bearer ${event.authString}';
        }
        return 'Bearer ';
      });
      Link link = authLink.concat(httpLink);

      var wsEndpoint = '${Constants.wsEndpoint}';
      if (event.isAuthed) {
        wsEndpoint = '$wsEndpoint?access_token=${event.authString}';
      }

      gqlClient = GraphQLClient(
        // TODO: Move this into a global scope that is reused?
        cache: InMemoryCache(),
        link: link,
      );
      socketClient = SocketClient(wsEndpoint);

      Segment.track(
          eventName: ChathamTrackingEventNames.BACKEND_CONNECTION,
          properties: {
            // TODO: Update this to have the correct success metric.
            'success': true,
            'isAuthed': event.isAuthed,
          });

      this.websocketStateListener =
          socketClient.connectionState.listen((cxState) {
        if (cxState == SocketConnectionState.CONNECTED) {
          this.add(GqlClientSocketConnected());
          // TODO: Keep this going and listen for when we lose the connection
          // so we can reestablish it!
          this.websocketStateListener.cancel();
        }
      });
      yield GqlClientConnectingState(
          client: gqlClient,
          websocketGQLClient: socketClient,
          equatableID: DateTime.now().toString());
    } else if (event is GqlClientSocketConnected &&
        currentState is GqlClientConnectingState) {
      yield GqlClientConnectedState(
          client: currentState.client,
          websocketGQLClient: currentState.websocketGQLClient,
          equatableID: currentState.equatableID);
    }
  }
}

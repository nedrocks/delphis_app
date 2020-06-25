import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/constants.dart';
import 'package:delphis_app/tracking/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

part 'gql_client_event.dart';
part 'gql_client_state.dart';

class GqlClientBloc extends Bloc<GqlClientEvent, GqlClientState> {
  StreamSubscription websocketStateListener;

  GqlClientBloc() : super();

  @override
  Future<void> close() async {
    this.websocketStateListener?.cancel();
    super.close();
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

  SocketClient connectWebsocket(bool isAuthed, String authString) {
    var wsEndpoint = '${Constants.wsEndpoint}';
    if (isAuthed) {
      wsEndpoint = '$wsEndpoint?access_token=$authString';
    }

    final socketClient = SocketClient(wsEndpoint);

    if (this.websocketStateListener != null) {
      this.websocketStateListener.cancel();
      this.websocketStateListener = null;
    }

    this.websocketStateListener =
        socketClient.connectionState.listen((cxState) async {
      if (cxState == SocketConnectionState.CONNECTED) {
        this.add(GqlClientSocketConnected());
      } else if (cxState == SocketConnectionState.NOT_CONNECTED) {
        this.websocketStateListener.cancel();
        this.websocketStateListener = null;
        await socketClient.dispose();

        this.add(GqlClientReconnectWebsocketEvent(nonce: DateTime.now()));
      }
    });

    return socketClient;
  }

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

      gqlClient = GraphQLClient(
        // TODO: Move this into a global scope that is reused?
        cache: InMemoryCache(),
        link: link,
      );

      Segment.track(
          eventName: ChathamTrackingEventNames.BACKEND_CONNECTION,
          properties: {
            // TODO: Update this to have the correct success metric.
            'success': true,
            'isAuthed': event.isAuthed,
          });

      socketClient = this.connectWebsocket(event.isAuthed, event.authString);

      yield GqlClientConnectingState(
        client: gqlClient,
        websocketGQLClient: socketClient,
        equatableID: DateTime.now().toString(),
        authString: event.authString,
        isAuthed: event.isAuthed,
      );
    } else if (event is GqlClientSocketConnected &&
        currentState is GqlClientConnectingState) {
      yield GqlClientConnectedState(
          client: currentState.client,
          websocketGQLClient: currentState.websocketGQLClient,
          equatableID: currentState.equatableID,
          isAuthed: currentState.isAuthed,
          authString: currentState.authString);
    } else if (event is GqlClientReconnectWebsocketEvent &&
        currentState is GqlClientConnectedState) {
      final socketClient =
          this.connectWebsocket(currentState.isAuthed, currentState.authString);
      yield GqlClientConnectingState(
        client: currentState.client,
        websocketGQLClient: socketClient,
        equatableID: DateTime.now().toString(),
        authString: currentState.authString,
        isAuthed: currentState.isAuthed,
      );
    }
  }
}

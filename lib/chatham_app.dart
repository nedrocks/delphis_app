import 'dart:io';
import 'dart:async';

import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/screens/auth/base/sign_in.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/discussion/discussion_bloc.dart';
import 'bloc/me/me_bloc.dart';
import 'bloc/participant/participant_bloc.dart';
import 'data/repository/auth.dart';
import 'package:delphis_app/screens/auth/index.dart';
import 'package:delphis_app/screens/discussion/discussion.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'constants.dart';
import 'data/repository/participant.dart';
import 'data/repository/user_device.dart';
import 'design/text_theme.dart';
import 'screens/intro/intro_screen.dart';

class ChathamApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChathamAppState();
}

class ChathamAppState extends State<ChathamApp> {
  static const methodChannel = const MethodChannel('chatham.ai/push_token');
  //static const platform = const MethodChannel('samples.flutter.dev/battery');

  FlutterSecureStorage secureStorage;
  bool isInitialized;
  AuthBloc authBloc;
  MeBloc meBloc;
  GraphQLClient gqlClient;
  SocketClient websocketGQLClient;

  String deviceID;
  bool didReceivePushToken;
  String pushToken;
  bool hasSentDeviceToServer;

  @override
  void dispose() {
    this.authBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    ChathamAppState.methodChannel
        .setMethodCallHandler(this._didReceiveTokenAndDeviceID);

    this.secureStorage = FlutterSecureStorage();
    this.authBloc = AuthBloc(DelphisAuthRepository(this.secureStorage))
      ..add(FetchAuthEvent());
    isInitialized = false;
    this.authBloc.listen((state) {
      if (state is InitializedAuthState) {
        setState(() {
          this.isInitialized = true;
        });
      }
    });
    this.deviceID = "";
    this.didReceivePushToken = false;
    this.hasSentDeviceToServer = false;
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding base app');
    final HttpLink httpLink = HttpLink(
      uri: Constants.gqlEndpoint,
    );

    final AuthLink authLink = AuthLink(getToken: () async {
      if (this.authBloc.state is InitializedAuthState &&
          (this.authBloc.state as InitializedAuthState).isAuthed) {
        return 'Bearer ${(this.authBloc.state as InitializedAuthState).authString}';
      }
      return 'Bearer ';
    });
    Link link = authLink.concat(httpLink);

    gqlClient = GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    );

    var wsEndpoint = '${Constants.wsEndpoint}';
    if (this.authBloc.state is InitializedAuthState &&
        (this.authBloc.state as InitializedAuthState).isAuthed) {
      wsEndpoint =
          '$wsEndpoint?access_token=${(this.authBloc.state as InitializedAuthState).authString}';
    }
    websocketGQLClient = SocketClient(
      wsEndpoint,
    );

    final discussionRepository =
        DiscussionRepository(gqlClient, websocketGQLClient);
    final participantRepository =
        ParticipantRepository(gqlClient, websocketGQLClient);
    final userRepository = UserRepository(gqlClient);
    final userDeviceRepository = UserDeviceRepository(gqlClient);

    ValueNotifier<GraphQLClient> client = ValueNotifier(gqlClient);
    return GraphQLProvider(
        client: client,
        child: MultiBlocProvider(
          providers: <BlocProvider>[
            BlocProvider<AuthBloc>.value(value: this.authBloc),
            BlocProvider<MeBloc>(
                create: (context) => MeBloc(userRepository, this.authBloc)),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<AuthBloc, AuthState>(
                  listener: (context, AuthState state) {
                if (state is InitializedAuthState && state.isAuthed) {
                  BlocProvider.of<MeBloc>(context).add(FetchMeEvent());
                } else if (state is InitializedAuthState && !state.isAuthed) {
                  this.sendDeviceToServer(userDeviceRepository, null);
                }
              }),
              BlocListener<MeBloc, MeState>(listener: (context, MeState state) {
                if (state is LoadedMeState) {
                  this.sendDeviceToServer(userDeviceRepository, state.me);
                }
              })
            ],
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, AuthState state) {
                if (state is InitializedAuthState && state.isAuthed) {
                  BlocProvider.of<MeBloc>(context).add(FetchMeEvent());
                }
              },
              child: MaterialApp(
                title: "Chatham",
                theme: kThemeData,
                initialRoute: '/Intro',
                routes: {
                  '/Intro': (context) =>
                      IntroScreen(isInitialized: isInitialized),
                  // This is a bit dicy but presumably any descendent of this page should listen
                  // for the logout event.
                  '/': (context) => BlocProvider<DiscussionBloc>(
                        lazy: true,
                        create: (context) =>
                            DiscussionBloc(repository: discussionRepository)
                              ..add(DiscussionQueryEvent(
                                  //'2589fb41-e6c5-4950-8b75-55bb3315113e')),
                                  'c5409fad-e624-4de8-bb32-36453c562abf')),
                        //'c5409fad-e624-4de8-bb32-36453c562abf')),
                        child: BlocProvider<ParticipantBloc>(
                          lazy: true,
                          create: (context) => ParticipantBloc(
                              repository: participantRepository,
                              discussionBloc:
                                  BlocProvider.of<DiscussionBloc>(context)),
                          child: BlocListener<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is LoggedOutAuthState) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/Auth', (Route<dynamic> route) => false);
                              }
                            },
                            child: DelphisDiscussion(),
                          ),
                        ),
                      ),
                  '/Auth': (context) => SignInScreen(
                      onTwitterPressed: () =>
                          {Navigator.of(context).pushNamed('/Auth/Twitter')}),
                  '/Auth/Twitter': (context) => LoginScreen(),
                },
              ),
            ),
          ),
        ));
  }

  void sendDeviceToServer(UserDeviceRepository repository, User me) {
    if (!this.hasSentDeviceToServer &&
        this.didReceivePushToken &&
        this.deviceID != null &&
        this.deviceID.length > 0) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        this.setState(() {
          if (!this.hasSentDeviceToServer) {
            this.hasSentDeviceToServer = true;
            var platform = ChathamPlatform.UNKNOWN;
            if (Platform.isIOS) {
              platform = ChathamPlatform.IOS;
            } else if (Platform.isAndroid) {
              platform = ChathamPlatform.ANDROID;
            }
            repository.upsertUserDevice(
                me?.id, this.pushToken, platform, this.deviceID);
          }
        });
      });
    } else if (!this.hasSentDeviceToServer) {
      // This is pretty gross but will work..
      Future.delayed(const Duration(seconds: 5), () {
        this.sendDeviceToServer(repository, me);
      });
    }
  }

  Future<void> _didReceiveTokenAndDeviceID(MethodCall call) async {
    final String args = call.arguments;
    switch (call.method) {
      case "didReceiveToken":
        this.setState(() {
          this.didReceivePushToken = true;
          if (args.length > 0) {
            this.pushToken = args;
          }
        });
        break;
      case "didReceiveDeviceID":
        this.setState(() {
          this.deviceID = args;
        });
        break;
      case "didReceiveTokenAndDeviceID":
        final parts = args.split('.');
        if (parts.length == 1) {
          // Only device ID
          this.setState(() {
            this.deviceID = parts[0].trim();
            this.didReceivePushToken = true;
          });
        } else if (parts.length == 2) {
          this.setState(() {
            this.deviceID = parts[0].trim();
            this.pushToken = parts[1].trim();
            this.didReceivePushToken = true;
          });
        }
        break;
    }
  }
}

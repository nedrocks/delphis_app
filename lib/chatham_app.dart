import 'dart:io';
import 'dart:async';

import 'package:delphis_app/bloc/app/app_bloc.dart';
import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/screens/auth/base/sign_in.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/discussion/discussion_bloc.dart';
import 'bloc/me/me_bloc.dart';
import 'bloc/participant/participant_bloc.dart';
import 'data/repository/auth.dart';
import 'package:delphis_app/screens/auth/index.dart';
import 'package:delphis_app/screens/discussion/discussion.dart';
import 'package:flutter/material.dart';

import 'data/repository/participant.dart';
import 'data/repository/user_device.dart';
import 'design/text_theme.dart';
import 'screens/intro/intro_screen.dart';

class ChathamApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChathamAppState();
}

class ChathamAppState extends State<ChathamApp> with WidgetsBindingObserver {
  static const methodChannel = const MethodChannel('chatham.ai/push_token');

  FlutterSecureStorage secureStorage;
  bool isInitialized;
  AuthBloc authBloc;
  MeBloc meBloc;
  GqlClientBloc gqlClientBloc;
  AppBloc appBloc;

  String deviceID;
  bool didReceivePushToken;
  String pushToken;
  bool hasSentDeviceToServer;
  bool requiresReload;

  @override
  void dispose() {
    this.authBloc.close();
    this.meBloc.close();
    this.gqlClientBloc.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    this.appBloc = AppBloc();
    WidgetsBinding.instance.addObserver(this);

    ChathamAppState.methodChannel
        .setMethodCallHandler(this._didReceiveTokenAndDeviceID);

    this.secureStorage = FlutterSecureStorage();
    this.authBloc = AuthBloc(DelphisAuthRepository(this.secureStorage));
    this.gqlClientBloc = GqlClientBloc(authBloc: this.authBloc);
    this.authBloc.add(FetchAuthEvent());

    this.isInitialized = false;
    this.authBloc.listen((state) {
      if (state is InitializedAuthState && !this.isInitialized) {
        setState(() {
          this.isInitialized = true;
        });
      }
    });
    this.deviceID = "";
    this.didReceivePushToken = false;
    this.hasSentDeviceToServer = false;

    this.requiresReload = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    this.appBloc.add(AppLifecycleChanged(lifecycle: state));
  }

  @override
  Widget build(BuildContext context) {
    final discussionRepository =
        DiscussionRepository(clientBloc: this.gqlClientBloc);
    final participantRepository =
        ParticipantRepository(clientBloc: this.gqlClientBloc);
    final userRepository = UserRepository(clientBloc: this.gqlClientBloc);
    final userDeviceRepository =
        UserDeviceRepository(clientBloc: this.gqlClientBloc);

    return MultiBlocProvider(
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
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return PageTransition(
                    type: PageTransitionType.fade,
                    child: BlocProvider<DiscussionBloc>(
                      lazy: true,
                      create: (context) =>
                          DiscussionBloc(repository: discussionRepository),
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
                          child: DelphisDiscussion(
                            discussionID:
                                '2589fb41-e6c5-4950-8b75-55bb3315113e',
                            //discussionID: 'c5409fad-e624-4de8-bb32-36453c562abf',
                          ),
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
                        child: DelphisDiscussion(
                          //discussionID: '2589fb41-e6c5-4950-8b75-55bb3315113e',
                          discussionID: 'c5409fad-e624-4de8-bb32-36453c562abf',
                        ),
                      ),
                    ),
                  );
                  break;
                case '/Auth':
                  return PageTransition(
                    type: PageTransitionType.fade,
                    child: SignInScreen(),
                  );
                  break;
                default:
                  return null;
              }
            },
            routes: {
              '/Intro': (context) => IntroScreen(isInitialized: isInitialized),
              '/Auth/Twitter': (context) => LoginScreen(),
            },
          ),
        ),
      ),
    );
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

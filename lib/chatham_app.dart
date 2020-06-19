import 'dart:io';
import 'dart:async';

import 'package:delphis_app/bloc/app/app_bloc.dart';
import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/screens/auth/base/sign_in.dart';
import 'package:delphis_app/util/route_observer.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uni_links/uni_links.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/discussion/discussion_bloc.dart';
import 'bloc/me/me_bloc.dart';
import 'bloc/notification/notification_bloc.dart';
import 'bloc/participant/participant_bloc.dart';
import 'constants.dart';
import 'data/repository/auth.dart';
import 'package:delphis_app/screens/discussion/discussion.dart';
import 'package:flutter/material.dart';

import 'data/repository/participant.dart';
import 'data/repository/user_device.dart';
import 'design/text_theme.dart';
import 'screens/discussion/screen_args/discussion.dart';
import 'screens/home_page/home_page.dart';
import 'screens/intro/intro_screen.dart';

class ChathamApp extends StatefulWidget {
  final Environment env;

  const ChathamApp({
    @required this.env,
  });

  @override
  State<StatefulWidget> createState() => ChathamAppState();
}

final navKey = GlobalKey<NavigatorState>();

class ChathamAppState extends State<ChathamApp>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  static const methodChannel = const MethodChannel('chatham.ai/push_token');

  FlutterSecureStorage secureStorage;
  AuthBloc authBloc;
  MeBloc meBloc;
  GqlClientBloc gqlClientBloc;
  AppBloc appBloc;
  NotificationBloc notifBloc;

  UserRepository userRepository;

  String deviceID;
  bool didReceivePushToken;
  String pushToken;
  bool hasSentDeviceToServer;
  bool requiresReload;

  RouteObserver _routeObserver;

  Key _homePageKey;

  StreamSubscription _deepLinkSubscription;
  Uri _latestDeeplinkURI;
  String _latestDeeplink = 'Unknown';

  @override
  void dispose() {
    if (_deepLinkSubscription != null) {
      _deepLinkSubscription.cancel();
    }
    this.authBloc.close();
    this.meBloc.close();
    this.gqlClientBloc.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Smartlook.setupAndStartRecording(
    //     'b014d394b5b6be3ea88a8f3fab8aa04c1a670aca');

    this.appBloc = AppBloc();
    WidgetsBinding.instance.addObserver(this);

    ChathamAppState.methodChannel
        .setMethodCallHandler(this._didReceiveTokenAndDeviceID);

    this.secureStorage = FlutterSecureStorage();
    this.authBloc = AuthBloc(DelphisAuthRepository(this.secureStorage));
    this.gqlClientBloc = GqlClientBloc();
    this.notifBloc = NotificationBloc(navKey: navKey);
    this.authBloc.add(FetchAuthEvent());
    this.userRepository = UserRepository(clientBloc: this.gqlClientBloc);
    this.meBloc = MeBloc(this.userRepository, this.authBloc);
    this.deviceID = "";
    this.didReceivePushToken = false;
    this.hasSentDeviceToServer = false;

    this.requiresReload = false;

    this._routeObserver = chathamRouteObserverSingleton;
    this._homePageKey = Key('${DateTime.now().microsecondsSinceEpoch}');

    Segment.enable();

    Segment.setContext({
      'env': this.widget.env.toString(),
    });

    this.initPlatformState();
  }

  void initPlatformState() async {
    // Attach a listener to the links stream
    _deepLinkSubscription = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestDeeplink = link ?? 'Unknown';
        _latestDeeplinkURI = null;
        try {
          if (link != null) _latestDeeplinkURI = Uri.parse(link);
        } on FormatException {}
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestDeeplink = 'Failed to get latest link: $err.';
        _latestDeeplinkURI = null;
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      print('got link: $link');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      print('initial link: $initialLink');
      if (initialLink != null) initialUri = Uri.parse(initialLink);
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      initialUri = null;
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestDeeplink = initialLink;
      _latestDeeplinkURI = initialUri;
    });
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
    final userDeviceRepository =
        UserDeviceRepository(clientBloc: this.gqlClientBloc);
    // I am not sure what will happen if we leak this Bloc between discussions.
    // We may need to reset the state of the discussion bloc whenever the route changes.
    final discussionBloc = DiscussionBloc(repository: discussionRepository);

    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<GqlClientBloc>.value(value: this.gqlClientBloc),
        BlocProvider<AuthBloc>.value(value: this.authBloc),
        BlocProvider<MeBloc>.value(value: this.meBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
              listener: (context, AuthState state) {
            if (state is InitializedAuthState) {
              this.gqlClientBloc.add(GqlClientAuthChanged(
                  isAuthed: state.isAuthed, authString: state.authString));
            }
          }),
          BlocListener<GqlClientBloc, GqlClientState>(
              listener: (context, state) {
            final authState = this.authBloc.state;
            if (authState is InitializedAuthState &&
                authState.isAuthed &&
                state is GqlClientConnectedState) {
              BlocProvider.of<MeBloc>(context).add(FetchMeEvent());
            } else if (authState is InitializedAuthState &&
                !authState.isAuthed) {
              this.sendDeviceToServer(userDeviceRepository, null);
            }
          }),
          BlocListener<MeBloc, MeState>(listener: (context, MeState state) {
            if (state is LoadedMeState) {
              this.sendDeviceToServer(userDeviceRepository, state.me);
            }
          }),
        ],
        child: MaterialApp(
          navigatorKey: navKey,
          title: "Chatham",
          theme: kThemeData,
          initialRoute: '/Intro',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/Home':
                return PageTransition(
                  settings: settings,
                  type: PageTransitionType.fade,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider<NotificationBloc>.value(
                        value: this.notifBloc,
                      ),
                      BlocProvider<DiscussionBloc>.value(
                        value: discussionBloc,
                      ),
                      BlocProvider<ParticipantBloc>(
                        lazy: true,
                        create: (context) => ParticipantBloc(
                            repository: participantRepository,
                            discussionBloc: discussionBloc),
                      ),
                    ],
                    child: BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is LoggedOutAuthState) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/Auth',
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      child: HomePageScreen(
                        key: this._homePageKey,
                        discussionBloc: discussionBloc,
                        discussionRepository: discussionRepository,
                        routeObserver: this._routeObserver,
                      ),
                    ),
                  ),
                );
                break;
              case '/Discussion':
                DiscussionArguments arguments =
                    settings.arguments as DiscussionArguments;
                return PageTransition(
                  settings: settings,
                  type: PageTransitionType.rightToLeft,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider<NotificationBloc>.value(
                        value: this.notifBloc,
                      ),
                      BlocProvider<DiscussionBloc>.value(
                        value: discussionBloc,
                      ),
                      BlocProvider<ParticipantBloc>(
                        lazy: true,
                        create: (context) => ParticipantBloc(
                            repository: participantRepository,
                            discussionBloc: discussionBloc),
                      ),
                    ],
                    child: BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is LoggedOutAuthState) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/Auth',
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      child: DelphisDiscussion(
                        key: Key('discussion-screen-${arguments.discussionID}'),
                        discussionID: arguments.discussionID,
                        isStartJoinFlow: arguments.isStartJoinFlow,
                      ),
                    ),
                  ),
                );
                break;
              case '/Auth':
                return PageTransition(
                  settings: settings,
                  type: PageTransitionType.fade,
                  child: SignInScreen(),
                );
                break;
              default:
                return null;
            }
          },
          routes: {
            '/Intro': (context) => IntroScreen(),
          },
          navigatorObservers: [
            SegmentObserver(),
            this._routeObserver,
          ],
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
        print("Received token from Ably: $args");
        this.setState(() {
          this.didReceivePushToken = true;
          if (args.length > 0) {
            this.pushToken = args;
          }
        });
        break;
      case "didReceiveDeviceID":
        print("Received deviceid from Ably: $args");
        this.setState(() {
          this.deviceID = args;
        });
        break;
      case "didReceiveTokenAndDeviceID":
        print("Received token and deviceid from Ably: $args");
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

import 'dart:io';
import 'dart:async';

import 'package:delphis_app/bloc/app/app_bloc.dart';
import 'package:delphis_app/bloc/discussion_list/discussion_list_bloc.dart';
import 'package:delphis_app/bloc/discussion_viewer/discussion_viewer_bloc.dart';
import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/bloc/mention/mention_bloc.dart';
import 'package:delphis_app/bloc/superpowers/superpowers_bloc.dart';
import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/data/repository/viewer.dart';
import 'package:delphis_app/notifiers/home_page_tab.dart';
import 'package:delphis_app/screens/access_request_list/access_request_list.dart';
import 'package:delphis_app/screens/auth/base/sign_in.dart';
import 'package:delphis_app/screens/discussion/discussion_history_arguments.dart';
import 'package:delphis_app/screens/discussion/discussion_info.dart';
import 'package:delphis_app/screens/discussion/history_view.dart';
import 'package:delphis_app/screens/discussion/naming_discussion.dart';
import 'package:delphis_app/screens/discussion/options/discussion_options.dart';
import 'package:delphis_app/screens/participant_list/participant_list.dart';
import 'package:delphis_app/screens/pending_requests_list/pending_requests_list_page.dart';
import 'package:delphis_app/screens/superpowers/superpowers_arguments.dart';
import 'package:delphis_app/screens/superpowers/superpowers_screen.dart';
import 'package:delphis_app/screens/superpowers_popup/superpowers_popup.dart';
import 'package:delphis_app/screens/upsert_discussion/screen_arguments.dart';
import 'package:delphis_app/screens/upsert_discussion/upsert_discussion_screen.dart';
import 'package:delphis_app/util/link.dart';
import 'package:delphis_app/util/route_observer.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/discussion/discussion_bloc.dart';
import 'bloc/link/link_bloc.dart';
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
import 'screens/discussion/screen_args/discussion_naming.dart';
import 'screens/home_page/home_page.dart';
import 'screens/intro/intro_screen.dart';

const kDEVICE_ID_STORAGE_KEY = 'chatham_device_id';
const kPUSH_TOKEN_KEY = 'chatham_push_token_key';

class ChathamApp extends StatefulWidget {
  final Environment env;

  const ChathamApp({
    key,
    @required this.env,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChathamAppState();
}

final navKey = GlobalKey<NavigatorState>();

class ChathamAppState extends State<ChathamApp>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  static const methodChannel = const MethodChannel('chatham.ai/push_token');

  FlutterSecureStorage secureStorage;
  String deviceID;
  String pushToken;
  bool didReceivePushToken;
  bool hasSentDeviceToServer;
  bool requiresReload;

  RouteObserver _routeObserver;
  Key _homePageKey;
  AppLifecycleState appLifecycleState;

  StreamSubscription _deepLinkSubscription;

  @override
  void dispose() {
    if (_deepLinkSubscription != null) {
      _deepLinkSubscription.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    ChathamAppState.methodChannel
        .setMethodCallHandler(this._didReceiveTokenAndDeviceID);

    this.secureStorage = FlutterSecureStorage();
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
    getLinksStream().listen((String link) {
      if (link != null) {
        if (link.startsWith(Constants.twitterRedirectLegacyURLPrefix)) {
          // If the link is to a specific discussion let's rewrite it!
          try {
            final linkURI = Uri.parse(link);
            if (linkURI.path != null && linkURI.path.startsWith('/d/')) {
              BlocProvider.of<LinkBloc>(context).add(LinkChangeEvent(
                  newLink: 'https://m.chatham.ai${linkURI.path}'));
            }
          } catch (err) {
            return;
          }
        } else {
          BlocProvider.of<LinkBloc>(context)
              .add(LinkChangeEvent(newLink: link));
        }
      }
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest link
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    try {
      BlocProvider.of<LinkBloc>(context)
          .add(LinkChangeEvent(newLink: initialLink));
    } catch (err) {
      // fail silently
      print('err: $err');
    }

    final deviceID = await this.secureStorage.read(key: kDEVICE_ID_STORAGE_KEY);
    final pushToken = await this.secureStorage.read(key: kPUSH_TOKEN_KEY);
    if ((deviceID != null && deviceID.length > 0) ||
        (pushToken != null && pushToken.length > 0)) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        this.setState(() {
          if (pushToken != null && pushToken.length > 0) {
            this.pushToken = pushToken;
            this.didReceivePushToken = true;
          }
          if (deviceID != null && deviceID.length > 0) {
            this.deviceID = deviceID;
          }
        });
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      this.appLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is AppInitial ||
            (state is AppLoadedState &&
                state.lifecycleState != this.appLifecycleState)) {
          BlocProvider.of<AppBloc>(context).add(AppLifecycleChanged(
              lifecycle: this.appLifecycleState, when: DateTime.now()));
        }
        return MultiBlocProvider(
          providers: <BlocProvider>[
            BlocProvider<AuthBloc>(
              create: (context) =>
                  AuthBloc(DelphisAuthRepository(this.secureStorage))
                    ..add(LocalSignInAuthEvent()),
            ),
            BlocProvider<MeBloc>(
                create: (context) => MeBloc(
                    RepositoryProvider.of<UserRepository>(context),
                    BlocProvider.of<AuthBloc>(context),
                    BlocProvider.of<GqlClientBloc>(context))),
            BlocProvider<DiscussionListBloc>(
                create: (context) => DiscussionListBloc(
                    repository:
                        RepositoryProvider.of<DiscussionRepository>(context),
                    meBloc: BlocProvider.of<MeBloc>(context))),
            BlocProvider<MentionBloc>(create: (context) => MentionBloc()),
            BlocProvider<DiscussionBloc>(
                create: (context) => DiscussionBloc(
                    discussionRepository:
                        RepositoryProvider.of<DiscussionRepository>(context),
                    mediaRepository:
                        RepositoryProvider.of<MediaRepository>(context))),
            BlocProvider<NotificationBloc>(
                create: (context) => NotificationBloc(navKey: navKey)),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<AuthBloc, AuthState>(
                  listener: (context, AuthState state) {
                if (state is SignedInAuthState) {
                  BlocProvider.of<GqlClientBloc>(context).add(
                      GqlClientAuthChanged(
                          isAuthed: true, authString: state.authString));
                } else if (state is LoggedOutAuthState) {
                  BlocProvider.of<GqlClientBloc>(context).add(
                      GqlClientAuthChanged(isAuthed: false, authString: ""));
                }
              }),
              BlocListener<GqlClientBloc, GqlClientState>(
                  listener: (context, state) {
                final authState = BlocProvider.of<AuthBloc>(context).state;
                if (authState is SignedInAuthState &&
                    state is GqlClientConnectedState) {
                  BlocProvider.of<MeBloc>(context).add(FetchMeEvent());
                  if (BlocProvider.of<LinkBloc>(context).state
                      is ExternalLinkState) {
                    // We want to honor the external link we started with.
                    handleExternalLink(
                        context, BlocProvider.of<LinkBloc>(context).state);
                  }
                } else if (authState is LoggedOutAuthState) {
                  this.sendDeviceToServer(
                      RepositoryProvider.of<UserDeviceRepository>(context),
                      null);
                }
              }),
              /* Clears the current discussion list when user logs out. This is
                 wanted as we don't want discussion from an account to be
                 visible is user changes account. */
              BlocListener<AuthBloc, AuthState>(
                  listener: (context, AuthState state) {
                if (state is LoggedOutAuthState) {
                  setState(() {
                    this.hasSentDeviceToServer = false;
                  });
                  BlocProvider.of<DiscussionListBloc>(context)
                      .add(DiscussionListClearEvent());
                  BlocProvider.of<DiscussionBloc>(context)
                      .add(DiscussionClearEvent());
                }
              }),
              /* Forces refresh of discussions list when user logs out and then
                 logs in with another accout. */
              BlocListener<GqlClientBloc, GqlClientState>(
                  listenWhen: (prev, curr) {
                return prev is GqlClientConnectingState &&
                    curr is GqlClientConnectedState;
              }, listener: (context, state) {
                BlocProvider.of<DiscussionListBloc>(context)
                    .add(DiscussionListFetchEvent());
              }),
              BlocListener<MeBloc, MeState>(listener: (context, MeState state) {
                if (state is LoadedMeState) {
                  this.sendDeviceToServer(
                      RepositoryProvider.of<UserDeviceRepository>(context),
                      state.me);
                }
              }),
              BlocListener<DiscussionListBloc, DiscussionListState>(
                  listener: (context, state) {
                if (state is DiscussionListLoaded) {
                  BlocProvider.of<MentionBloc>(context).add(AddMentionDataEvent(
                      discussions: state.activeDiscussions));
                }
              }),
              BlocListener<LinkBloc, LinkState>(listener: (context, state) {
                if (state is ExternalLinkState) {
                  if (BlocProvider.of<GqlClientBloc>(context).state
                          is GqlClientConnectedState &&
                      (BlocProvider.of<GqlClientBloc>(context).state
                              as GqlClientConnectedState)
                          .isAuthed) {
                    // Let's parse the link
                    handleExternalLink(context, state);
                  }
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
                          BlocProvider<ParticipantBloc>(
                            lazy: true,
                            create: (context) => ParticipantBloc(
                                repository: ParticipantRepository(
                                    clientBloc: BlocProvider.of<GqlClientBloc>(
                                        context)),
                                discussionBloc:
                                    BlocProvider.of<DiscussionBloc>(context)),
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
                          child: ChangeNotifierProvider<HomePageTabNotifier>(
                            create: (context) =>
                                HomePageTabNotifier(HomePageTab.ACTIVE),
                            child: HomePageScreen(
                              key: this._homePageKey,
                              discussionRepository:
                                  RepositoryProvider.of<DiscussionRepository>(
                                      context),
                              routeObserver: this._routeObserver,
                            ),
                          ),
                        ),
                      ),
                    );
                    break;
                  case '/Home/PendingRequestsList':
                    return MaterialPageRoute(
                      settings: settings,
                      builder: (BuildContext context) {
                        return PendingRequestsListScreen();
                      },
                    );
                    break;
                  case '/Discussion':
                    DiscussionArguments arguments =
                        settings.arguments as DiscussionArguments;
                    return MaterialPageRoute(
                        settings: settings,
                        builder: (BuildContext context) {
                          if (BlocProvider.of<DiscussionBloc>(context).state
                              is DiscussionUninitializedState) {
                            /* This happend when the app is opened by restoring
                               a discussion screen */
                            BlocProvider.of<DiscussionBloc>(context)
                                .add(DiscussionQueryEvent(
                              discussionID: arguments.discussionID,
                              nonce: DateTime.now(),
                            ));
                          }
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider<ParticipantBloc>(
                                lazy: true,
                                create: (context) => ParticipantBloc(
                                    repository: RepositoryProvider.of<
                                        ParticipantRepository>(context),
                                    discussionBloc:
                                        BlocProvider.of<DiscussionBloc>(
                                            context)),
                              ),
                              BlocProvider<DiscussionViewerBloc>(
                                lazy: true,
                                create: (context) => DiscussionViewerBloc(
                                  viewerRepository:
                                      RepositoryProvider.of<ViewerRepository>(
                                          context),
                                ),
                              ),
                              BlocProvider<SuperpowersBloc>(
                                create: (context) => SuperpowersBloc(
                                  discussionRepository: RepositoryProvider.of<
                                      DiscussionRepository>(context),
                                  participantRepository: RepositoryProvider.of<
                                      ParticipantRepository>(context),
                                  notificationBloc:
                                      BlocProvider.of<NotificationBloc>(
                                          context),
                                  discussionBloc:
                                      BlocProvider.of<DiscussionBloc>(context),
                                ),
                              ),
                            ],
                            child: MultiBlocListener(
                              listeners: [
                                BlocListener<AuthBloc, AuthState>(
                                    listener: (context, state) {
                                  if (state is LoggedOutAuthState) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/Auth',
                                      (Route<dynamic> route) => false,
                                    );
                                  }
                                }),
                                BlocListener<DiscussionBloc, DiscussionState>(
                                    listener: (context, state) {
                                  if (state is DiscussionLoadedState) {
                                    BlocProvider.of<MentionBloc>(context).add(
                                        AddMentionDataEvent(
                                            discussion: state.getDiscussion()));
                                    if (state.getDiscussion()?.meViewer !=
                                        null) {
                                      BlocProvider.of<DiscussionViewerBloc>(
                                              context)
                                          .add(
                                        DiscussionViewerLoadedEvent(
                                          viewer:
                                              state.getDiscussion().meViewer,
                                        ),
                                      );
                                    }
                                  }
                                }),
                                BlocListener<AppBloc, AppState>(
                                    listener: (context, state) {
                                  if (state is AppLoadedState &&
                                      state.lifecycleState ==
                                          AppLifecycleState.resumed) {
                                    // Reload the discussion which should cause it to subscribe to the websocket.
                                    BlocProvider.of<DiscussionBloc>(context)
                                        .add(DiscussionQueryEvent(
                                            discussionID:
                                                arguments.discussionID));
                                  }
                                }),
                                /* This triggers an initial refresh when the user first
                                   joins the discussion. It causes posts to reload,
                                   the input to show, and the subscription to initialize. */
                                BlocListener<DiscussionBloc, DiscussionState>(
                                  listenWhen: (prev, curr) {
                                    return prev is DiscussionLoadedState &&
                                        curr is DiscussionLoadedState &&
                                        prev.getDiscussion()?.meParticipant ==
                                            null &&
                                        curr.getDiscussion()?.meParticipant !=
                                            null;
                                  },
                                  listener: (context, state) {
                                    BlocProvider.of<DiscussionBloc>(context)
                                        .add(
                                      RefreshPostsEvent(
                                        discussionID: arguments.discussionID,
                                      ),
                                    );
                                  },
                                ),
                              ],
                              child: DelphisDiscussion(
                                key: Key(
                                    'discussion-screen-${arguments.discussionID}'),
                                discussionID: arguments.discussionID,
                                isStartJoinFlow: arguments.isStartJoinFlow,
                                routeObserver: this._routeObserver,
                              ),
                            ),
                          );
                        });
                    break;
                  case '/Discussion/Naming':
                    DiscussionNamingArguments arguments =
                        settings.arguments as DiscussionNamingArguments;
                    return PageTransition(
                        settings: settings,
                        type: PageTransitionType.rightToLeft,
                        child: DiscussionNamingScreen(
                            title: arguments.title,
                            selectedEmoji: arguments.selectedEmoji,
                            onSavePressed: (context, selectedEmoji, title) {
                              BlocProvider.of<DiscussionBloc>(context).add(
                                DiscussionUpdateEvent(
                                    discussionID: arguments.discussionID,
                                    title: title,
                                    description: '',
                                    selectedEmoji: selectedEmoji),
                              );
                              Navigator.pop(context);
                            },
                            onClosePressed: (context) {
                              Navigator.pop(context);
                            }));
                    break;
                  case '/Discussion/Upsert':
                    UpsertDiscussionArguments arguments =
                        settings.arguments as UpsertDiscussionArguments;
                    return MaterialPageRoute(
                      settings: settings,
                      builder: (BuildContext context) {
                        return BlocProvider<UpsertDiscussionBloc>(
                          create: (context) => UpsertDiscussionBloc(
                              RepositoryProvider.of<DiscussionRepository>(
                                  context))
                            ..add(UpsertDiscussionMeUserChangeEvent(
                                MeBloc.extractMe(
                                    BlocProvider.of<MeBloc>(context).state)))
                            ..add(UpsertDiscussionSelectDiscussionEvent(
                                arguments.discussion)),
                          child: BlocListener<DiscussionBloc, DiscussionState>(
                            listener: (context, state) {
                              if (state.getDiscussion()?.id ==
                                  arguments.discussion?.id) {
                                BlocProvider.of<UpsertDiscussionBloc>(context)
                                    .add(UpsertDiscussionSelectDiscussionEvent(
                                        state.getDiscussion()));
                              }
                            },
                            child: BlocListener<MeBloc, MeState>(
                              listener: (context, state) {
                                BlocProvider.of<UpsertDiscussionBloc>(context)
                                    .add(UpsertDiscussionMeUserChangeEvent(
                                        MeBloc.extractMe(state)));
                              },
                              child:
                                  UpsertDiscussionScreen(arguments: arguments),
                            ),
                          ),
                        );
                      },
                    );
                    break;
                  case '/Discussion/AccessRequestList':
                    return MaterialPageRoute(
                      settings: settings,
                      builder: (BuildContext context) {
                        return AccessRequestListScreen();
                      },
                    );
                    break;
                  case '/Discussion/Superpowers':
                    SuperpowersArguments arguments =
                        settings.arguments as SuperpowersArguments;
                    return MaterialPageRoute(
                      settings: settings,
                      builder: (context) {
                        return BlocProvider<SuperpowersBloc>(
                          create: (context) => SuperpowersBloc(
                            discussionRepository:
                                RepositoryProvider.of<DiscussionRepository>(
                                    context),
                            participantRepository:
                                RepositoryProvider.of<ParticipantRepository>(
                                    context),
                            notificationBloc:
                                BlocProvider.of<NotificationBloc>(context),
                            discussionBloc:
                                BlocProvider.of<DiscussionBloc>(context),
                          ),
                          child: BlocBuilder<DiscussionBloc, DiscussionState>(
                            builder: (context, state) {
                              var discussion = state.getDiscussion();
                              if (discussion != null) {
                                arguments =
                                    arguments.copyWith(discussion: discussion);
                              }
                              return SuperpowersScreen(
                                key: GlobalKey(),
                                arguments: arguments,
                              );
                            },
                          ),
                        );
                      },
                    );
                    break;
                  case '/Discussion/SuperpowersPopup':
                    SuperpowersArguments arguments =
                        settings.arguments as SuperpowersArguments;
                    return PageRouteBuilder(
                      opaque: false,
                      maintainState: true,
                      transitionDuration: Duration(milliseconds: 200),
                      transitionsBuilder: (
                        context,
                        Animation<double> animation,
                        ____,
                        Widget child,
                      ) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0.0, 1.0),
                            end: Offset(0.0, 0.0),
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                              reverseCurve: Curves.easeInOut,
                            ),
                          ),
                          child: child,
                        );
                      },
                      pageBuilder: (context, _, __) {
                        return BlocProvider<SuperpowersBloc>(
                          create: (context) => SuperpowersBloc(
                            discussionRepository:
                                RepositoryProvider.of<DiscussionRepository>(
                                    context),
                            participantRepository:
                                RepositoryProvider.of<ParticipantRepository>(
                                    context),
                            notificationBloc:
                                BlocProvider.of<NotificationBloc>(context),
                            discussionBloc:
                                BlocProvider.of<DiscussionBloc>(context),
                          ),
                          child: SuperpowersPopupScreen(
                            arguments: arguments,
                          ),
                        );
                      },
                    );
                    break;
                  case '/Discussion/Options':
                    return MaterialPageRoute(
                        settings: settings,
                        builder: (BuildContext context) {
                          return DiscussionOptionsScreen();
                        });
                    break;
                  case '/Discussion/Info':
                    return PageRouteBuilder(
                      opaque: false,
                      maintainState: true,
                      barrierColor: Colors.black.withOpacity(0.6),
                      barrierDismissible: true,
                      transitionDuration: Duration(milliseconds: 200),
                      transitionsBuilder: (
                        context,
                        Animation<double> animation,
                        ____,
                        Widget child,
                      ) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1.0, 0.0),
                            end: Offset(0.0, 0.0),
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                              reverseCurve: Curves.easeInOut,
                            ),
                          ),
                          child: child,
                        );
                      },
                      pageBuilder: (context, _, __) {
                        return DiscussionInfo();
                      },
                    );
                    break;
                  case '/Discussion/HistoryView':
                    DiscussionHistoryViewArguments arguments =
                        settings.arguments as DiscussionHistoryViewArguments;
                    return PageRouteBuilder(
                      opaque: false,
                      maintainState: true,
                      barrierColor: Colors.black.withOpacity(0.6),
                      barrierDismissible: true,
                      transitionDuration: Duration(milliseconds: 200),
                      transitionsBuilder: (
                        context,
                        Animation<double> animation,
                        ____,
                        Widget child,
                      ) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1.0, 0.0),
                            end: Offset(0.0, 0.0),
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                              reverseCurve: Curves.easeInOut,
                            ),
                          ),
                          child: child,
                        );
                      },
                      pageBuilder: (context, _, __) {
                        return DiscussionHistoryView(
                          historyType: arguments.viewType,
                        );
                      },
                    );
                    break;
                  case '/Discussion/ParticipantList':
                    return PageRouteBuilder(
                      opaque: false,
                      maintainState: true,
                      barrierColor: Colors.black.withOpacity(0.6),
                      barrierDismissible: true,
                      transitionDuration: Duration(milliseconds: 200),
                      transitionsBuilder: (
                        context,
                        Animation<double> animation,
                        ____,
                        Widget child,
                      ) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1.0, 0.0),
                            end: Offset(0.0, 0.0),
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                              reverseCurve: Curves.easeInOut,
                            ),
                          ),
                          child: child,
                        );
                      },
                      pageBuilder: (context, _, __) {
                        return ParticipantListScreen();
                      },
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
      },
    );
  }

  void sendDeviceToServer(UserDeviceRepository repository, User me) {
    if (me != null &&
        !this.hasSentDeviceToServer &&
        (this.didReceivePushToken ?? false) &&
        this.deviceID != null &&
        this.deviceID.length > 0) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!this.hasSentDeviceToServer) {
          var platform = ChathamPlatform.UNKNOWN;
          if (Platform.isIOS) {
            platform = ChathamPlatform.IOS;
          } else if (Platform.isAndroid) {
            platform = ChathamPlatform.ANDROID;
          }
          repository
              .upsertUserDevice(me?.id, this.pushToken, platform, this.deviceID)
              .then((value) {
            setState(() {
              this.hasSentDeviceToServer = true;
            });
          });
        }
      });
    } else if (me != null && !this.hasSentDeviceToServer) {
      // This is pretty gross but will work..
      Future.delayed(const Duration(seconds: 5), () {
        this.sendDeviceToServer(repository, me);
      });
    }
  }

  void handleExternalLink(BuildContext context, ExternalLinkState state) {
    // We clear the state regardless of what happens
    BlocProvider.of<LinkBloc>(context).add(ClearLinkEvent());
    Uri linkURI;
    try {
      linkURI = Uri.parse(state.link);
    } catch (err) {
      // This is an invalid URI.
    }
    if (linkURI != null) {
      final linkArgs =
          ChathamLinkParser.getChathamDiscussionLinkParams(linkURI);
      if (linkArgs == null) {
        return;
      }
      try {
        RepositoryProvider.of<DiscussionRepository>(context)
            .getDiscussionFromSlug(linkArgs.discussionSlug)
            .then((disc) {
          if (disc == null) {
            // Nothing to do here so just return.
            return;
          }
          BlocProvider.of<DiscussionBloc>(context).add(DiscussionQueryEvent(
              discussionID: disc.id, nonce: DateTime.now()));
          navKey.currentState.pushNamedAndRemoveUntil(
            '/Discussion',
            ModalRoute.withName('/Home'),
            arguments: DiscussionArguments(
              discussionID: disc.id,
              isStartJoinFlow: false,
            ),
          );
        });
      } catch (err) {}
    }
  }

  Future<void> _didReceiveTokenAndDeviceID(MethodCall call) async {
    final String args = call.arguments;
    switch (call.method) {
      case "didReceiveToken":
        setState(() {
          this.didReceivePushToken = true;
          if (args.length > 0) {
            this.pushToken = args;
          }
        });
        if (args.length > 0) {
          secureStorage.write(key: kPUSH_TOKEN_KEY, value: args);
        }
        break;
      case "didReceiveDeviceID":
        setState(() {
          this.deviceID = args;
        });
        if (args.length > 0) {
          secureStorage.write(key: kDEVICE_ID_STORAGE_KEY, value: args);
        }
        break;
      case "didReceiveTokenAndDeviceID":
        final parts = args.split('.');
        if (parts.length == 1) {
          // Only device ID
          setState(() {
            this.deviceID = parts[0].trim();
            this.didReceivePushToken = true;
          });
          if (parts[0].trim().length > 0) {
            secureStorage.write(
                key: kDEVICE_ID_STORAGE_KEY, value: parts[0].trim());
          }
        } else if (parts.length == 2) {
          setState(() {
            this.deviceID = parts[0].trim();
            this.pushToken = parts[1].trim();
            this.didReceivePushToken = true;
          });
          if (parts[0].trim().length > 0) {
            secureStorage.write(
                key: kDEVICE_ID_STORAGE_KEY, value: parts[0].trim());
          }
          if (parts[1].trim().length > 0) {
            secureStorage.write(key: kPUSH_TOKEN_KEY, value: parts[1].trim());
          }
        }
        break;
    }
  }
}

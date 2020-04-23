import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/screens/auth/base/sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/discussion/discussion_bloc.dart';
import 'bloc/me/me_bloc.dart';
import 'data/repository/auth.dart';
import 'package:delphis_app/screens/auth/index.dart';
import 'package:delphis_app/screens/discussion/discussion.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'design/text_theme.dart';
import 'screens/intro/intro_screen.dart';

class ChathamApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChathamAppState();
}

class ChathamAppState extends State<ChathamApp> {
  FlutterSecureStorage secureStorage;
  AuthBloc authBloc;
  GraphQLClient gqlClient;

  @override
  void dispose() {
    this.authBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    this.secureStorage = FlutterSecureStorage();
    this.authBloc = AuthBloc(DelphisAuthRepository(this.secureStorage))
      ..add(FetchAuthEvent());
  }

  @override
  Widget build(BuildContext context) {
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
    final Link link = authLink.concat(httpLink);

    final gqlClient = GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    );

    final discussionRepository = DiscussionRepository(gqlClient);
    final userRepository = UserRepository(gqlClient);
    ;

    ValueNotifier<GraphQLClient> client = ValueNotifier(gqlClient);
    return GraphQLProvider(
        client: client,
        child: MultiBlocProvider(
          providers: <BlocProvider>[
            BlocProvider<AuthBloc>.value(value: this.authBloc),
            BlocProvider<MeBloc>(create: (context) => MeBloc(userRepository)),
          ],
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is InitializedAuthState && state.isAuthed) {
                BlocProvider.of<MeBloc>(context).add(FetchMeEvent());
              }
            },
            child: MaterialApp(
              title: "Chatham",
              theme: kThemeData,
              initialRoute: '/Intro',
              routes: {
                '/Intro': (context) => IntroScreen(),
                '/': (context) => BlocProvider<DiscussionBloc>(
                      lazy: true,
                      create: (context) =>
                          DiscussionBloc(repository: discussionRepository)
                            ..add(DiscussionQueryEvent(
                                '2589fb41-e6c5-4950-8b75-55bb3315113e')),
                      child: DelphisDiscussion(),
                    ),
                '/Auth': (context) => SignInScreen(
                    onTwitterPressed: () =>
                        {Navigator.of(context).pushNamed('/Auth/Twitter')}),
                '/Auth/Twitter': (context) => LoginScreen(),
              },
            ),
          ),
        ));
  }
}

import 'package:delphis_app/data/repository/discussion.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/discussion/discussion_bloc.dart';
import 'data/repository/auth.dart';
import 'package:delphis_app/screens/auth/index.dart';
import 'package:delphis_app/screens/discussion/discussion.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

class ChathamApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChathamAppState();
}

class ChathamAppState extends State<ChathamApp> {
  FlutterSecureStorage secureStorage;
  AuthBloc authBloc;

  @override
  void initState() {
    super.initState();

    this.secureStorage = FlutterSecureStorage();
    this.authBloc = AuthBloc(DelphisAuthRepository(this.secureStorage))..add(FetchAuthEvent());
  }

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      uri: Constants.gqlEndpoint,
    );

    final AuthLink authLink = AuthLink(
      getToken: () async {
        if (this.authBloc.state is InitializedAuthState && (this.authBloc.state as InitializedAuthState).isAuthed) {
          return 'Bearer ${(this.authBloc.state as InitializedAuthState).authString}';
        }
        return 'Bearer ';
      }
    );
    final Link link = authLink.concat(httpLink);

    final gqlClient = GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    );

    final discussionRepository = DiscussionRepository(gqlClient);


    ValueNotifier<GraphQLClient> client = ValueNotifier(gqlClient);
    return GraphQLProvider(
      client: client,
      child: BlocProvider.value(
        value: this.authBloc,
        child: MaterialApp(
          title: "Chatham",
          theme: ThemeData(
            fontFamily: 'NeueHansKendrick',
            textTheme: TextTheme(
              bodyText2: TextStyle(
                color: Colors.grey,
                height: 1.0,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                textBaseline: TextBaseline.alphabetic,
                decoration: TextDecoration.none,
              ),
            )),
          initialRoute: '/Auth/Twitter',
          routes: {
            '/': (context) => BlocProvider<DiscussionBloc>(
              create: (context) => DiscussionBloc(repository: discussionRepository)..add(DiscussionQueryEvent('492ace75-8eac-4345-9aa4-403661e85b31')),
              child: DelphisDiscussion(),
            ),
            '/Auth/Twitter': (context) => LoginScreen(),
          },
        ),
      ),
    );
  }
}
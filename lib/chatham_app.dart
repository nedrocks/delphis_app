import 'package:delphis_app/models/auth.dart';
import 'package:delphis_app/screens/auth/index.dart';
import 'package:delphis_app/screens/discussion/discussion.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class ChathamApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChathamAppState();
}

class ChathamAppState extends State<ChathamApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var delphisAuth = Provider.of<DelphisAuth>(context);

    final HttpLink httpLink = HttpLink(
      uri: 'https://staging.delphishq.com/query',
    );

    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer ${delphisAuth.authString}',
    );
    final Link link = authLink.concat(httpLink);

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: link,
      ),
    );
    return GraphQLProvider(
      client: client,
      child: ChangeNotifierProvider<DelphisAuth>.value(
        value: delphisAuth,
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
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => DelphisDiscussion(discussionID: '492ace75-8eac-4345-9aa4-403661e85b31'),
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/Auth/Twitter': (context) => LoginScreen(),
          },
        ),
      ),
    );
  }
}
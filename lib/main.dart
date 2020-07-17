import 'package:delphis_app/bloc/app/app_bloc.dart';
import 'package:delphis_app/bloc/observer.dart';
import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/constants.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/user_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chatham_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // navigation bar color
      statusBarColor: Colors.black, // status bar color
      statusBarBrightness: Brightness.dark,
    ),
  );
  Constants.setEnvironment(Environment.STAGING);
  Bloc.observer = ChathamBlocObserver();

  var appKey = GlobalKey();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(create: (context) => AppBloc()),
        BlocProvider<GqlClientBloc>(create: (context) => GqlClientBloc()),
      ],
      child: MultiRepositoryProvider(providers: [
        RepositoryProvider<DiscussionRepository>(
            lazy: true,
            create: (context) => DiscussionRepository(
                clientBloc: BlocProvider.of<GqlClientBloc>(context))),
        RepositoryProvider<UserDeviceRepository>(
            create: (context) => UserDeviceRepository(
                clientBloc: BlocProvider.of<GqlClientBloc>(context))),
        RepositoryProvider<MediaRepository>(
            create: (context) => MediaRepository()),
        RepositoryProvider<ParticipantRepository>(
            create: (context) => ParticipantRepository(
                clientBloc: BlocProvider.of<GqlClientBloc>(context))),
      ], child: ChathamApp(key: appKey, env: Environment.STAGING))));
}

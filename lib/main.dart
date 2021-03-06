import 'package:delphis_app/bloc/app/app_bloc.dart';
import 'package:delphis_app/bloc/link/link_bloc.dart';
import 'package:delphis_app/bloc/observer.dart';
import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/constants.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/twitter_user.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/data/repository/user_device.dart';
import 'package:delphis_app/data/repository/viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  initializeDateFormatting("US");

  var appKey = GlobalKey();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(create: (context) => AppBloc()),
        BlocProvider<GqlClientBloc>(create: (context) => GqlClientBloc()),
        BlocProvider<LinkBloc>(create: (context) => LinkBloc()),
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
        RepositoryProvider<ViewerRepository>(
            create: (context) => ViewerRepository(
                clientBloc: BlocProvider.of<GqlClientBloc>(context))),
        RepositoryProvider<UserRepository>(
            create: (context) => UserRepository(
                clientBloc: BlocProvider.of<GqlClientBloc>(context))),
        RepositoryProvider<TwitterUserRepository>(
            create: (context) => TwitterUserRepository(
                clientBloc: BlocProvider.of<GqlClientBloc>(context)))
      ], child: ChathamApp(key: appKey, env: Environment.STAGING))));
}

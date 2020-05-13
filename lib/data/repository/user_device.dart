import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/data/provider/mutations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

import 'user.dart';

part 'user_device.g.dart';

const MAX_ATTEMPTS = 3;
const BACKOFF = 1;

enum ChathamPlatform { UNKNOWN, IOS, ANDROID, WEB }

class UserDeviceRepository {
  final GqlClientBloc clientBloc;

  const UserDeviceRepository({@required this.clientBloc});

  Future<UserDevice> upsertUserDevice(
      String userID, String token, ChathamPlatform platform, String deviceID,
      {int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return upsertUserDevice(userID, token, platform, deviceID,
            attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }

    final mutation = UpdateUserDeviceGQLMutation(
      userID: userID,
      token: token,
      platform: platform,
      deviceID: deviceID,
    );

    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'userID': userID,
          'token': token,
          'platform': platform.toString().split('.')[1],
          'deviceID': deviceID,
        },
        update: (Cache cache, QueryResult result) {
          return cache;
        },
      ),
    );

    if (result.hasException) {
      throw result.exception;
    }

    return mutation.parseResult(result.data);
  }
}

@JsonAnnotation.JsonSerializable()
class UserDevice extends Equatable {
  final User user;
  final ChathamPlatform platform;
  final DateTime lastSeen;

  const UserDevice({
    this.user,
    this.platform,
    this.lastSeen,
  }) : super();

  @override
  // TODO: implement props
  List<Object> get props => [user, platform, lastSeen];

  factory UserDevice.fromJson(Map<String, dynamic> json) =>
      _$UserDeviceFromJson(json);
}

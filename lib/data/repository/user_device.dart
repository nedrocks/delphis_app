import 'package:delphis_app/data/provider/mutations.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

import 'user.dart';

part 'user_device.g.dart';

enum ChathamPlatform { UNKNOWN, IOS, ANDROID, WEB }

class UserDeviceRepository {
  final GraphQLClient client;

  const UserDeviceRepository(
    this.client,
  );

  Future<UserDevice> upsertUserDevice(String userID, String token,
      ChathamPlatform platform, String deviceID) async {
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

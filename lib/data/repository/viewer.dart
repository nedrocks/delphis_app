import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/data/provider/mutations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

import 'discussion.dart';
import 'post.dart';

part 'viewer.g.dart';

class ViewerRepository {
  final GqlClientBloc clientBloc;

  const ViewerRepository({
    @required this.clientBloc,
  });

  Future<Viewer> setLastPostViewed(String viewerID, String postID,
      {int attempt = 1}) async {
    final client = this.clientBloc.getClient();
    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return setLastPostViewed(viewerID, postID, attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }

    final mutation = SetLastPostViewedMutation(
      viewerID: viewerID,
      postID: postID,
    );

    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'viewerID': viewerID,
          'postID': postID,
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
class Viewer extends Equatable {
  final String id;
  final Discussion discussion;
  final DateTime lastViewed;
  final Post lastViewedPost;

  List<Object> get props => [id, discussion, lastViewed, lastViewedPost];

  const Viewer({
    this.id,
    this.discussion,
    this.lastViewed,
    this.lastViewedPost,
  });

  factory Viewer.fromJson(Map<String, dynamic> json) => _$ViewerFromJson(json);
}

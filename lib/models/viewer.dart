import 'package:json_annotation/json_annotation.dart';

import 'discussion.dart';
import 'post.dart';

part 'viewer.g.dart';

@JsonSerializable()
class Viewer {
  final String id;
  final Discussion discussion;
  final DateTime lastViewed;
  final Post lastViewedPost;

  const Viewer({
    this.id,
    this.discussion,
    this.lastViewed,
    this.lastViewedPost,
  });

  factory Viewer.fromJson(Map<String, dynamic> json) => _$ViewerFromJson(json);
}
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flair.g.dart';

@JsonSerializable()
class Flair extends Equatable {
  final String id;
  final String displayName;
  final String imageURL;
  final String source;

  List<Object> get props => [
        id,
        displayName,
        imageURL,
        source,
      ];

  const Flair({
    this.id,
    this.displayName,
    this.imageURL,
    this.source,
  });

  factory Flair.fromJson(Map<String, dynamic> json) => _$FlairFromJson(json);
}

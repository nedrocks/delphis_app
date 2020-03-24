import 'package:json_annotation/json_annotation.dart';

part 'url.g.dart';

@JsonSerializable()
class URL {
  final String displayText;
  final String url;

  const URL({
    this.displayText,
    this.url,
  });

  factory URL.fromJson(Map<String, dynamic> json) => _$URLFromJson(json);
}
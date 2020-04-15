import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'url.g.dart';

@JsonSerializable()
class URL extends Equatable {
  final String displayText;
  final String url;

  List<Object> get props => [
    displayText, url
  ];

  const URL({
    this.displayText,
    this.url,
  });

  factory URL.fromJson(Map<String, dynamic> json) => _$URLFromJson(json);
}
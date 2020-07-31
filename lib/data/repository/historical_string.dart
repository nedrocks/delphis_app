import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'historical_string.g.dart';

@JsonSerializable()
class HistoricalString extends Equatable {
  final String value;
  final String createdAt;

  HistoricalString({
    this.value,
    this.createdAt,
  });

  factory HistoricalString.fromJson(Map<String, dynamic> json) =>
      _$HistoricalStringFromJson(json);

  Map<String, dynamic> toJSON() {
    return _$HistoricalStringToJson(this);
  }

  @override
  List<Object> get props => [value, createdAt];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historical_string.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoricalString _$HistoricalStringFromJson(Map<String, dynamic> json) {
  return HistoricalString(
    value: json['value'] as String,
    createdAt: json['createdAt'] as String,
  );
}

Map<String, dynamic> _$HistoricalStringToJson(HistoricalString instance) =>
    <String, dynamic>{
      'value': instance.value,
      'createdAt': instance.createdAt,
    };

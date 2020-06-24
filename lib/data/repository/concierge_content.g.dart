// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concierge_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConciergeOption _$ConciergeOptionFromJson(Map<String, dynamic> json) {
  return ConciergeOption(
    text: json['text'] as String,
    value: json['value'] as String,
    selected: json['selected'] as bool,
  );
}

Map<String, dynamic> _$ConciergeOptionToJson(ConciergeOption instance) =>
    <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
      'selected': instance.selected,
    };

ConciergeContent _$ConciergeContentFromJson(Map<String, dynamic> json) {
  return ConciergeContent(
    appActionID: json['appActionID'] as String,
    mutationID: json['mutationID'] as String,
    options: (json['options'] as List)
        ?.map((e) => e == null
            ? null
            : ConciergeOption.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ConciergeContentToJson(ConciergeContent instance) =>
    <String, dynamic>{
      'appActionID': instance.appActionID,
      'mutationID': instance.mutationID,
      'options': instance.options,
    };

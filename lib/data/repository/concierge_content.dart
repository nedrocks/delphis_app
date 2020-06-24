import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'concierge_content.g.dart';

@JsonSerializable()
class ConciergeOption extends Equatable {
  static const kAppActionCopyToClipboard =
      'db5fd0da-d645-4aa2-990c-b61d004a45e1';
  static const kAppActionRenameChat = 'd81118d6-427a-4267-96be-45cadd94b782';

  final String text;
  final String value;
  final bool selected;

  List<Object> get props => [
        this.text,
        this.value,
        this.selected,
      ];

  const ConciergeOption({
    this.text,
    this.value,
    this.selected,
  });

  factory ConciergeOption.fromJson(Map<String, dynamic> json) =>
      _$ConciergeOptionFromJson(json);
}

@JsonSerializable()
class ConciergeContent extends Equatable {
  final String appActionID;
  final String mutationID;
  final List<ConciergeOption> options;

  List<Object> get props => [
        appActionID,
        mutationID,
        options,
      ];

  const ConciergeContent({
    this.appActionID,
    this.mutationID,
    this.options,
  });

  factory ConciergeContent.fromJson(Map<String, dynamic> json) =>
      _$ConciergeContentFromJson(json);
}

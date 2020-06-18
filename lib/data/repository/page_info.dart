import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

part 'page_info.g.dart';

@JsonAnnotation.JsonSerializable()
class PageInfo extends Equatable {
  final String startCursor;
  final String endCursor;
  final bool hasNextPage;

  @override
  List<Object> get props => [startCursor, endCursor, hasNextPage];

  PageInfo({this.startCursor, this.endCursor, this.hasNextPage});

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);

  PageInfo copyWith({startCursor, endCursor, hasNextPage}) => PageInfo(
        startCursor: startCursor ?? this.startCursor,
        endCursor: endCursor ?? this.endCursor,
        hasNextPage: hasNextPage ?? this.hasNextPage,
      );
}

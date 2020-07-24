import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'twitter_user.g.dart';

@JsonSerializable()
class TwitterUserInfo extends Equatable {
  final String id;
  final String name;
  final String displayName;
  final String profileImageURL;
  final bool verified;
  final bool invited;

  TwitterUserInfo({
    this.id,
    this.name,
    this.displayName,
    this.profileImageURL,
    this.verified,
    this.invited
  });

  List<Object> get props => [
        id, name, displayName, profileImageURL, verified, invited
  ];

  factory TwitterUserInfo.fromJson(Map<String, dynamic> json) => _$TwitterUserInfoFromJson(json);

  Map<String, dynamic> toJSON() {
    return _$TwitterUserInfoToJson(this);
  }

}

@JsonSerializable()
class TwitterUserInput extends Equatable {
  final String name;

  TwitterUserInput({
    this.name,
  });

  List<Object> get props => [name];

  factory TwitterUserInput.fromJson(Map<String, dynamic> json) => _$TwitterUserInputFromJson(json);

  Map<String, dynamic> toJSON() {
    return _$TwitterUserInputToJson(this);
  }
  
}
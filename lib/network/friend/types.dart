import 'package:freezed_annotation/freezed_annotation.dart';

part 'types.g.dart';

@JsonSerializable()
class FriendAgreeData {
  FriendAgreeData({required this.id});

  final int id;

  factory FriendAgreeData.fromJson(Map<String, dynamic> json) =>
      _$FriendAgreeDataFromJson(json);

  Map<String, dynamic> toJson() => _$FriendAgreeDataToJson(this);
}

@JsonSerializable()
class AgreeResponse {
  AgreeResponse();

  factory AgreeResponse.fromJson(Map<String, dynamic> json) =>
      _$AgreeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AgreeResponseToJson(this);
}

@JsonSerializable()
class FriendApiRequestData {
  FriendApiRequestData();

  factory FriendApiRequestData.fromJson(Map<String, dynamic> json) =>
      _$FriendApiRequestDataFromJson(json);

  Map<String, dynamic> toJson() => _$FriendApiRequestDataToJson(this);
}

@JsonSerializable()
class RequestResponse {
  RequestResponse({
    required this.id,
  });

  final List<int> id;

  factory RequestResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestResponseToJson(this);
}

@JsonSerializable()
class FriendDisagreeData {
  FriendDisagreeData({required this.id});

  final int id;

  factory FriendDisagreeData.fromJson(Map<String, dynamic> json) =>
      _$FriendDisagreeDataFromJson(json);

  Map<String, dynamic> toJson() => _$FriendDisagreeDataToJson(this);
}

@JsonSerializable()
class DisagreeResponse {
  DisagreeResponse();

  factory DisagreeResponse.fromJson(Map<String, dynamic> json) =>
      _$DisagreeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DisagreeResponseToJson(this);
}

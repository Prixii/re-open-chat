import 'package:freezed_annotation/freezed_annotation.dart';

part 'types.g.dart';

@JsonSerializable()
class CreateData {
  CreateData({
    required this.users,
    required this.name,
    this.profile = '',
  });

  final String name;
  final List<int> users;
  final String profile;

  factory CreateData.fromJson(Map<String, dynamic> json) =>
      _$CreateDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreateDataToJson(this);
}

@JsonSerializable()
class CreateResponse {
  CreateResponse({
    required this.id,
  });

  final int id;

  factory CreateResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateResponseToJson(this);
}

@JsonSerializable()
class SetAdminData {
  SetAdminData({
    required this.groupID,
    required this.userID,
  });

  final int groupID;
  final int userID;

  factory SetAdminData.fromJson(Map<String, dynamic> json) =>
      _$SetAdminDataFromJson(json);

  Map<String, dynamic> toJson() => _$SetAdminDataToJson(this);
}

@JsonSerializable()
class SetAdminResponse {
  SetAdminResponse();

  factory SetAdminResponse.fromJson(Map<String, dynamic> json) =>
      _$SetAdminResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SetAdminResponseToJson(this);
}

@JsonSerializable()
class RemoveAdminData {
  RemoveAdminData({
    required this.groupID,
    required this.userID,
  });

  final int groupID;
  final int userID;

  factory RemoveAdminData.fromJson(Map<String, dynamic> json) =>
      _$RemoveAdminDataFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveAdminDataToJson(this);
}

@JsonSerializable()
class RemoveAdminResponse {
  RemoveAdminResponse();

  factory RemoveAdminResponse.fromJson(Map<String, dynamic> json) =>
      _$RemoveAdminResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveAdminResponseToJson(this);
}

@JsonSerializable()
class GroupAgreeData {
  GroupAgreeData({
    required this.groupID,
    required this.userID,
  });

  final int groupID;
  final int userID;

  factory GroupAgreeData.fromJson(Map<String, dynamic> json) =>
      _$GroupAgreeDataFromJson(json);

  Map<String, dynamic> toJson() => _$GroupAgreeDataToJson(this);
}

@JsonSerializable()
class AgreeResponse {
  AgreeResponse();

  factory AgreeResponse.fromJson(Map<String, dynamic> json) =>
      _$AgreeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AgreeResponseToJson(this);
}

@JsonSerializable()
class GroupApiRequestData {
  GroupApiRequestData();

  factory GroupApiRequestData.fromJson(Map<String, dynamic> json) =>
      _$GroupApiRequestDataFromJson(json);

  Map<String, dynamic> toJson() => _$GroupApiRequestDataToJson(this);
}

@JsonSerializable()
class RequestResponse {
  RequestResponse({required this.request});

  final List<RequestResponseContent> request;

  factory RequestResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestResponseToJson(this);
}

@JsonSerializable()
class RequestResponseContent {
  RequestResponseContent({
    required this.id,
    required this.groupID,
  });

  final int id;
  final int groupID;

  factory RequestResponseContent.fromJson(Map<String, dynamic> json) =>
      _$RequestResponseContentFromJson(json);

  Map<String, dynamic> toJson() => _$RequestResponseContentToJson(this);
}

@JsonSerializable()
class GroupDisagreeData {
  GroupDisagreeData({
    required this.groupID,
    required this.userID,
  });

  final int groupID;
  final int userID;

  factory GroupDisagreeData.fromJson(Map<String, dynamic> json) =>
      _$GroupDisagreeDataFromJson(json);

  Map<String, dynamic> toJson() => _$GroupDisagreeDataToJson(this);
}

@JsonSerializable()
class DisagreeResponse {
  DisagreeResponse();

  factory DisagreeResponse.fromJson(Map<String, dynamic> json) =>
      _$DisagreeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DisagreeResponseToJson(this);
}

@JsonSerializable()
class SetGroupInfoData {
  SetGroupInfoData({
    required this.id,
    required this.name,
    this.profile = '',
  });

  final int id;
  final String name;
  final String profile;

  factory SetGroupInfoData.fromJson(Map<String, dynamic> json) =>
      _$SetGroupInfoDataFromJson(json);

  Map<String, dynamic> toJson() => _$SetGroupInfoDataToJson(this);
}

@JsonSerializable()
class SetNameResponse {
  SetNameResponse();

  factory SetNameResponse.fromJson(Map<String, dynamic> json) =>
      _$SetNameResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SetNameResponseToJson(this);
}

@JsonSerializable()
class MemberData {
  MemberData({
    required this.id,
  });

  final int id;

  factory MemberData.fromJson(Map<String, dynamic> json) =>
      _$MemberDataFromJson(json);

  Map<String, dynamic> toJson() => _$MemberDataToJson(this);
}

@JsonSerializable()
class MemberResponse {
  MemberResponse({
    required this.owner,
    required this.admin,
    required this.member,
  });

  final int owner;
  final List<int> admin;
  final List<int> member;

  factory MemberResponse.fromJson(Map<String, dynamic> json) =>
      _$MemberResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MemberResponseToJson(this);
}

@JsonSerializable()
class TData {
  TData({
    required this.groupID,
    required this.userID,
  });

  final int groupID;
  final int userID;

  factory TData.fromJson(Map<String, dynamic> json) => _$TDataFromJson(json);

  Map<String, dynamic> toJson() => _$TDataToJson(this);
}

@JsonSerializable()
class TResponse {
  TResponse();

  factory TResponse.fromJson(Map<String, dynamic> json) =>
      _$TResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TResponseToJson(this);
}

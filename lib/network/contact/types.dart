import 'package:freezed_annotation/freezed_annotation.dart';

part 'types.g.dart';

@JsonSerializable()
class SetAvatarData {
  SetAvatarData({
    required this.id,
    required this.file,
  });

  final int id;
  final String file;

  factory SetAvatarData.fromJson(Map<String, dynamic> json) =>
      _$SetAvatarDataFromJson(json);

  Map<String, dynamic> toJson() => _$SetAvatarDataToJson(this);
}

@JsonSerializable()
class SetAvatarResponse {
  SetAvatarResponse({
    required this.id,
  });

  final String id;

  factory SetAvatarResponse.fromJson(Map<String, dynamic> json) =>
      _$SetAvatarResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SetAvatarResponseToJson(this);
}

@JsonSerializable()
class NameData {
  NameData({
    required this.id,
  });

  final int id;

  factory NameData.fromJson(Map<String, dynamic> json) =>
      _$NameDataFromJson(json);

  Map<String, dynamic> toJson() => _$NameDataToJson(this);
}

@JsonSerializable()
class NameResponse {
  NameResponse({
    required this.name,
  });

  final String name;

  factory NameResponse.fromJson(Map<String, dynamic> json) =>
      _$NameResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NameResponseToJson(this);
}

@JsonSerializable()
class JoinData {
  JoinData({
    required this.id,
  });

  final int id;

  factory JoinData.fromJson(Map<String, dynamic> json) =>
      _$JoinDataFromJson(json);

  Map<String, dynamic> toJson() => _$JoinDataToJson(this);
}

@JsonSerializable()
class JoinResponse {
  JoinResponse();

  factory JoinResponse.fromJson(Map<String, dynamic> json) =>
      _$JoinResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JoinResponseToJson(this);
}

@JsonSerializable()
class ExitData {
  ExitData({
    required this.id,
  });

  final int id;

  factory ExitData.fromJson(Map<String, dynamic> json) =>
      _$ExitDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExitDataToJson(this);
}

@JsonSerializable()
class ExitResponse {
  ExitResponse();

  factory ExitResponse.fromJson(Map<String, dynamic> json) =>
      _$ExitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExitResponseToJson(this);
}

@JsonSerializable()
class ListData {
  ListData();

  factory ListData.fromJson(Map<String, dynamic> json) =>
      _$ListDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListDataToJson(this);
}

@JsonSerializable()
class ListResponse {
  ListResponse({
    required this.result,
  });

  final List<ContactData> result;

  factory ListResponse.fromJson(Map<String, dynamic> json) =>
      _$ListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListResponseToJson(this);
}

@JsonSerializable()
class ContactData {
  ContactData({
    required this.id,
    required this.name,
    required this.avatar,
    required this.profile,
  });

  final int id;
  final String name;
  final String avatar;
  final String profile;

  factory ContactData.fromJson(Map<String, dynamic> json) =>
      _$ContactDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContactDataToJson(this);
}

@JsonSerializable()
class AvatarIDData {
  AvatarIDData({
    required this.id,
  });

  final int id;

  factory AvatarIDData.fromJson(Map<String, dynamic> json) =>
      _$AvatarIDDataFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarIDDataToJson(this);
}

@JsonSerializable()
class AvatarIDResponse {
  AvatarIDResponse({
    required this.name,
  });

  final String name;

  factory AvatarIDResponse.fromJson(Map<String, dynamic> json) =>
      _$AvatarIDResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarIDResponseToJson(this);
}

@JsonSerializable()
class AvatarData {
  AvatarData({
    required this.id,
  });

  final String id;

  factory AvatarData.fromJson(Map<String, dynamic> json) =>
      _$AvatarDataFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarDataToJson(this);
}

@JsonSerializable()
class AvatarResponse {
  AvatarResponse({
    required this.file,
  });

  final String file;

  factory AvatarResponse.fromJson(Map<String, dynamic> json) =>
      _$AvatarResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarResponseToJson(this);
}

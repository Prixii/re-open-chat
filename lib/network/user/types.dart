import 'package:freezed_annotation/freezed_annotation.dart';
part 'types.g.dart';

@JsonSerializable()
class CreateUserData {
  CreateUserData({
    required this.phoneNumber,
    required this.password,
    required this.deviceId,
  });

  final String deviceId;
  final String password;
  final String phoneNumber;

  factory CreateUserData.fromJson(Map<String, dynamic> json) =>
      _$CreateUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserDataToJson(this);
}

@JsonSerializable()
class CreateUserResponse {
  CreateUserResponse({required this.id});

  final int id;

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserResponseToJson(this);
}

@JsonSerializable()
class LoginData {
  LoginData({
    required this.password,
    required this.phoneNumber,
    required this.deviceId,
  });
  final String password;
  final String phoneNumber;
  final String deviceId;
  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class LoginResponse {
  LoginResponse({required this.id});

  final int id;
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class SetPassWordData {
  SetPassWordData({
    required this.oldPassword,
    required this.password,
  });

  final String oldPassword;
  final String password;

  factory SetPassWordData.fromJson(Map<String, dynamic> json) =>
      _$SetPassWordDataFromJson(json);
  Map<String, dynamic> toJson() => _$SetPassWordDataToJson(this);
}

@JsonSerializable()
class SetPasswordResponse {
  SetPasswordResponse();

  factory SetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$SetPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SetPasswordResponseToJson(this);
}

@JsonSerializable()
class SetUserInfoData {
  SetUserInfoData({
    required this.name,
    required this.profile,
  });

  final String name;
  final String profile;

  Map<String, dynamic> toJson() => _$SetUserInfoDataToJson(this);

  factory SetUserInfoData.fromJson(Map<String, dynamic> json) =>
      _$SetUserInfoDataFromJson(json);
}

@JsonSerializable()
class SetInfoResponse {
  SetInfoResponse();

  factory SetInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$SetInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SetInfoResponseToJson(this);
}

@JsonSerializable()
class GetInfoData {
  GetInfoData({
    required this.id,
  });
  final int id;
  factory GetInfoData.fromJson(Map<String, dynamic> json) =>
      _$GetInfoDataFromJson(json);
  Map<String, dynamic> toJson() => _$GetInfoDataToJson(this);
}

@JsonSerializable()
class GetInfoResponse {
  GetInfoResponse(
      {required this.name, required this.profile, required this.avatar});

  final String name, profile, avatar;

  factory GetInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$GetInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetInfoResponseToJson(this);
}

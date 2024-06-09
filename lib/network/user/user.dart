import 'package:re_open_chat/network/api_client.dart';
import 'package:re_open_chat/network/user/types.dart';

final UserApi userApi = UserApi();

class UserApi {
  Future<BasicResponse<CreateUserResponse>> createUser(
      CreateUserData data) async {
    return await httpRequest(
        '/user/create', data.toJson(), CreateUserResponse.fromJson);
  }

  Future<BasicResponse<LoginResponse>> login(LoginData data) async {
    return await httpRequest(
        '/user/login', data.toJson(), LoginResponse.fromJson);
  }

  Future<BasicResponse<SetPasswordResponse>> setPassword(
      SetPassWordData data) async {
    return await httpRequest(
        '/user/setPassword', data.toJson(), SetPasswordResponse.fromJson);
  }

  Future<BasicResponse<SetInfoResponse>> setInfo(SetUserInfoData data) async {
    return await httpRequest(
        '/user/setInfo', data.toJson(), SetInfoResponse.fromJson);
  }

  Future<BasicResponse<GetInfoResponse>> getInfo(GetInfoData data) async {
    return await httpRequest(
        '/user/info', data.toJson(), GetInfoResponse.fromJson);
  }
}

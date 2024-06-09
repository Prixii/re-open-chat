import 'package:re_open_chat/network/contact/types.dart';
import 'package:re_open_chat/network/api_client.dart';

final contactApi = ContactApi();

class ContactApi {
  Future<BasicResponse<SetAvatarResponse>> setAvatar(SetAvatarData data) async {
    return await httpRequest(
        '/contact/setAvatar', data.toJson(), SetAvatarResponse.fromJson);
  }

  Future<BasicResponse<NameResponse>> name(NameData data) async {
    return await httpRequest(
        '/contact/setName', data.toJson(), NameResponse.fromJson);
  }

  Future<BasicResponse<JoinResponse>> join(JoinData data) async {
    return await httpRequest(
        '/contact/join', data.toJson(), JoinResponse.fromJson);
  }

  Future<BasicResponse<ExitResponse>> exit(ExitData data) async {
    return await httpRequest(
        '/contact/exit', data.toJson(), ExitResponse.fromJson);
  }

  Future<BasicResponse<ListResponse>> list(ListData data) async {
    return await httpRequest(
        '/contact/list', data.toJson(), ListResponse.fromJson);
  }

  Future<BasicResponse<AvatarIDResponse>> avatarID(AvatarIDData data) async {
    return await httpRequest(
        '/contact/avatarID', data.toJson(), AvatarIDResponse.fromJson);
  }

  Future<BasicResponse<AvatarResponse>> avatar(AvatarData data) async {
    return await httpRequest(
        '/contact/avatar', data.toJson(), AvatarResponse.fromJson);
  }
}

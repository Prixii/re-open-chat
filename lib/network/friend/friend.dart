import 'package:re_open_chat/network/api_client.dart';
import 'package:re_open_chat/network/friend/types.dart';

final friendApi = FriendApi();

class FriendApi {
  Future<BasicResponse<AgreeResponse>> agree(FriendAgreeData data) async {
    return await httpRequest(
        '/friend/agree', data.toJson(), AgreeResponse.fromJson);
  }

  Future<BasicResponse<RequestResponse>> request(
      FriendApiRequestData data) async {
    return await httpRequest(
        '/friend/request', data.toJson(), RequestResponse.fromJson);
  }

  Future<BasicResponse<DisagreeResponse>> disagree(
      FriendDisagreeData data) async {
    return await httpRequest(
        '/friend/disagree', data.toJson(), DisagreeResponse.fromJson);
  }
}

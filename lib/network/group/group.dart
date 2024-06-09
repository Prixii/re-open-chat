import 'package:re_open_chat/network/api_client.dart';
import 'package:re_open_chat/network/group/types.dart';

final groupApi = GroupApi();

class GroupApi {
  Future<BasicResponse<CreateResponse>> createGroup(CreateData data) async {
    return await httpRequest(
        '/group/create', data.toJson(), CreateResponse.fromJson);
  }

  Future<BasicResponse<SetAdminResponse>> setAdmin(SetAdminData data) async {
    return await httpRequest(
        '/group/setAdmin', data.toJson(), SetAdminResponse.fromJson);
  }

  Future<BasicResponse<RemoveAdminResponse>> removeAdmin(
      RemoveAdminData data) async {
    return await httpRequest(
        '/group/removeAdmin', data.toJson(), RemoveAdminResponse.fromJson);
  }

  Future<BasicResponse<AgreeResponse>> agree(GroupAgreeData data) async {
    return await httpRequest(
        '/group/agree', data.toJson(), AgreeResponse.fromJson);
  }

  Future<BasicResponse<RequestResponse>> request(
      GroupApiRequestData data) async {
    return await httpRequest(
        '/group/request', data.toJson(), RequestResponse.fromJson);
  }

  Future<BasicResponse<DisagreeResponse>> disagree(
      GroupDisagreeData data) async {
    return await httpRequest(
        '/group/disagree', data.toJson(), DisagreeResponse.fromJson);
  }

  Future<BasicResponse<SetNameResponse>> setInfo(SetGroupInfoData data) async {
    return await httpRequest(
        '/group/setInfo', data.toJson(), SetNameResponse.fromJson);
  }

  Future<BasicResponse<MemberResponse>> member(MemberData data) async {
    return await httpRequest(
        '/group/member', data.toJson(), MemberResponse.fromJson);
  }

  Future<BasicResponse<TResponse>> t(TData data) async {
    return await httpRequest('/group/t', data.toJson(), TResponse.fromJson);
  }
}

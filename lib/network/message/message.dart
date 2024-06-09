import 'package:re_open_chat/network/api_client.dart';
import 'package:re_open_chat/network/message/types.dart';

final MessageApi messageApi = MessageApi();

class MessageApi {
  Future<BasicResponse<SendResponse>> send(SendData data) async {
    return await httpRequest('/msg/send', data.toJson(), SendResponse.fromJson);
  }

  Future<BasicResponse<UpResponse>> up(UpData data) async {
    return await httpRequest('/msg/up', data.toJson(), UpResponse.fromJson);
  }

  Future<BasicResponse<DownResponse>> down(DownData data) async {
    return await httpRequest('/msg/down', data.toJson(), DownResponse.fromJson);
  }

  Future<BasicResponse<ImgResponse>> img(ImgData data) async {
    return await httpRequest('/msg/img', data.toJson(), ImgResponse.fromJson);
  }

  Future<BasicResponse<VoiceResponse>> voice(VoiceData data) async {
    return await httpRequest(
        '/msg/voice', data.toJson(), VoiceResponse.fromJson);
  }

  Future<BasicResponse<UploadResponse>> upload(UploadData data) async {
    return await httpRequest(
        '/msg/upload', data.toJson(), UploadResponse.fromJson);
  }
}

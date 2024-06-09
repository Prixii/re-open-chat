import 'package:freezed_annotation/freezed_annotation.dart';

part 'types.g.dart';

@JsonSerializable()
class SendData {
  SendData({
    required this.id,
    required this.content,
    required this.img,
    required this.voice,
  });

  final int id;
  final String content;
  final List<String> img;
  final String voice;

  factory SendData.fromJson(Map<String, dynamic> json) =>
      _$SendDataFromJson(json);

  Map<String, dynamic> toJson() => _$SendDataToJson(this);
}

@JsonSerializable()
class SendResponse {
  SendResponse({
    required this.id,
  });

  final int id;

  factory SendResponse.fromJson(Map<String, dynamic> json) =>
      _$SendResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendResponseToJson(this);
}

@JsonSerializable()
class UpData {
  UpData({
    required this.id,
    required this.msgID,
    required this.num,
  });

  final int id;
  final int msgID;
  final int num;

  factory UpData.fromJson(Map<String, dynamic> json) => _$UpDataFromJson(json);

  Map<String, dynamic> toJson() => _$UpDataToJson(this);
}

@JsonSerializable()
class UpResponse {
  UpResponse({
    required this.msg,
  });

  final List<MessageData> msg;

  factory UpResponse.fromJson(Map<String, dynamic> json) =>
      _$UpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpResponseToJson(this);
}

@JsonSerializable()
class MessageData {
  MessageData(
      {required this.id,
      required this.content,
      required this.img,
      required this.isVoice,
      required this.time,
      required this.sender});

  final int id;
  final String content;
  final List<String> img;
  final bool isVoice;
  final int time;
  final int sender;

  factory MessageData.fromJson(Map<String, dynamic> json) =>
      _$MessageDataFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDataToJson(this);
}

@JsonSerializable()
class DownData {
  DownData({
    required this.id,
    required this.msgID,
    required this.num,
  });

  final int id;
  final int msgID;
  final int num;

  factory DownData.fromJson(Map<String, dynamic> json) =>
      _$DownDataFromJson(json);

  Map<String, dynamic> toJson() => _$DownDataToJson(this);
}

@JsonSerializable()
class DownResponse {
  DownResponse({
    required this.message,
  });

  final List<MessageData> message;

  factory DownResponse.fromJson(Map<String, dynamic> json) =>
      _$DownResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DownResponseToJson(this);
}

@JsonSerializable()
class ImgData {
  ImgData({
    required this.imgID,
    required this.messageID,
  });

  final String imgID;
  final int messageID;

  factory ImgData.fromJson(Map<String, dynamic> json) =>
      _$ImgDataFromJson(json);

  Map<String, dynamic> toJson() => _$ImgDataToJson(this);
}

@JsonSerializable()
class ImgResponse {
  ImgResponse({
    required this.img,
  });

  final String img;

  factory ImgResponse.fromJson(Map<String, dynamic> json) =>
      _$ImgResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ImgResponseToJson(this);
}

@JsonSerializable()
class VoiceData {
  VoiceData({
    required this.id,
  });

  final int id;

  factory VoiceData.fromJson(Map<String, dynamic> json) =>
      _$VoiceDataFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceDataToJson(this);
}

@JsonSerializable()
class VoiceResponse {
  VoiceResponse({
    required this.voice,
  });

  final String voice;

  factory VoiceResponse.fromJson(Map<String, dynamic> json) =>
      _$VoiceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceResponseToJson(this);
}

@JsonSerializable()
class UploadData {
  UploadData({
    required this.type,
    required this.content,
  });

  final String type;
  final String content;

  factory UploadData.fromJson(Map<String, dynamic> json) =>
      _$UploadDataFromJson(json);

  Map<String, dynamic> toJson() => _$UploadDataToJson(this);
}

@JsonSerializable()
class UploadResponse {
  UploadResponse({
    required this.id,
  });

  final String id;

  factory UploadResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadResponseToJson(this);
}

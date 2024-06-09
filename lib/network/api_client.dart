import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:re_open_chat/env/env.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/network/status_code.dart';
import 'package:re_open_chat/utils/client_utils.dart';

final Dio apiClient =
    Dio(BaseOptions(connectTimeout: const Duration(seconds: 3)));
// ..interceptors.add(TalkerDioLogger(
//     talker: talker,
//     settings: const TalkerDioLoggerSettings(
//       printRequestHeaders: true,
//       printResponseHeaders: true,
//       printResponseData: false,
//       printResponseMessage: false,
//     )));

Future<BasicResponse<T>> httpRequest<T>(String path, Map<String, dynamic> data,
    T Function(Map<String, dynamic>) toJson) async {
  final key = _getKey();
  final byteBody = _encrypt(utf8.encode(jsonEncode(data)), key);
  final userAgent =
      base64.encode(_encrypt(md5.convert(utf8.encode(path)).bytes, key));
  Response<dynamic> response = Response(requestOptions: RequestOptions());
  try {
    response = await apiClient.post(Env.base + path,
        data: Stream.fromIterable(byteBody.map((e) => [e])),
        options: Options(headers: {
          HttpHeaders.userAgentHeader: userAgent,
          HttpHeaders.contentLengthHeader: byteBody.length,
          "id": globalBloc.state.user.id
        }, responseType: ResponseType.bytes));
  } on DioException catch (e) {
    if (e.response == null) {
      talker.error(e);
    } else {
      response.statusCode = e.response!.statusCode!;
      response.data = e.response!.data;
    }
  }
  final statusCode = response.statusCode;
  var json = jsonDecode(utf8.decode(_encrypt(response.data, key)));
  String message = json['message'];
  if (statusCode == StatusCode.success.value) {
    return BasicResponse(
      statusCode: StatusCode.success.value,
      data: toJson(json['data']),
    );
  } else {
    throw Exception('$message $StatusCode(code)');
  }
}

List<int> _encrypt(List<int> data, List<int> key) {
  if (data.isEmpty || key.isEmpty) {
    return data;
  }
  final res = List<int>.empty(growable: true);
  final md5Key = md5.convert(key).bytes;
  for (var i = 0; i < data.length; i++) {
    res.add(data[i] ^ md5Key[i % 16]);
  }
  return res;
}

List<int> _getKey() {
  var key = "";
  final time = (DateTime.now().millisecondsSinceEpoch ~/ 100000).toString();
  if (globalBloc.state.user.id == 0) {
    key = Env.versionKey + time;
  } else {
    key = Env.versionKey +
        globalBloc.state.user.password +
        globalBloc.state.user.id.toString() +
        deviceId +
        time;
  }
  return utf8.encode(key);
}

class BasicResponse<T> {
  BasicResponse({required this.statusCode, required this.data});
  int statusCode;
  T data;
}

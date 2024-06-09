import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:custom_platform_device_id/platform_device_id.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:vibration/vibration.dart';

final Talker talker = Talker();
late String deviceId;
bool canVibrate = false;

void getDeviceID() async {
  String? dId;
  if (Platform.isAndroid) {
    dId = await PlatformDeviceId.getDeviceId;
  }
  if (Platform.isWindows) {
    dId = await PlatformDeviceId.getDeviceId;
  }
  if (dId != null) {
    deviceId = dId.trim();
    // talker.debug('getDeviceId: $dId');
  } else {
    throw Exception();
  }
  return;
}

void detectVibration() async {
  Vibration.hasVibrator().then((value) {
    if (value != null) {
      canVibrate = value;
    }
  });
}

void tryVibrate() {
  if (canVibrate) {
    Vibration.vibrate(duration: 150);
  } else {
    talker.debug('damn, i cant vibrate!');
  }
}

// 将Map转换为Json，并转为字符串
String mapToJsonString(Map m) {
  return jsonEncode(m).toString();
}

// 将字符串转换为map
Map<String, dynamic> stringToMap(String str) {
  var json = jsonDecode(str);
  return Map<String, dynamic>.from(json);
}

// 进行md5加密
String md5Encryption(String plainText) {
  var content = const Utf8Encoder().convert(plainText);
  var digest = md5.convert(content);
  return digest.toString();
}

void saveBase64(String base64, String path) async {
  final file = File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  try {
    file.writeAsStringSync(base64);
  } catch (e) {
    if (file.existsSync()) {
      file.deleteSync();
    }
    talker.error(e);
  }
}

String formatTime(int timestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}

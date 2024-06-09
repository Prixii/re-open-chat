import 'dart:convert';
import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/network/message/message.dart';
import 'package:re_open_chat/network/message/types.dart';
import 'package:re_open_chat/utils/client_utils.dart';
import 'package:record/record.dart';

late String recordDir;

AudioRecorder? _recorder;
bool hasRecordPermission = false;
bool _hasRecorderInitialized = false;

AudioPlayer? _player;

void initRecord() async {
  if (_hasRecorderInitialized) return;
  recordDir = '/audio/${globalBloc.state.user.id}';
  _recorder = AudioRecorder();
  hasRecordPermission = await _recorder!.hasPermission();
  _hasRecorderInitialized = true;
}

Future<AudioPlayer> getAudioPlayer() async {
  _player ??= AudioPlayer();
  return _player!;
}

Future<AudioRecorder> getAudioRecorder() async {
  if (!_hasRecorderInitialized) initRecord();
  _recorder ??= AudioRecorder();
  return _recorder!;
}

void startRecord(String path) async {
  if (!_hasRecorderInitialized) initRecord();
  final dir = await getExternalStorageDirectory();
  final filePath = (dir?.path ?? '') + recordDir + path;
  final file = File(filePath);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  getAudioRecorder()
      .then((recorder) => recorder.start(const RecordConfig(), path: filePath));
}

Future<String> stopRecord() async {
  final filePath = await getAudioRecorder().then((recorder) {
    return recorder.stop();
  });
  if (filePath == null) return '';
  final audioFile = File(filePath);
  if (audioFile.existsSync()) {
    final base64Audio = base64Encode(audioFile.readAsBytesSync());
    return base64Audio;
  }
  return '';
}

void cancelRecord() async {
  getAudioRecorder().then((recorder) => recorder.cancel());
}

void saveBase64ToAudioFile(String base64Audio, int messageId) async {
  final dir = await getExternalStorageDirectory();
  final filePath = '${dir?.path ?? ''}$recordDir/$messageId';
  saveBase64(base64Audio, filePath);
}

void playAudioFromBase64(String base64Audio, int messageId) {
  getExternalStorageDirectory().then((dir) {
    final filePath = '${dir?.path ?? ''}$recordDir/$messageId';
    talker.info(filePath);
    File(filePath).writeAsBytesSync(base64Decode(base64Audio));
    getAudioPlayer().then((player) {
      player.setFilePath(filePath).then((value) => player.play());
    });
  });
}

class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;
  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}

Future<String> getAudioBase64ById(int messageId) async {
  if (!_hasRecorderInitialized) initRecord();
  final dir = await getExternalStorageDirectory();
  final filePath = '${dir?.path ?? ''}$recordDir/$messageId';
  final file = File(filePath);
  if (file.existsSync()) {
    String result = "";
    try {
      result = file.readAsStringSync();
    } catch (e) {
      result = base64Encode(file.readAsBytesSync());
    }
    return result;
  }
  // 从服务器读取音频
  final response = await messageApi.voice(VoiceData(id: messageId));
  final base64Audio = response.data.voice;
  saveBase64ToAudioFile(base64Audio, messageId);
  return base64Audio;
}

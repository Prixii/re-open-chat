import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/network/contact/contact.dart';
import 'package:re_open_chat/network/contact/types.dart';
import 'package:re_open_chat/network/message/message.dart';
import 'package:re_open_chat/network/message/types.dart';
import 'package:re_open_chat/utils/client_utils.dart';

final ImagePicker imagePicker = ImagePicker();

bool containsImage(XFile image, List<XFile> images) {
  for (var img in images) {
    if (img.name == image.name) {
      return true;
    }
  }
  return false;
}

void saveBase64ToImageFile(String base64Image, String imageId,
    {bool isAvatar = false}) async {
  final filePath = await getImagePathById(imageId, isAvatar: isAvatar);
  final file = File(filePath);
  if (file.existsSync()) {
    file.writeAsBytes([]);
  } else {
    file.createSync(recursive: true);
  }
  saveBase64(base64Image, filePath);
}

Future<String> getImageBase64ById(String imageId,
    {bool isAvatar = false, int messageId = 0}) async {
  assert(messageId != 0 || isAvatar);
  final String filePath = await getImagePathById(imageId, isAvatar: isAvatar);
  final file = File(filePath);
  late String imageBase64;
  if (file.existsSync()) {
    imageBase64 = file.readAsStringSync();
    if (imageBase64.isNotEmpty) return imageBase64;
  }
  talker.info('$filePath not exist or is null');
  if (isAvatar) {
    final response = await contactApi.avatar(AvatarData(id: imageId));
    imageBase64 = response.data.file;
  } else {
    final response =
        await messageApi.img(ImgData(imgID: imageId, messageID: messageId));
    imageBase64 = response.data.img;
  }
  saveBase64ToImageFile(imageBase64, imageId, isAvatar: isAvatar);
  // 从服务器读取图片
  return imageBase64;
}

Future<String> getImagePathById(String imageId, {bool isAvatar = false}) async {
  final dir = await getExternalStorageDirectory();
  final String filePath = isAvatar
      ? '${dir?.path ?? ''}/avatar/${globalBloc.state.user.id}/$imageId'
      : '${dir?.path ?? ''}/img/${globalBloc.state.user.id}/$imageId';
  return filePath;
}

Future<String> parseImageToBase64(XFile image) async {
  final bytes = await image.readAsBytes();
  return base64Encode(bytes);
}

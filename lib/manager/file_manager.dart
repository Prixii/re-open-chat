import 'package:flutter/material.dart';

final fileManager = FileManager();

class FileManager {
  Image getAvatar() {
    return Image.asset('assets/images/avatar.png');
  }

  Image getImage(String path) {
    return Image.asset(path);
  }

  void getAudio() {}
}

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:re_open_chat/bloc/message/message_bloc.dart';

class ImageMasonry extends StatelessWidget {
  const ImageMasonry(
      {super.key, this.imageUrls = const [], this.imageFiles = const []});
  final List<String> imageUrls;
  final List<XFile> imageFiles;

  @override
  Widget build(BuildContext context) {
    return (imageCount == 0)
        ? const SizedBox.shrink()
        : MasonryGridView.count(
            crossAxisCount: min(imageCount, 3),
            shrinkWrap: true,
            mainAxisSpacing: 4,
            itemCount: imageCount,
            itemBuilder: ((context, index) {
              if (useImageUrl()) {
                return BlocSelector<MessageBloc, MessageState, String>(
                  selector: (state) {
                    return state.imageBase64Map[imageUrls[index]] ?? '';
                  },
                  builder: (context, base64) {
                    return base64.isEmpty
                        ? const CircularProgressIndicator()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              base64Decode(base64),
                            ),
                          );
                  },
                );
              } else {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(imageFiles[index].path),
                    fit: BoxFit.cover,
                  ),
                );
              }
            }),
          );
  }

  int get imageCount => imageFiles.length + imageUrls.length;

  bool useImageUrl() {
    return imageFiles.isEmpty;
  }
}

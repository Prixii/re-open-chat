import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:re_open_chat/bloc/message_box/message_box_event.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:unicons/unicons.dart';

const double deletableImageHeight = 80;

class DeletableImage extends StatelessWidget {
  const DeletableImage({super.key, required this.image});

  final XFile image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: deletableImageHeight,
              child: Image(
                image: FileImage(File(image.path)),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: _buildDeleteButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: () => readMessageBoxBloc(context).add(RemoveImage(image)),
        child: Container(
          width: 16,
          height: 16,
          color: Colors.red[400],
          child: const Icon(
            UniconsLine.times,
            size: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

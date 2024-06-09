import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:re_open_chat/bloc/message_box/message_box_bloc.dart';
import 'package:re_open_chat/bloc/message_box/message_box_event.dart';
import 'package:re_open_chat/components/chat/message_box/image_container/deletable_image.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:unicons/unicons.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({super.key, required this.preferredWidth});
  final double preferredWidth;
  @override
  Widget build(BuildContext context) {
    return BlocSelector<MessageBoxBloc, MessageBoxState, List<XFile>>(
      selector: (state) {
        return state.images;
      },
      builder: (context, selectedImages) {
        return Visibility(
          visible: selectedImages.isNotEmpty,
          child: SizedBox(
            height: deletableImageHeight + 10,
            width: preferredWidth,
            child: ClipRect(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (index == selectedImages.length) {
                          return _buildAddImageEnter(context);
                        }
                        return DeletableImage(
                          key: Key(selectedImages[index].path),
                          image: selectedImages[index],
                        );
                      },
                      itemCount: selectedImages.length + 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddImageEnter(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final images = await ImagePicker().pickMultiImage();
        if (context.mounted) {
          readMessageBoxBloc(context).add(AddImages(images));
        }
      },
      child: const SizedBox(
        width: deletableImageHeight,
        child: Center(
          child: Icon(
            UniconsLine.plus,
            size: 32,
          ),
        ),
      ),
    );
  }
}

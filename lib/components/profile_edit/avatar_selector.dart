import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:re_open_chat/bloc/profile_edit/profile_edit_bloc.dart';
import 'package:re_open_chat/bloc/profile_edit/profile_edit_event.dart';
import 'package:re_open_chat/gen/assets.gen.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:re_open_chat/utils/image_utils.dart';

class AvatarSelector extends StatelessWidget {
  const AvatarSelector({super.key});

  @override
  Widget build(BuildContext context) {
    const size = 128.0;
    return SizedBox(
      height: 198,
      child: Center(
        child: SizedBox(
          height: size,
          width: size,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: GestureDetector(
              onTap: () => {
                imagePicker
                    .pickImage(source: ImageSource.gallery)
                    .then((imageSelected) async {
                  if (imageSelected == null) return;
                  final base64 = await parseImageToBase64(imageSelected);
                  if (base64 == '') return;
                  if (context.mounted) {
                    readProfileEditBloc(context).add(ChangeAvatar(base64));
                  }
                })
              },
              child: BlocSelector<ProfileEditBloc, ProfileEditState, String>(
                selector: (state) {
                  return state.avatarBase64;
                },
                builder: (context, avatarBase64) {
                  return avatarBase64 == ''
                      ? Assets.imgs.avatar1.image(fit: BoxFit.cover)
                      : Image.memory(
                          base64Decode(avatarBase64),
                          fit: BoxFit.cover,
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

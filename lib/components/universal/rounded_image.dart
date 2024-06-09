import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_bloc.dart';
import 'package:re_open_chat/gen/assets.gen.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({super.key, required this.size, required this.contactId});

  final double size;
  final int contactId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: BlocSelector<ContactManagerBloc, ContactManagerState, String>(
          selector: (state) {
            return state.avatarBase64Map[contactId] ?? '';
          },
          builder: (context, avatarBase64) {
            return avatarBase64 == ''
                ? Assets.imgs.avatar1.image()
                : Image.memory(base64Decode(avatarBase64), fit: BoxFit.fill);
          },
        ),
      ),
    );
  }
}

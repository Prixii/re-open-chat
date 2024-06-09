import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_bloc.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_event.dart';
import 'package:re_open_chat/gen/assets.gen.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:re_open_chat/view/splash.dart';

class BaseInfoDisplay extends StatelessWidget {
  const BaseInfoDisplay({
    super.key,
    required this.contact,
    required this.child,
  });
  final Contact contact;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          stretchTriggerOffset: 300,
          expandedHeight: screenSize.width,
          flexibleSpace: FlexibleSpaceBar(
            title: _buildInfo(),
            background: _buildBlurredAvatar(context),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: child,
          ),
        )
      ],
    );
  }

  Widget _buildBlurredAvatar(BuildContext context) {
    readContactManagerBloc(context).add(GetAvatarById(contact.id));
    return Stack(
      children: [
        BlocSelector<ContactManagerBloc, ContactManagerState, String>(
          selector: (state) {
            return state.avatarBase64Map[contact.id] ?? '';
          },
          builder: (context, avatarBase64) {
            return Center(
              child: avatarBase64 == ''
                  ? Assets.imgs.avatar1.image()
                  : Image.memory(base64Decode(avatarBase64)),
            );
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: 100,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipRect(
              child: Container(
            height: 100,
            color: Colors.black.withOpacity(0.6),
          )),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNameAndId(),
        Padding(
          padding: const EdgeInsets.only(right: 32.0),
          child: Text(
            contact.profile,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildNameAndId() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          contact.name,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '#${contact.id}',
          style: const TextStyle(
            fontSize: 6,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }
}

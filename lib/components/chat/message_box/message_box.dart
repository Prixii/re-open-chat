import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:re_open_chat/bloc/message_box/message_box_bloc.dart';
import 'package:re_open_chat/bloc/message_box/message_box_event.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:unicons/unicons.dart';

const double messageBoxHeight = 70;
const double messageBoxTopPadding = 10;
const double messageBoxBottomPadding = 20;
const double minContentSize =
    messageBoxHeight - messageBoxBottomPadding - messageBoxTopPadding;

class MessageBox extends StatelessWidget {
  const MessageBox({super.key});

  @override
  Widget build(BuildContext context) {
    readMessageBoxBloc(context).add(const MessageBoxInitialize());
    final theme = readThemeData(context);
    return BlocProvider(
      create: (context) => MessageBoxBloc(),
      child: Container(
        color: theme.colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              8.0, messageBoxTopPadding, 8.0, messageBoxBottomPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAddImageButton(context),
              Expanded(child: _buildTextInput(context)),
              _buildSendButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddImageButton(BuildContext context) {
    return SizedBox(
      width: minContentSize,
      height: minContentSize,
      child: Center(
        child: IconButton(
          onPressed: () async {
            final images = await ImagePicker().pickMultiImage();
            if (context.mounted) {
              readMessageBoxBloc(context).add(AddImages(images));
            }
          },
          icon: Icon(
            UniconsLine.image,
            color: readThemeData(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(minContentSize / 2),
      child: Container(
        color: Colors.white,
        child: TextField(
          maxLines: 10,
          minLines: 1,
          style: const TextStyle(
            fontSize: 16.0,
            height: 1,
            textBaseline: TextBaseline.ideographic,
          ),
          decoration: const InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              border: InputBorder.none),
          controller: readMessageBoxBloc(context).state.messageController,
        ),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return SizedBox(
      width: minContentSize,
      height: minContentSize,
      child: Center(
        child: IconButton(
          onPressed: () => readMessageBoxBloc(context).add(const SendMessage()),
          icon: Icon(
            UniconsLine.telegram,
            color: readThemeData(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

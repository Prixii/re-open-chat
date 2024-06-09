import 'package:image_picker/image_picker.dart';

sealed class MessageBoxEvent {
  const MessageBoxEvent();
}

final class StartRecord extends MessageBoxEvent {
  const StartRecord(this.recordPath);
  final String recordPath;
}

final class CancelRecord extends MessageBoxEvent {
  const CancelRecord();
}

final class StopRecordAndSend extends MessageBoxEvent {
  const StopRecordAndSend();
}

final class SendMessage extends MessageBoxEvent {
  const SendMessage();
}

final class AddImages extends MessageBoxEvent {
  const AddImages(this.list);
  final List<XFile> list;
}

final class RemoveImage extends MessageBoxEvent {
  const RemoveImage(this.image);
  final XFile image;
}

final class UpdateText extends MessageBoxEvent {
  const UpdateText(this.text);
  final String text;
}

final class MessageBoxInitialize extends MessageBoxEvent {
  const MessageBoxInitialize();
}

final class EnterCancelArea extends MessageBoxEvent {
  const EnterCancelArea();
}

final class LeaveCancelArea extends MessageBoxEvent {
  const LeaveCancelArea();
}

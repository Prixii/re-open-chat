import 'package:re_open_chat/model/contact.dart';

sealed class ContactManagerEvent {
  const ContactManagerEvent();
}

final class ToContactDetail extends ContactManagerEvent {
  const ToContactDetail({required this.contactId, this.fromGroup = false});
  final int contactId;
  final bool fromGroup;
}

final class ContactsUpdate extends ContactManagerEvent {
  const ContactsUpdate(this.contacts);
  final List<Contact> contacts;
}

final class GetAvatarById extends ContactManagerEvent {
  const GetAvatarById(this.id);
  final int id;
}

final class AddContactsCache extends ContactManagerEvent {
  const AddContactsCache(this.contacts);
  final List<Contact> contacts;
}

final class InitializeContactManager extends ContactManagerEvent {
  const InitializeContactManager();
}

final class LogOutContactManager extends ContactManagerEvent {
  const LogOutContactManager();
}

final class EditGroupData extends ContactManagerEvent {
  const EditGroupData();
}

final class UpdateContactProfile extends ContactManagerEvent {
  const UpdateContactProfile(this.contact, this.avatarBase64, this.newAvatarId);
  final Contact contact;
  final String avatarBase64;
  final String newAvatarId;
}

final class FetchGroupMembers extends ContactManagerEvent {
  const FetchGroupMembers(this.groupId);
  final int groupId;
}

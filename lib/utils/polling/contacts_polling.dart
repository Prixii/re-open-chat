import 'package:re_open_chat/bloc/contact_manager/contact_manager_event.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/manager/sqlite_manager.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/network/contact/contact.dart';
import 'package:re_open_chat/network/contact/types.dart';
import 'package:re_open_chat/utils/polling/polling.dart';
import 'package:re_open_chat/utils/sqlite/contact.dart';

class ContactsPolling extends Polling {
  late List<int> oldContacts;
  List<Contact> contactsToUpdate = [];
  Map<int, bool> stillContacts = {};
  List<Contact> newContacts = [];
  List<int> deletedContacts = [];
  @override
  Future<void> saveSnapShot() async {
    oldContacts = [...contactManagerBloc.state.addedOnContactId];
    newContacts = [];
    deletedContacts = [];
    for (final entry in oldContacts) {
      stillContacts[entry] = false;
    }
    return;
  }

  @override
  Future<void> sendRequest() async {
    contactsToUpdate = [];
    await contactApi.list(ListData()).then((value) {
      final latestContacts = value.data.result;
      for (final contact in latestContacts) {
        final element = Contact.isGroup(contact.id)
            ? Group.fromContactData(contact)
            : User.fromContactData(contact, addedOn: 1);
        // stillContacts 包含本联系人，说明本来就是好友，而且没有被删除
        if (stillContacts[contact.id] == false) {
          stillContacts[contact.id] = true;
        } else {
          // 不包含本联系人，说明是新联系人
          newContacts.add(element);
        }
        contactsToUpdate.add(element);
      }
    });
    _generateContactsDeleted();
    return;
  }

  void _generateContactsDeleted() {
    stillContacts.forEach((key, value) {
      if (!value) deletedContacts.add(key);
    });
  }

  @override
  Future<void> store() async {
    /**
     * 将新的添加到数据库
     * 将被删除的置 add_on 为 0
     */
    await sqliteManager.insertContacts(newContacts, true);
    await sqliteManager.deleteContacts(deletedContacts);
    return;
  }

  @override
  Future<void> notifyBloc() async {
    contactManagerBloc.add(ContactsUpdate(contactsToUpdate));
    return;
  }

  @override
  bool shouldRestartTimer() {
    return true;
  }
}

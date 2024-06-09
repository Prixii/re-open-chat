import 'package:re_open_chat/utils/polling/all_contacts_message_polling.dart';
import 'package:re_open_chat/utils/polling/application_polling.dart';
import 'package:re_open_chat/utils/polling/contacts_polling.dart';

final pollingManager = PollingManager();

class PollingManager {
  final allContactsMessagePolling = AllContactsMessagePolling();
  final applicationPolling = ApplicationPolling();
  final contactsPolling = ContactsPolling();

  void startAll() {
    allContactsMessagePolling.runAndRequestImmediately();
    applicationPolling.runAndRequestImmediately();
    contactsPolling.runAndRequestImmediately();
  }

  void checkAll() {
    allContactsMessagePolling.checkPageState();
    applicationPolling.checkPageState();
    contactsPolling.checkPageState();
  }

  void stopAll() {
    allContactsMessagePolling.stop();
    applicationPolling.stop();
    contactsPolling.stop();
  }
}

import 'package:re_open_chat/bloc/message/message_event.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/manager/sqlite_manager.dart';
import 'package:re_open_chat/model/message.dart';
import 'package:re_open_chat/network/message/message.dart';
import 'package:re_open_chat/network/message/types.dart';
import 'package:re_open_chat/utils/client_utils.dart';
import 'package:re_open_chat/utils/polling/polling.dart';
import 'package:re_open_chat/utils/sqlite/message.dart';

class AllContactsMessagePolling extends Polling {
  late List<int> contactsSnapshot;

  /// [[contactId], [unreadMessageCount]]
  late Map<int, int> unreadMessageCountMapSnapshot;

  /// [[contactId], [lastMessage]]
  late Map<int, Message?> lastMessageMapSnapshot;

  /// [[contactId], [newMessages]]
  Map<int, List<Message>> newMessageMap = {};

  @override
  Future<void> saveSnapShot() async {
    contactsSnapshot = [...contactManagerBloc.state.addedOnContactId];
    unreadMessageCountMapSnapshot = {...messageBloc.state.unreadMessageCount};
    lastMessageMapSnapshot = {...messageBloc.state.lastMessage};
  }

  @override
  Future<void> sendRequest() async {
    final currentContactId = chatManagerBloc.state.currentContact?.id;
    if (printDebug) talker.debug('AllContactsMessagePolling sendRequest');
    for (final contactId in contactsSnapshot) {
      if (contactId == globalBloc.state.user.id) continue;
      final lastMessageId = lastMessageMapSnapshot[contactId]?.id ?? 0;
      await messageApi
          .down(DownData(id: contactId, msgID: lastMessageId, num: 20))
          .then((value) {
        final messageDataList = value.data.message;
        newMessageMap[contactId] = [];
        if (messageDataList.isEmpty) return;
        Message lastMessage =
            Message.fromMessageData(messageDataList.last, contactId);
        int unreadMessageCount = unreadMessageCountMapSnapshot[contactId] ?? 0;
        unreadMessageCountMapSnapshot[contactId] =
            (contactId == currentContactId)
                ? 0
                : (unreadMessageCount + messageDataList.length);
        lastMessageMapSnapshot[contactId] = lastMessage;

        for (var element in messageDataList) {
          newMessageMap[contactId]!
              .add(Message.fromMessageData(element, contactId));
        }
      });
    }
    return;
  }

  @override
  Future<void> store() async {
    final currentContactId = chatManagerBloc.state.currentContact?.id;
    if (currentContactId != null) {
      unreadMessageCountMapSnapshot[currentContactId] = 0;
    }
    newMessageMap.forEach((contactId, newMessages) async {
      await sqliteManager.insertMessages(newMessages, contactId);
    });
    sqliteManager.storeAllLastMessage(
      unreadMessageCountMapSnapshot,
      lastMessageMapSnapshot,
    );
    return;
  }

  @override
  Future<void> notifyBloc() async {
    messageBloc.add(UpdateMessage(
        unreadMessageCountMapSnapshot, lastMessageMapSnapshot, newMessageMap));
    return;
  }

  @override
  bool shouldRestartTimer() {
    return true;
  }
}

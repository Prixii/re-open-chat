import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/manager/sqlite_manager.dart';
import 'package:re_open_chat/model/message.dart';
import 'package:re_open_chat/utils/client_utils.dart';
import 'package:sqflite/sqflite.dart';

extension SqliteMessageExtension on SqliteManager {
  Future<void> insertMessages(List<Message> messages, int contactId) async {
    await db.transaction((txn) async {
      for (final message in messages) {
        final result = await txn.insert(
          'message',
          {
            'id': message.id,
            'contact_id': contactId,
            'sender_id': message.senderId,
            'content': message.content,
            'time': message.time,
            'imgs': message.imgs.toString(),
            'is_voice': message.isVoice ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        if (result == 0) {
          talker.error("insertError: $message");
        }
      }
    });
  }

  Future<Map<int, Message?>> loadAllLastMessage() async {
    final addedOnContactsIdSnapshot = contactManagerBloc.state.addedOnContactId;
    final lastMessageMap = <int, Message?>{};
    for (var contactId in addedOnContactsIdSnapshot) {
      final result = await db.query(
        'message',
        where: 'contact_id = ?',
        whereArgs: [contactId],
        orderBy: 'time DESC',
        limit: 1,
      );
      if (result.isNotEmpty) {
        final messageElement = result[0];
        final imageListData = messageElement['imgs'] as String;
        final imageList =
            imageListData.substring(1, imageListData.length - 1).split(',');
        if (imageList[0] == '') {
          imageList.removeAt(0);
        }
        for (var i = 0; i < imageList.length; i++) {
          imageList[i] = imageList[i].trim();
        }
        lastMessageMap[contactId] = Message(
          id: messageElement['id'] as int,
          senderId: messageElement['sender_id'] as int,
          contactId: messageElement['contact_id'] as int,
          content: messageElement['content'] as String,
          time: messageElement['time'] as int,
          imgs: imageList,
          isVoice: messageElement['is_voice'] == 1 ? true : false,
        );
      }
    }
    return lastMessageMap;
  }

  Future<Map<int, int>> loadAllUnreadMessageCount() async {
    final addedOnContactsIdSnapshot = contactManagerBloc.state.addedOnContactId;
    final unreadMessageCount = <int, int>{};
    for (var contactId in addedOnContactsIdSnapshot) {
      final result = await db.query(
        'contact',
        where: 'id = ?',
        whereArgs: [contactId],
      );

      if (result.isNotEmpty) {
        unreadMessageCount[contactId] =
            result[0]['unread_message_count'] as int;
      }
    }
    return unreadMessageCount;
  }

  Future<List<Message>> loadUnreadMessage(int contactId) async {
    final results = await db.query(
      'message',
      where: 'contact_id = ? AND id > ?',
      whereArgs: [contactId, 0],
    );
    final messages = <Message>[];
    for (var messageElement in results) {
      final imageListData = messageElement['imgs'] as String;
      final imageList =
          imageListData.substring(1, imageListData.length - 1).split(',');
      if (imageList[0] == '') {
        imageList.removeAt(0);
      }
      for (var i = 0; i < imageList.length; i++) {
        imageList[i] = imageList[i].trim();
      }
      final message = Message(
        id: messageElement['id'] as int,
        senderId: messageElement['sender_id'] as int,
        contactId: messageElement['contact_id'] as int,
        content: messageElement['content'] as String,
        time: messageElement['time'] as int,
        imgs: imageList,
        isVoice: messageElement['is_voice'] == 1 ? true : false,
      );
      messages.add(message);
    }
    return messages;
  }

  Future<void> storeAllLastMessage(
    Map<int, int> unreadMessageCountMap,
    Map<int, Message?> lastMessageMap,
  ) async {
    await db.transaction((txn) async {
      for (final entry in unreadMessageCountMap.entries) {
        final contactId = entry.key;
        final unreadMessageCount = entry.value;
        final result = await txn.update(
          'contact',
          {
            'unread_message_count': unreadMessageCount,
          },
          where: 'id = ?',
          whereArgs: [contactId],
        );
        if (result == 0) {
          talker.error("updateError: $contactId");
        }
      }
    });

    await db.transaction((txn) async {
      for (final entry in lastMessageMap.entries) {
        final contactId = entry.key;
        final lastMessage = entry.value;
        if (lastMessage == null) continue;
        final result = await txn.update(
          'contact',
          {
            'last_message_id': lastMessage.id,
          },
          where: 'id = ?',
          whereArgs: [contactId],
        );
        if (result == 0) {
          talker.error("updateError: $contactId");
        }
      }
    });
  }
}

import 'package:re_open_chat/manager/sqlite_manager.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/network/user/types.dart';
import 'package:re_open_chat/network/user/user.dart';
import 'package:sqflite/sqflite.dart';

extension SqliteContactExtension on SqliteManager {
  Future<void> insertContacts(List<Contact> contacts, bool addedOn) async {
    final contactsSnapShot = [...contacts];
    await db.transaction((txn) async {
      for (final contact in contactsSnapShot) {
        await txn.insert(
          'contact',
          {
            'id': contact.id,
            'avatar_id': contact.avatarId,
            'name': contact.name,
            'profile': contact.profile,
            'added_on': addedOn,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<void> deleteContacts(List<int> ids) async {
    await db.transaction((txn) async {
      for (final id in ids) {
        await txn.update(
          'contact',
          {
            'added_on': 0,
          },
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    });
  }

  Future<void> updateContactInfo(
    List<Contact> contacts,
  ) async {
    await db.transaction((txn) async {
      for (final contact in contacts) {
        await txn.insert(
          'contact',
          {
            'id': contact.id,
            'avatar_id': contact.avatarId,
            'name': contact.name,
            'profile': contact.profile,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<Contact?> findContactById(int id) async {
    final contacts = await db.query(
      'contact',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (contacts.isEmpty) {
      Contact? contact;
      await userApi.getInfo(GetInfoData(id: id)).then((value) {
        if (Contact.isGroup(id)) {
          contact = Group(
              id: id,
              avatarId: value.data.avatar,
              profile: value.data.profile,
              name: value.data.name);
        } else {
          contact = User(
              id: id,
              avatarId: value.data.avatar,
              profile: value.data.profile,
              name: value.data.name);
        }
      });
      return contact;
    }
    final name = contacts.first['name'] as String;
    final profile = contacts.first['profile'] as String;
    final avatarId = contacts.first['avatar_id'] as String;
    final addedOn = contacts.first['added_on'] as int;
    if (Contact.isGroup(id)) {
      return Group(
        avatarId: avatarId,
        id: id,
        name: name,
        profile: profile,
      );
    } else {
      return User(
        avatarId: avatarId,
        id: id,
        name: name,
        profile: profile,
        addedOn: addedOn,
      );
    }
  }

  Future<(Map<int, Contact>, List<int>)> loadAllContacts() async {
    final results = await db.query(
      'contact',
      orderBy: 'id DESC',
    );

    final contacts = <int, Contact>{};
    final addedOnContactIds = <int>[];

    for (var result in results) {
      final id = result['id'] as int;
      final addedOn = result['added_on'] as int;
      if (Contact.isGroup(id)) {
        contacts[id] = Group(
          avatarId: result['avatar_id'] as String,
          id: id,
          name: result['name'] as String,
          profile: result['profile'] as String,
          addedOn: addedOn,
        );
      } else {
        contacts[id] = User(
          avatarId: result['avatar_id'] as String,
          id: id,
          name: result['name'] as String,
          profile: result['profile'] as String,
          addedOn: addedOn,
        );
      }
      if (addedOn == 1) {
        addedOnContactIds.add(id);
      }
    }
    return (contacts, addedOnContactIds);
  }
}

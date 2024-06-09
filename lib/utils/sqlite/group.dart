import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/manager/sqlite_manager.dart';
import 'package:sqflite/sqflite.dart';

extension SqliteGroupExtension on SqliteManager {
  Future<Set<int>> getMyGroupsIdSet() async {
    final result = await db.query(
      'group_member',
      where: 'member_id = ? AND permission = 1',
      whereArgs: [globalBloc.state.user.id],
    );
    final Set<int> myGroupIdSet = {};
    if (result.isNotEmpty) {
      for (var element in result) {
        myGroupIdSet.add(element['group_id'] as int);
      }
    }
    return myGroupIdSet;
  }

  Future<bool> isMyGroup(int groupId) async {
    return contactManagerBloc.state.myGroupIdSet.contains(groupId);
  }

  Future<void> saveMembers(
    int groupId,
    int ownerId,
    Set<int> memberIdSet,
  ) async {
    await db.transaction((txn) async {
      await txn.insert(
        'group_member',
        {
          'group_id': groupId,
          'member_id': ownerId,
          'permission': 1,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      for (final memberId in memberIdSet) {
        await txn.insert(
          'group_member',
          {
            'group_id': groupId,
            'member_id': memberId,
            'permission': 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}

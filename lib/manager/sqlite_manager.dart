import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/utils/client_utils.dart';
import 'package:re_open_chat/utils/sqlite/db_schema.dart';
import 'package:sqflite/sqflite.dart';

final sqliteManager = SqliteManager();

class SqliteManager {
  late String dbDirectory;
  bool hasInitialized = false;
  late Database db;

  Future<void> initSqlite() async {
    if (hasInitialized) {
      return;
    }
    final directory = await getExternalStorageDirectory();
    if (directory == null) throw Exception('no external storage');
    dbDirectory = '${directory.path}/${globalBloc.state.user.id}.db';
    await _createDbIfNotExist();
    hasInitialized = true;
  }

  void updateContactMessageState() {
    if (!hasInitialized) return;
  }

  void updateApplications() {
    if (!hasInitialized) return;
  }

  void updateFile() {
    if (!hasInitialized) return;
  }

  Future<bool> hasAddedOn(int contactId) async {
    if (!db.isOpen) throw Exception('db is not open');
    final result =
        await db.rawQuery('SELECT added_on FROM contact WHERE id=$contactId');
    if (result.isEmpty) {
      return false;
    }
    return result.first['added_on'] == 1;
  }

  Future<void> _createDbIfNotExist() async {
    final dbFile = File(dbDirectory);
    if (!dbFile.existsSync()) {
      try {
        db = await openDatabase(
          dbDirectory,
          version: 1,
          onOpen: (Database db) async {
            for (var schema in tableSchemas) {
              await db.execute(schema);
            }
          },
        );
      } catch (e) {
        if (dbFile.existsSync()) {
          dbFile.deleteSync();
        }
        talker.error(e);
      }
    } else {
      // dbFile.deleteSync();
      db = await openDatabase(dbDirectory);
    }

    return;
  }

  void reset() {
    db.close();
    hasInitialized = false;
    dbDirectory = '';
  }
}

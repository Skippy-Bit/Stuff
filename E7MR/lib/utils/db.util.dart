import 'dart:async';
import 'package:e7mr/utils/db_create/create_table_constants.dart';
import 'package:e7mr/utils/db_repair/db_repair.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

const DB_FILE_NAME = 'data.db';
const DB_VERSION = 2;

class DbUtil {
  // Singleton
  static final DbUtil _instance = DbUtil._internal();
  factory DbUtil() => _instance;
  DbUtil._internal();

  // Fields
  Database _db;
  static Future<Database> get db async {
    if (_instance._db == null) {
      _instance._db = await _instance._initDatabase();
    }
    return _instance._db;
  }

  static Future<void> close() async {
    if (_instance._db != null) {
      await _instance._db.close();
      _instance._db = null;
    }
  }

  // Methods
  _initDatabase() async {
    var documentsDir = await getApplicationDocumentsDirectory();
    var path = join(documentsDir.path, DB_FILE_NAME);

    var db = await openDatabase(
      path,
      version: DB_VERSION,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    await repairDB(db);

    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await Future.wait(CREATE_TABLES.map((query) => db.execute(query)));
    await Future.wait(CREATE_INDICES.map(
        (queries) => Future.wait(queries.map((query) => db.execute(query)))));
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion <= 1) {}
  }
}

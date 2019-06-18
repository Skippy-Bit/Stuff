import 'dart:convert';
import 'dart:typed_data';
import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/actions/log_commands/log_command.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/log_state.dart';
import 'package:e7mr/state/models/log_extra_content.dart';
import 'package:redux/redux.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

final uuid = new Uuid();

void postLogPayload(Store<AppState> store, LogCommand command) {
  var hash = command.hash;
  if (hash != null && hash.length > 250) {
    hash = hash.substring(0, 250);
  }

  store.dispatch(
    postLog(
      LogState(
        command: command.name,
        content: _commandToContentBlob(command),
        extraContent: _commandToExtraContentBlob(command),
        uuid: uuid.v1(),
        timeStamp: DateTime.now(),
        hash: hash,
      ),
    ),
  );
}

Uint8List _commandToContentBlob(LogCommand command) {
  final payload = command.encode();
  return _payloadToContentBlob(payload);
}

Uint8List _commandToExtraContentBlob(LogCommand command) {
  if (command.hasExtraContent()) {
    final payload = command.encodeExtraContent();
    return _payloadToContentBlob(payload);
  }
  return null;
}

Uint8List _payloadToContentBlob(Object payload) {
  final jsonPayload = json.encode(payload);
  final bytes = utf8.encode(jsonPayload);
  return Uint8List.fromList(bytes);
}

Future<LogExtraContent> queryLogExtraContent(
  Database db,
  String username,
  String uuid,
) async {
  try {
    final rows = await db.query(
      'LogExtraContent',
      where: 'User = ? AND UUID = ?',
      whereArgs: [username, uuid],
    );
    if (rows == null || rows.isEmpty) {
      return null;
    }
    return LogExtraContent.decodeDB(rows.first);
  } catch (e) {
    return null;
  }
}

Future<void> pruneLogExtraContent(Database db) async {
  try {
    final query = '''
DELETE FROM logextracontent
WHERE  rowid IN (SELECT logextracontent.rowid
                 FROM   logextracontent
                        LEFT JOIN log
                               ON logextracontent.user = log.user
                                  AND logextracontent.uuid = log.uuid
                 WHERE  log.rowid IS NULL);
''';
    await db.rawDelete(query);
  } catch (e) {}
}

import 'package:e7mr/state/models/generated/rejected_hour_state.dart';
import 'package:e7mr/utils/query_args.dart';
import 'package:e7mr/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

enum _Status { INSERTED, UPDATED }

class _UpsertResult {
  final RejectedHourState model;
  final _Status status;
  _UpsertResult(this.model, this.status);
  factory _UpsertResult.inserted(RejectedHourState model) =>
      _UpsertResult(model, _Status.INSERTED);
  factory _UpsertResult.updated(RejectedHourState model) =>
      _UpsertResult(model, _Status.UPDATED);
}

class DBRejectedHour {
  static const TABLE_NAME = 'RejectedHour';

  // Returns the queried rows.
  static Future<Iterable<RejectedHourState>> query(
    Database db,
    String username, {
    int entryNo,
    int internalState = INTERNAL_STATE_NONE,
  }) async {
    if (username != null && username.isNotEmpty) {
      var where = '"User" = ?';
      final args = <dynamic>[username];
      if (entryNo != null) {
        where += ' AND "Entry_No" = ?';
        args.add(entryNo);
      }
      if (internalState != null) {
        where += ' AND "_InternalState" = ?';
        args.add(internalState);
      }

      try {
        final rows = await db?.query(TABLE_NAME, where: where, whereArgs: args);
        return rows.map((row) => RejectedHourState.decodeDB(Map.of(row)));
      } catch (e) {
        return Iterable.empty();
      }
    }
    return Iterable.empty();
  }

  // Returns the id of the inserted row.
  static Future<RejectedHourState> insert(
    Database db,
    String username,
    RejectedHourState model, {
    int internalState,
  }) async {
    if (username != null && username.isNotEmpty) {
      if (internalState != null) {
        model = model.copyWith(internalState: internalState);
      }
      final values = model.encodeDB(username);

      try {
        int rowID = await db?.insert(TABLE_NAME, values);
        return model.copyWith(rowID: rowID);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Returns the number of rows affected.
  static Future<bool> update(
    Database db,
    String username,
    RejectedHourState model, {
    int internalState,
  }) async {
    if (username != null && username.isNotEmpty) {
      if (model.rowID != null) {
        final q = QueryArgs.fromRejectedHour(username, model);
        if (q.isCorrect) {
          if (internalState != null) {
            model = model.copyWith(internalState: internalState);
          }
          final values = model.encodeDB(username);

          int rowsAffected = 0;
          try {
            rowsAffected = await db?.update(
              TABLE_NAME,
              values,
              where: q.query,
              whereArgs: q.args,
            );
          } catch (e) {
            return false;
          }
          return rowsAffected > 0;
        }
      }
    }
    return false;
  }

  static Future<_UpsertResult> upsert(
    Database db,
    String username,
    RejectedHourState model, {
    int internalState,
  }) async {
    if (username != null && username.isNotEmpty) {
      if (internalState != null) {
        model = model.copyWith(internalState: internalState);
      }
      final values = model.encodeDB(username);

      final q = QueryArgs.fromRejectedHour(username, model);
      if (q.isCorrect) {
        int rowsAffected = 0;
        try {
          // Try to update the record.
          rowsAffected = await db?.update(
            TABLE_NAME,
            values,
            where: q.query,
            whereArgs: q.args,
          );
        } catch (e) {
          return null;
        }

        // If it was successful, return the model.
        if (rowsAffected != 0) {
          return _UpsertResult.updated(model);
        }
        // Otherwise, insert it...
      }

      int rowID;
      try {
        // Insert the record.
        rowID = await db?.insert(TABLE_NAME, values);
      } catch (e) {
        return null;
      }

      // Return the newly inserted model with the new ROWID.
      return _UpsertResult.inserted(model.copyWith(rowID: rowID));
    }
    return null;
  }

  // Returns the number of rows affected.
  static Future<bool> delete(
    Database db,
    String username,
    RejectedHourState model,
  ) async {
    if (username != null && username.isNotEmpty) {
      if (model.rowID != null) {
        final q = QueryArgs.fromRejectedHour(username, model);
        if (q.isCorrect) {
          int rowsAffected = 0;
          try {
            rowsAffected =
                await db?.delete(TABLE_NAME, where: q.query, whereArgs: q.args);
          } catch (e) {
            return false;
          }
          return rowsAffected > 0;
        }
      }
    }
    return false;
  }
}
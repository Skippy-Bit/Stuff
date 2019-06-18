import 'package:e7mr/state/models/generated/job_journal_line_state.dart';
import 'package:e7mr/utils/query_args.dart';
import 'package:e7mr/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

enum _Status { INSERTED, UPDATED }

class _UpsertResult {
  final JobJournalLineState model;
  final _Status status;
  _UpsertResult(this.model, this.status);
  factory _UpsertResult.inserted(JobJournalLineState model) =>
      _UpsertResult(model, _Status.INSERTED);
  factory _UpsertResult.updated(JobJournalLineState model) =>
      _UpsertResult(model, _Status.UPDATED);
}

class DBJobJournalLine {
  static const TABLE_NAME = 'JobJournalLine';

  // Returns the queried rows.
  static Future<Iterable<JobJournalLineState>> query(
    Database db,
    String username, {
    String journalTemplateName,
    String journalBatchName,
    int lineNo,
    int internalState = INTERNAL_STATE_NONE,
  }) async {
    if (username != null && username.isNotEmpty) {
      var where = '"User" = ?';
      final args = <dynamic>[username];
      if (journalTemplateName != null) {
        where += ' AND "Journal_Template_Name" = ?';
        args.add(journalTemplateName);
      }
      if (journalBatchName != null) {
        where += ' AND "Journal_Batch_Name" = ?';
        args.add(journalBatchName);
      }
      if (lineNo != null) {
        where += ' AND "Line_No" = ?';
        args.add(lineNo);
      }
      if (internalState != null) {
        where += ' AND "_InternalState" = ?';
        args.add(internalState);
      }

      try {
        final rows = await db?.query(TABLE_NAME, where: where, whereArgs: args);
        return rows.map((row) => JobJournalLineState.decodeDB(Map.of(row)));
      } catch (e) {
        return Iterable.empty();
      }
    }
    return Iterable.empty();
  }

  // Returns the id of the inserted row.
  static Future<JobJournalLineState> insert(
    Database db,
    String username,
    JobJournalLineState model, {
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
    JobJournalLineState model, {
    int internalState,
  }) async {
    if (username != null && username.isNotEmpty) {
      if (model.rowID != null) {
        final q = QueryArgs.fromJobJournalLine(username, model);
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
    JobJournalLineState model, {
    int internalState,
  }) async {
    if (username != null && username.isNotEmpty) {
      if (internalState != null) {
        model = model.copyWith(internalState: internalState);
      }
      final values = model.encodeDB(username);

      final q = QueryArgs.fromJobJournalLine(username, model);
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
    JobJournalLineState model,
  ) async {
    if (username != null && username.isNotEmpty) {
      if (model.rowID != null) {
        final q = QueryArgs.fromJobJournalLine(username, model);
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
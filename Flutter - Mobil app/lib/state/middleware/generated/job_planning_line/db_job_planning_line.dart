import 'package:e7mr/state/models/generated/job_planning_line_state.dart';
import 'package:e7mr/utils/query_args.dart';
import 'package:e7mr/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

enum _Status { INSERTED, UPDATED }

class _UpsertResult {
  final JobPlanningLineState model;
  final _Status status;
  _UpsertResult(this.model, this.status);
  factory _UpsertResult.inserted(JobPlanningLineState model) =>
      _UpsertResult(model, _Status.INSERTED);
  factory _UpsertResult.updated(JobPlanningLineState model) =>
      _UpsertResult(model, _Status.UPDATED);
}

class DBJobPlanningLine {
  static const TABLE_NAME = 'JobPlanningLine';

  // Returns the queried rows.
  static Future<Iterable<JobPlanningLineState>> query(
    Database db,
    String username, {
    String jobNo,
    String jobTaskNo,
    int lineNo,
    int internalState = INTERNAL_STATE_NONE,
  }) async {
    if (username != null && username.isNotEmpty) {
      var where = '"User" = ?';
      final args = <dynamic>[username];
      if (jobNo != null) {
        where += ' AND "Job_No" = ?';
        args.add(jobNo);
      }
      if (jobTaskNo != null) {
        where += ' AND "Job_Task_No" = ?';
        args.add(jobTaskNo);
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
        return rows.map((row) => JobPlanningLineState.decodeDB(Map.of(row)));
      } catch (e) {
        return Iterable.empty();
      }
    }
    return Iterable.empty();
  }

  // Returns the id of the inserted row.
  static Future<JobPlanningLineState> insert(
    Database db,
    String username,
    JobPlanningLineState model, {
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
    JobPlanningLineState model, {
    int internalState,
  }) async {
    if (username != null && username.isNotEmpty) {
      if (model.rowID != null) {
        final q = QueryArgs.fromJobPlanningLine(username, model);
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
    JobPlanningLineState model, {
    int internalState,
  }) async {
    if (username != null && username.isNotEmpty) {
      if (internalState != null) {
        model = model.copyWith(internalState: internalState);
      }
      final values = model.encodeDB(username);

      final q = QueryArgs.fromJobPlanningLine(username, model);
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
    JobPlanningLineState model,
  ) async {
    if (username != null && username.isNotEmpty) {
      if (model.rowID != null) {
        final q = QueryArgs.fromJobPlanningLine(username, model);
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
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e7mr/state/middleware/thunk/thunk.middleware.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/connection_state_selectors.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/state/services/nav.service.dart';
import 'package:e7mr/utils/constants.dart';
import 'package:e7mr/utils/query_args.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/actions/base.actions.dart';
import 'package:e7mr/state/models/generated/item_quantity_state.dart';
import 'package:e7mr/state/models/generated/job_journal_line_state.dart';
import 'package:e7mr/state/models/generated/job_ledger_entry_state.dart';
import 'package:e7mr/state/models/generated/job_planning_line_state.dart';
import 'package:e7mr/state/models/generated/job_task_state.dart';
import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/state/models/generated/location_state.dart';
import 'package:e7mr/state/models/generated/log_state.dart';
import 'package:e7mr/state/models/generated/rejected_hour_state.dart';
import 'package:e7mr/state/models/generated/setup_state.dart';
import 'package:e7mr/state/models/generated/user_location_state.dart';
import 'package:e7mr/state/models/generated/user_setup_state.dart';
import 'package:e7mr/state/models/generated/work_type_state.dart';
import 'package:e7mr/state/middleware/generated/item_quantity/db_item_quantity.dart';
import 'package:e7mr/state/middleware/generated/job_journal_line/db_job_journal_line.dart';
import 'package:e7mr/state/middleware/generated/job_ledger_entry/db_job_ledger_entry.dart';
import 'package:e7mr/state/middleware/generated/job_planning_line/db_job_planning_line.dart';
import 'package:e7mr/state/middleware/generated/job_task/db_job_task.dart';
import 'package:e7mr/state/middleware/generated/job/db_job.dart';
import 'package:e7mr/state/middleware/generated/location/db_location.dart';
import 'package:e7mr/state/middleware/generated/log/db_log.dart';
import 'package:e7mr/state/middleware/generated/log/post_log.dart';
import 'package:e7mr/state/middleware/generated/rejected_hour/db_rejected_hour.dart';
import 'package:e7mr/state/middleware/generated/setup/db_setup.dart';
import 'package:e7mr/state/middleware/generated/user_location/db_user_location.dart';
import 'package:e7mr/state/middleware/generated/user_setup/db_user_setup.dart';
import 'package:e7mr/state/middleware/generated/work_type/db_work_type.dart';

const _ITEM_QUANTITY_SERVICE_ENDPOINT = 'E7MR_Item_Quantities';
const _ITEM_QUANTITY_TABLE_NAME = 'ItemQuantity';

class LoadItemQuantitiesBeginAction {
  LoadItemQuantitiesBeginAction({
    this.no,
    this.etag,
    this.offline,
  });
  final String no;
  final String etag;
  final bool offline;
}

class LoadItemQuantitiesSuccessAction {
  LoadItemQuantitiesSuccessAction(
    this.itemQuantities, {
    this.no,
    this.etag,
    this.offline,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
  });
  final Iterable<ItemQuantityState> itemQuantities;
  final String no;
  final String etag;
  final bool offline;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;
}

class LoadItemQuantitiesFailedAction {
  LoadItemQuantitiesFailedAction({
    this.error,
    this.no,
    this.etag,
    this.offline,
  });
  final ActionError error;
  final String no;
  final String etag;
  final bool offline;
}

ThunkAction<AppState> queryItemQuantities({
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        store.dispatch(LoadItemQuantitiesBeginAction());
        try {
          final itemQuantities = await _queryItemQuantities(
            context?.db,
            distinct: distinct,
            where: where,
            whereArgs: whereArgs,
            groupBy: groupBy,
            having: having,
            orderBy: orderBy,
            limit: limit,
            offset: offset,
          );
          store.dispatch(
            LoadItemQuantitiesSuccessAction(
              itemQuantities,
              queryDistinct: distinct,
              queryWhere: where,
              queryWhereArgs: whereArgs,
              queryGroupBy: groupBy,
              queryHaving: having,
              queryOrderBy: orderBy,
              queryLimit: limit,
              queryOffset: offset,
            ),
          );
        } catch (e) {
          store.dispatch(LoadItemQuantitiesFailedAction(
              error: ActionError(message: 'Could\'nt read the database.')));
        }
      }
    };

Future<Iterable<ItemQuantityState>> queryItemQuantitiesDirect(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async =>
    _queryItemQuantities(
      db,
      distinct: distinct,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

Future<Iterable<ItemQuantityState>> _queryItemQuantities(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async {
  // Query the records from the database
  final rows = await db?.query(
        DBItemQuantity.TABLE_NAME,
        distinct: distinct,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      ) ?? Iterable.empty();

  return rows.map((row) => ItemQuantityState.decodeDB(Map.of(row)));
}

ThunkAction<AppState> loadItemQuantities({
  String no,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = itemQuantityStateStatusSelector(store.state);
        if (status.isLoading) {
          return;
        }
        if (!loadPosted &&
            0 >
                DateTime.now()
                    .difference(status.lastUpdated)
                    .compareTo(const Duration(seconds: 1))) {
          // Limit loading to once per second
          return;
        }

        // DISPATCH: LOAD - Begin
        store.dispatch(LoadItemQuantitiesBeginAction(
          no: no,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          final credentials = user.credentials;
          Response res;

          Iterable<ItemQuantityState> itemQuantities = Iterable.empty();
          final values = List<dynamic>();

          var doneFetching = false;
          var i = 0;
          do {
            try {
              if (no != null) {
                res = await NavService.getSingle(
                  credentials,
                  _ITEM_QUANTITY_SERVICE_ENDPOINT,
                  "No='$no'",
                  etag: etag,
                );
              } else {
                res = await NavService.getMultiple(
                  credentials,
                  _ITEM_QUANTITY_SERVICE_ENDPOINT,
                  skip: i++ * ODATA_MAX_ENTITIES,
                );
              }
            } catch (e) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadItemQuantitiesFailedAction(
                error: ActionError(message: e.toString()),
                no: no,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            if (res == null || res.statusCode != 200) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadItemQuantitiesFailedAction(
                error: ActionError.fromHttpResponse(res),
                no: no,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            final currentValues = NavService.valuesAPI(res);
            if (currentValues != null) {
              values.addAll(currentValues);
            }

            doneFetching = currentValues.length < ODATA_MAX_ENTITIES;
          } while (!doneFetching);

          if (values != null) {
            itemQuantities = values.map((value) => ItemQuantityState.decodeAPI(value));
          }

          // Save the records to the database
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              if (no == null) {
                // Delete all records
                batch.delete(
                  _ITEM_QUANTITY_TABLE_NAME,
                  where: '"_InternalState" = ?',
                  whereArgs: [INTERNAL_STATE_NONE],
                );

                // Insert new records
                for (final model in itemQuantities) {
                  final values = model.encodeDB(user.username);
                  batch.insert(_ITEM_QUANTITY_TABLE_NAME, values);
                }
              } else {
                // Delete->Insert only the fetched records
                for (final model in itemQuantities) {
                  final values = model.encodeDB(user.username);
                  final q = QueryArgs.fromItemQuantity(user.username, model);
                  if (q.isCorrect) {
                    batch.delete(_ITEM_QUANTITY_TABLE_NAME,
                        where: q.query, whereArgs: q.args);
                    batch.insert(_ITEM_QUANTITY_TABLE_NAME, values);
                  }
                }
              }

              batch.commit();
            });
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadItemQuantitiesFailedAction(
                error: ActionError(
              message: 'An unexpected error occurred in the database.',
            )));
            return;
          }
        }


        // Reload last query.
        status = itemQuantityStateStatusSelector(store.state); // Get the latest status
        final itemQuantities = await _queryItemQuantities(
          context?.db,
          distinct: status.queryDistinct,
          where: status.queryWhere,
          whereArgs: status.queryWhereArgs,
          groupBy: status.queryGroupBy,
          having: status.queryHaving,
          orderBy: status.queryOrderBy,
          limit: status.queryLimit,
          offset: status.queryOffset,
        );

        // DISPATCH: LOAD - Success
        store.dispatch(LoadItemQuantitiesSuccessAction(
          itemQuantities,
          no: no,
          etag: etag,
          offline: offline,
          queryDistinct: status.queryDistinct,
          queryWhere: status.queryWhere,
          queryWhereArgs: status.queryWhereArgs,
          queryGroupBy: status.queryGroupBy,
          queryHaving: status.queryHaving,
          queryOrderBy: status.queryOrderBy,
          queryLimit: status.queryLimit,
          queryOffset: status.queryOffset,
        ));
      }
    };

const _JOB_JOURNAL_LINE_SERVICE_ENDPOINT = 'E7MR_Job_Journal_Lines';
const _JOB_JOURNAL_LINE_TABLE_NAME = 'JobJournalLine';

class LoadJobJournalLinesBeginAction {
  LoadJobJournalLinesBeginAction({
    this.journalTemplateName,
    this.journalBatchName,
    this.lineNo,
    this.etag,
    this.offline,
  });
  final String journalTemplateName;
  final String journalBatchName;
  final int lineNo;
  final String etag;
  final bool offline;
}

class LoadJobJournalLinesSuccessAction {
  LoadJobJournalLinesSuccessAction(
    this.jobJournalLines, {
    this.journalTemplateName,
    this.journalBatchName,
    this.lineNo,
    this.etag,
    this.offline,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
  });
  final Iterable<JobJournalLineState> jobJournalLines;
  final String journalTemplateName;
  final String journalBatchName;
  final int lineNo;
  final String etag;
  final bool offline;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;
}

class LoadJobJournalLinesFailedAction {
  LoadJobJournalLinesFailedAction({
    this.error,
    this.journalTemplateName,
    this.journalBatchName,
    this.lineNo,
    this.etag,
    this.offline,
  });
  final ActionError error;
  final String journalTemplateName;
  final String journalBatchName;
  final int lineNo;
  final String etag;
  final bool offline;
}

ThunkAction<AppState> queryJobJournalLines({
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        store.dispatch(LoadJobJournalLinesBeginAction());
        try {
          final jobJournalLines = await _queryJobJournalLines(
            context?.db,
            distinct: distinct,
            where: where,
            whereArgs: whereArgs,
            groupBy: groupBy,
            having: having,
            orderBy: orderBy,
            limit: limit,
            offset: offset,
          );
          store.dispatch(
            LoadJobJournalLinesSuccessAction(
              jobJournalLines,
              queryDistinct: distinct,
              queryWhere: where,
              queryWhereArgs: whereArgs,
              queryGroupBy: groupBy,
              queryHaving: having,
              queryOrderBy: orderBy,
              queryLimit: limit,
              queryOffset: offset,
            ),
          );
        } catch (e) {
          store.dispatch(LoadJobJournalLinesFailedAction(
              error: ActionError(message: 'Could\'nt read the database.')));
        }
      }
    };

Future<Iterable<JobJournalLineState>> queryJobJournalLinesDirect(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async =>
    _queryJobJournalLines(
      db,
      distinct: distinct,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

Future<Iterable<JobJournalLineState>> _queryJobJournalLines(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async {
  // Query the records from the database
  final rows = await db?.query(
        DBJobJournalLine.TABLE_NAME,
        distinct: distinct,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      ) ?? Iterable.empty();

  return rows.map((row) => JobJournalLineState.decodeDB(Map.of(row)));
}

ThunkAction<AppState> loadJobJournalLines({
  String journalTemplateName,
  String journalBatchName,
  int lineNo,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = jobJournalLineStateStatusSelector(store.state);
        if (status.isLoading) {
          return;
        }
        if (!loadPosted &&
            0 >
                DateTime.now()
                    .difference(status.lastUpdated)
                    .compareTo(const Duration(seconds: 1))) {
          // Limit loading to once per second
          return;
        }

        // DISPATCH: LOAD - Begin
        store.dispatch(LoadJobJournalLinesBeginAction(
          journalTemplateName: journalTemplateName,
          journalBatchName: journalBatchName,
          lineNo: lineNo,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          final credentials = user.credentials;
          Response res;

          Iterable<JobJournalLineState> jobJournalLines = Iterable.empty();
          final values = List<dynamic>();

          var doneFetching = false;
          var i = 0;
          do {
            try {
              if (journalTemplateName != null && journalBatchName != null && lineNo != null) {
                res = await NavService.getSingle(
                  credentials,
                  _JOB_JOURNAL_LINE_SERVICE_ENDPOINT,
                  "Journal_Template_Name='$journalTemplateName',Journal_Batch_Name='$journalBatchName',Line_No=$lineNo",
                  etag: etag,
                );
              } else {
                res = await NavService.getMultiple(
                  credentials,
                  _JOB_JOURNAL_LINE_SERVICE_ENDPOINT,
                  skip: i++ * ODATA_MAX_ENTITIES,
                );
              }
            } catch (e) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadJobJournalLinesFailedAction(
                error: ActionError(message: e.toString()),
                journalTemplateName: journalTemplateName,
                journalBatchName: journalBatchName,
                lineNo: lineNo,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            if (res == null || res.statusCode != 200) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadJobJournalLinesFailedAction(
                error: ActionError.fromHttpResponse(res),
                journalTemplateName: journalTemplateName,
                journalBatchName: journalBatchName,
                lineNo: lineNo,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            final currentValues = NavService.valuesAPI(res);
            if (currentValues != null) {
              values.addAll(currentValues);
            }

            doneFetching = currentValues.length < ODATA_MAX_ENTITIES;
          } while (!doneFetching);

          if (values != null) {
            jobJournalLines = values.map((value) => JobJournalLineState.decodeAPI(value));
          }

          // Save the records to the database
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              if (journalTemplateName == null && journalBatchName == null && lineNo == null) {
                // Delete all records
                batch.delete(
                  _JOB_JOURNAL_LINE_TABLE_NAME,
                  where: '"_InternalState" = ?',
                  whereArgs: [INTERNAL_STATE_NONE],
                );

                // Insert new records
                for (final model in jobJournalLines) {
                  final values = model.encodeDB(user.username);
                  batch.insert(_JOB_JOURNAL_LINE_TABLE_NAME, values);
                }
              } else {
                // Delete->Insert only the fetched records
                for (final model in jobJournalLines) {
                  final values = model.encodeDB(user.username);
                  final q = QueryArgs.fromJobJournalLine(user.username, model);
                  if (q.isCorrect) {
                    batch.delete(_JOB_JOURNAL_LINE_TABLE_NAME,
                        where: q.query, whereArgs: q.args);
                    batch.insert(_JOB_JOURNAL_LINE_TABLE_NAME, values);
                  }
                }
              }

              batch.commit();
            });
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadJobJournalLinesFailedAction(
                error: ActionError(
              message: 'An unexpected error occurred in the database.',
            )));
            return;
          }
        }


        // Reload last query.
        status = jobJournalLineStateStatusSelector(store.state); // Get the latest status
        final jobJournalLines = await _queryJobJournalLines(
          context?.db,
          distinct: status.queryDistinct,
          where: status.queryWhere,
          whereArgs: status.queryWhereArgs,
          groupBy: status.queryGroupBy,
          having: status.queryHaving,
          orderBy: status.queryOrderBy,
          limit: status.queryLimit,
          offset: status.queryOffset,
        );

        // DISPATCH: LOAD - Success
        store.dispatch(LoadJobJournalLinesSuccessAction(
          jobJournalLines,
          journalTemplateName: journalTemplateName,
          journalBatchName: journalBatchName,
          lineNo: lineNo,
          etag: etag,
          offline: offline,
          queryDistinct: status.queryDistinct,
          queryWhere: status.queryWhere,
          queryWhereArgs: status.queryWhereArgs,
          queryGroupBy: status.queryGroupBy,
          queryHaving: status.queryHaving,
          queryOrderBy: status.queryOrderBy,
          queryLimit: status.queryLimit,
          queryOffset: status.queryOffset,
        ));
      }
    };

const _JOB_LEDGER_ENTRY_SERVICE_ENDPOINT = 'E7MR_Job_Ledger_Entries';
const _JOB_LEDGER_ENTRY_TABLE_NAME = 'JobLedgerEntry';

class LoadJobLedgerEntriesBeginAction {
  LoadJobLedgerEntriesBeginAction({
    this.entryNo,
    this.etag,
    this.offline,
  });
  final int entryNo;
  final String etag;
  final bool offline;
}

class LoadJobLedgerEntriesSuccessAction {
  LoadJobLedgerEntriesSuccessAction(
    this.jobLedgerEntries, {
    this.entryNo,
    this.etag,
    this.offline,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
  });
  final Iterable<JobLedgerEntryState> jobLedgerEntries;
  final int entryNo;
  final String etag;
  final bool offline;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;
}

class LoadJobLedgerEntriesFailedAction {
  LoadJobLedgerEntriesFailedAction({
    this.error,
    this.entryNo,
    this.etag,
    this.offline,
  });
  final ActionError error;
  final int entryNo;
  final String etag;
  final bool offline;
}

ThunkAction<AppState> queryJobLedgerEntries({
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        store.dispatch(LoadJobLedgerEntriesBeginAction());
        try {
          final jobLedgerEntries = await _queryJobLedgerEntries(
            context?.db,
            distinct: distinct,
            where: where,
            whereArgs: whereArgs,
            groupBy: groupBy,
            having: having,
            orderBy: orderBy,
            limit: limit,
            offset: offset,
          );
          store.dispatch(
            LoadJobLedgerEntriesSuccessAction(
              jobLedgerEntries,
              queryDistinct: distinct,
              queryWhere: where,
              queryWhereArgs: whereArgs,
              queryGroupBy: groupBy,
              queryHaving: having,
              queryOrderBy: orderBy,
              queryLimit: limit,
              queryOffset: offset,
            ),
          );
        } catch (e) {
          store.dispatch(LoadJobLedgerEntriesFailedAction(
              error: ActionError(message: 'Could\'nt read the database.')));
        }
      }
    };

Future<Iterable<JobLedgerEntryState>> queryJobLedgerEntriesDirect(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async =>
    _queryJobLedgerEntries(
      db,
      distinct: distinct,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

Future<Iterable<JobLedgerEntryState>> _queryJobLedgerEntries(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async {
  // Query the records from the database
  final rows = await db?.query(
        DBJobLedgerEntry.TABLE_NAME,
        distinct: distinct,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      ) ?? Iterable.empty();

  return rows.map((row) => JobLedgerEntryState.decodeDB(Map.of(row)));
}

ThunkAction<AppState> loadJobLedgerEntries({
  int entryNo,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = jobLedgerEntryStateStatusSelector(store.state);
        if (status.isLoading) {
          return;
        }
        if (!loadPosted &&
            0 >
                DateTime.now()
                    .difference(status.lastUpdated)
                    .compareTo(const Duration(seconds: 1))) {
          // Limit loading to once per second
          return;
        }

        // DISPATCH: LOAD - Begin
        store.dispatch(LoadJobLedgerEntriesBeginAction(
          entryNo: entryNo,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          final credentials = user.credentials;
          Response res;

          Iterable<JobLedgerEntryState> jobLedgerEntries = Iterable.empty();
          final values = List<dynamic>();

          var doneFetching = false;
          var i = 0;
          do {
            try {
              if (entryNo != null) {
                res = await NavService.getSingle(
                  credentials,
                  _JOB_LEDGER_ENTRY_SERVICE_ENDPOINT,
                  "Entry_No=$entryNo",
                  etag: etag,
                );
              } else {
                res = await NavService.getMultiple(
                  credentials,
                  _JOB_LEDGER_ENTRY_SERVICE_ENDPOINT,
                  skip: i++ * ODATA_MAX_ENTITIES,
                );
              }
            } catch (e) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadJobLedgerEntriesFailedAction(
                error: ActionError(message: e.toString()),
                entryNo: entryNo,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            if (res == null || res.statusCode != 200) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadJobLedgerEntriesFailedAction(
                error: ActionError.fromHttpResponse(res),
                entryNo: entryNo,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            final currentValues = NavService.valuesAPI(res);
            if (currentValues != null) {
              values.addAll(currentValues);
            }

            doneFetching = currentValues.length < ODATA_MAX_ENTITIES;
          } while (!doneFetching);

          if (values != null) {
            jobLedgerEntries = values.map((value) => JobLedgerEntryState.decodeAPI(value));
          }

          // Save the records to the database
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              if (entryNo == null) {
                // Delete all records
                batch.delete(
                  _JOB_LEDGER_ENTRY_TABLE_NAME,
                  where: '"_InternalState" = ?',
                  whereArgs: [INTERNAL_STATE_NONE],
                );

                // Insert new records
                for (final model in jobLedgerEntries) {
                  final values = model.encodeDB(user.username);
                  batch.insert(_JOB_LEDGER_ENTRY_TABLE_NAME, values);
                }
              } else {
                // Delete->Insert only the fetched records
                for (final model in jobLedgerEntries) {
                  final values = model.encodeDB(user.username);
                  final q = QueryArgs.fromJobLedgerEntry(user.username, model);
                  if (q.isCorrect) {
                    batch.delete(_JOB_LEDGER_ENTRY_TABLE_NAME,
                        where: q.query, whereArgs: q.args);
                    batch.insert(_JOB_LEDGER_ENTRY_TABLE_NAME, values);
                  }
                }
              }

              batch.commit();
            });
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadJobLedgerEntriesFailedAction(
                error: ActionError(
              message: 'An unexpected error occurred in the database.',
            )));
            return;
          }
        }


        // Reload last query.
        status = jobLedgerEntryStateStatusSelector(store.state); // Get the latest status
        final jobLedgerEntries = await _queryJobLedgerEntries(
          context?.db,
          distinct: status.queryDistinct,
          where: status.queryWhere,
          whereArgs: status.queryWhereArgs,
          groupBy: status.queryGroupBy,
          having: status.queryHaving,
          orderBy: status.queryOrderBy,
          limit: status.queryLimit,
          offset: status.queryOffset,
        );

        // DISPATCH: LOAD - Success
        store.dispatch(LoadJobLedgerEntriesSuccessAction(
          jobLedgerEntries,
          entryNo: entryNo,
          etag: etag,
          offline: offline,
          queryDistinct: status.queryDistinct,
          queryWhere: status.queryWhere,
          queryWhereArgs: status.queryWhereArgs,
          queryGroupBy: status.queryGroupBy,
          queryHaving: status.queryHaving,
          queryOrderBy: status.queryOrderBy,
          queryLimit: status.queryLimit,
          queryOffset: status.queryOffset,
        ));
      }
    };

const _JOB_PLANNING_LINE_SERVICE_ENDPOINT = 'E7MR_Job_Planning_Lines';
const _JOB_PLANNING_LINE_TABLE_NAME = 'JobPlanningLine';

class LoadJobPlanningLinesBeginAction {
  LoadJobPlanningLinesBeginAction({
    this.jobNo,
    this.jobTaskNo,
    this.lineNo,
    this.etag,
    this.offline,
  });
  final String jobNo;
  final String jobTaskNo;
  final int lineNo;
  final String etag;
  final bool offline;
}

class LoadJobPlanningLinesSuccessAction {
  LoadJobPlanningLinesSuccessAction(
    this.jobPlanningLines, {
    this.jobNo,
    this.jobTaskNo,
    this.lineNo,
    this.etag,
    this.offline,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
  });
  final Iterable<JobPlanningLineState> jobPlanningLines;
  final String jobNo;
  final String jobTaskNo;
  final int lineNo;
  final String etag;
  final bool offline;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;
}

class LoadJobPlanningLinesFailedAction {
  LoadJobPlanningLinesFailedAction({
    this.error,
    this.jobNo,
    this.jobTaskNo,
    this.lineNo,
    this.etag,
    this.offline,
  });
  final ActionError error;
  final String jobNo;
  final String jobTaskNo;
  final int lineNo;
  final String etag;
  final bool offline;
}

ThunkAction<AppState> queryJobPlanningLines({
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        store.dispatch(LoadJobPlanningLinesBeginAction());
        try {
          final jobPlanningLines = await _queryJobPlanningLines(
            context?.db,
            distinct: distinct,
            where: where,
            whereArgs: whereArgs,
            groupBy: groupBy,
            having: having,
            orderBy: orderBy,
            limit: limit,
            offset: offset,
          );
          store.dispatch(
            LoadJobPlanningLinesSuccessAction(
              jobPlanningLines,
              queryDistinct: distinct,
              queryWhere: where,
              queryWhereArgs: whereArgs,
              queryGroupBy: groupBy,
              queryHaving: having,
              queryOrderBy: orderBy,
              queryLimit: limit,
              queryOffset: offset,
            ),
          );
        } catch (e) {
          store.dispatch(LoadJobPlanningLinesFailedAction(
              error: ActionError(message: 'Could\'nt read the database.')));
        }
      }
    };

Future<Iterable<JobPlanningLineState>> queryJobPlanningLinesDirect(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async =>
    _queryJobPlanningLines(
      db,
      distinct: distinct,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

Future<Iterable<JobPlanningLineState>> _queryJobPlanningLines(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async {
  // Query the records from the database
  final rows = await db?.query(
        DBJobPlanningLine.TABLE_NAME,
        distinct: distinct,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      ) ?? Iterable.empty();

  return rows.map((row) => JobPlanningLineState.decodeDB(Map.of(row)));
}

ThunkAction<AppState> loadJobPlanningLines({
  String jobNo,
  String jobTaskNo,
  int lineNo,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = jobPlanningLineStateStatusSelector(store.state);
        if (status.isLoading) {
          return;
        }
        if (!loadPosted &&
            0 >
                DateTime.now()
                    .difference(status.lastUpdated)
                    .compareTo(const Duration(seconds: 1))) {
          // Limit loading to once per second
          return;
        }

        // DISPATCH: LOAD - Begin
        store.dispatch(LoadJobPlanningLinesBeginAction(
          jobNo: jobNo,
          jobTaskNo: jobTaskNo,
          lineNo: lineNo,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          final credentials = user.credentials;
          Response res;

          Iterable<JobPlanningLineState> jobPlanningLines = Iterable.empty();
          final values = List<dynamic>();

          var doneFetching = false;
          var i = 0;
          do {
            try {
              if (jobNo != null && jobTaskNo != null && lineNo != null) {
                res = await NavService.getSingle(
                  credentials,
                  _JOB_PLANNING_LINE_SERVICE_ENDPOINT,
                  "Job_No='$jobNo',Job_Task_No='$jobTaskNo',Line_No=$lineNo",
                  etag: etag,
                );
              } else {
                res = await NavService.getMultiple(
                  credentials,
                  _JOB_PLANNING_LINE_SERVICE_ENDPOINT,
                  skip: i++ * ODATA_MAX_ENTITIES,
                );
              }
            } catch (e) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadJobPlanningLinesFailedAction(
                error: ActionError(message: e.toString()),
                jobNo: jobNo,
                jobTaskNo: jobTaskNo,
                lineNo: lineNo,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            if (res == null || res.statusCode != 200) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadJobPlanningLinesFailedAction(
                error: ActionError.fromHttpResponse(res),
                jobNo: jobNo,
                jobTaskNo: jobTaskNo,
                lineNo: lineNo,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            final currentValues = NavService.valuesAPI(res);
            if (currentValues != null) {
              values.addAll(currentValues);
            }

            doneFetching = currentValues.length < ODATA_MAX_ENTITIES;
          } while (!doneFetching);

          if (values != null) {
            jobPlanningLines = values.map((value) => JobPlanningLineState.decodeAPI(value));
          }

          // Save the records to the database
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              if (jobNo == null && jobTaskNo == null && lineNo == null) {
                // Delete all records
                batch.delete(
                  _JOB_PLANNING_LINE_TABLE_NAME,
                  where: '"_InternalState" = ?',
                  whereArgs: [INTERNAL_STATE_NONE],
                );

                // Insert new records
                for (final model in jobPlanningLines) {
                  final values = model.encodeDB(user.username);
                  batch.insert(_JOB_PLANNING_LINE_TABLE_NAME, values);
                }
              } else {
                // Delete->Insert only the fetched records
                for (final model in jobPlanningLines) {
                  final values = model.encodeDB(user.username);
                  final q = QueryArgs.fromJobPlanningLine(user.username, model);
                  if (q.isCorrect) {
                    batch.delete(_JOB_PLANNING_LINE_TABLE_NAME,
                        where: q.query, whereArgs: q.args);
                    batch.insert(_JOB_PLANNING_LINE_TABLE_NAME, values);
                  }
                }
              }

              batch.commit();
            });
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadJobPlanningLinesFailedAction(
                error: ActionError(
              message: 'An unexpected error occurred in the database.',
            )));
            return;
          }
        }


        // Reload last query.
        status = jobPlanningLineStateStatusSelector(store.state); // Get the latest status
        final jobPlanningLines = await _queryJobPlanningLines(
          context?.db,
          distinct: status.queryDistinct,
          where: status.queryWhere,
          whereArgs: status.queryWhereArgs,
          groupBy: status.queryGroupBy,
          having: status.queryHaving,
          orderBy: status.queryOrderBy,
          limit: status.queryLimit,
          offset: status.queryOffset,
        );

        // DISPATCH: LOAD - Success
        store.dispatch(LoadJobPlanningLinesSuccessAction(
          jobPlanningLines,
          jobNo: jobNo,
          jobTaskNo: jobTaskNo,
          lineNo: lineNo,
          etag: etag,
          offline: offline,
          queryDistinct: status.queryDistinct,
          queryWhere: status.queryWhere,
          queryWhereArgs: status.queryWhereArgs,
          queryGroupBy: status.queryGroupBy,
          queryHaving: status.queryHaving,
          queryOrderBy: status.queryOrderBy,
          queryLimit: status.queryLimit,
          queryOffset: status.queryOffset,
        ));
      }
    };

const _JOB_TASK_SERVICE_ENDPOINT = 'E7MR_Job_Tasks';
const _JOB_TASK_TABLE_NAME = 'JobTask';

class LoadJobTasksBeginAction {
  LoadJobTasksBeginAction({
    this.jobNo,
    this.jobTaskNo,
    this.etag,
    this.offline,
  });
  final String jobNo;
  final String jobTaskNo;
  final String etag;
  final bool offline;
}

class LoadJobTasksSuccessAction {
  LoadJobTasksSuccessAction(
    this.jobTasks, {
    this.jobNo,
    this.jobTaskNo,
    this.etag,
    this.offline,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
  });
  final Iterable<JobTaskState> jobTasks;
  final String jobNo;
  final String jobTaskNo;
  final String etag;
  final bool offline;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;
}

class LoadJobTasksFailedAction {
  LoadJobTasksFailedAction({
    this.error,
    this.jobNo,
    this.jobTaskNo,
    this.etag,
    this.offline,
  });
  final ActionError error;
  final String jobNo;
  final String jobTaskNo;
  final String etag;
  final bool offline;
}

ThunkAction<AppState> queryJobTasks({
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        store.dispatch(LoadJobTasksBeginAction());
        try {
          final jobTasks = await _queryJobTasks(
            context?.db,
            distinct: distinct,
            where: where,
            whereArgs: whereArgs,
            groupBy: groupBy,
            having: having,
            orderBy: orderBy,
            limit: limit,
            offset: offset,
          );
          store.dispatch(
            LoadJobTasksSuccessAction(
              jobTasks,
              queryDistinct: distinct,
              queryWhere: where,
              queryWhereArgs: whereArgs,
              queryGroupBy: groupBy,
              queryHaving: having,
              queryOrderBy: orderBy,
              queryLimit: limit,
              queryOffset: offset,
            ),
          );
        } catch (e) {
          store.dispatch(LoadJobTasksFailedAction(
              error: ActionError(message: 'Could\'nt read the database.')));
        }
      }
    };

Future<Iterable<JobTaskState>> queryJobTasksDirect(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async =>
    _queryJobTasks(
      db,
      distinct: distinct,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

Future<Iterable<JobTaskState>> _queryJobTasks(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async {
  // Query the records from the database
  final rows = await db?.query(
        DBJobTask.TABLE_NAME,
        distinct: distinct,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      ) ?? Iterable.empty();

  return rows.map((row) => JobTaskState.decodeDB(Map.of(row)));
}

ThunkAction<AppState> loadJobTasks({
  String jobNo,
  String jobTaskNo,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = jobTaskStateStatusSelector(store.state);
        if (status.isLoading) {
          return;
        }
        if (!loadPosted &&
            0 >
                DateTime.now()
                    .difference(status.lastUpdated)
                    .compareTo(const Duration(seconds: 1))) {
          // Limit loading to once per second
          return;
        }

        // DISPATCH: LOAD - Begin
        store.dispatch(LoadJobTasksBeginAction(
          jobNo: jobNo,
          jobTaskNo: jobTaskNo,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          final credentials = user.credentials;
          Response res;

          Iterable<JobTaskState> jobTasks = Iterable.empty();
          final values = List<dynamic>();

          var doneFetching = false;
          var i = 0;
          do {
            try {
              if (jobNo != null && jobTaskNo != null) {
                res = await NavService.getSingle(
                  credentials,
                  _JOB_TASK_SERVICE_ENDPOINT,
                  "Job_No='$jobNo',Job_Task_No='$jobTaskNo'",
                  etag: etag,
                );
              } else {
                res = await NavService.getMultiple(
                  credentials,
                  _JOB_TASK_SERVICE_ENDPOINT,
                  skip: i++ * ODATA_MAX_ENTITIES,
                );
              }
            } catch (e) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadJobTasksFailedAction(
                error: ActionError(message: e.toString()),
                jobNo: jobNo,
                jobTaskNo: jobTaskNo,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            if (res == null || res.statusCode != 200) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadJobTasksFailedAction(
                error: ActionError.fromHttpResponse(res),
                jobNo: jobNo,
                jobTaskNo: jobTaskNo,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            final currentValues = NavService.valuesAPI(res);
            if (currentValues != null) {
              values.addAll(currentValues);
            }

            doneFetching = currentValues.length < ODATA_MAX_ENTITIES;
          } while (!doneFetching);

          if (values != null) {
            jobTasks = values.map((value) => JobTaskState.decodeAPI(value));
          }

          // Save the records to the database
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              if (jobNo == null && jobTaskNo == null) {
                // Delete all records
                batch.delete(
                  _JOB_TASK_TABLE_NAME,
                  where: '"_InternalState" = ?',
                  whereArgs: [INTERNAL_STATE_NONE],
                );

                // Insert new records
                for (final model in jobTasks) {
                  final values = model.encodeDB(user.username);
                  batch.insert(_JOB_TASK_TABLE_NAME, values);
                }
              } else {
                // Delete->Insert only the fetched records
                for (final model in jobTasks) {
                  final values = model.encodeDB(user.username);
                  final q = QueryArgs.fromJobTask(user.username, model);
                  if (q.isCorrect) {
                    batch.delete(_JOB_TASK_TABLE_NAME,
                        where: q.query, whereArgs: q.args);
                    batch.insert(_JOB_TASK_TABLE_NAME, values);
                  }
                }
              }

              batch.commit();
            });
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadJobTasksFailedAction(
                error: ActionError(
              message: 'An unexpected error occurred in the database.',
            )));
            return;
          }
        }


        // Reload last query.
        status = jobTaskStateStatusSelector(store.state); // Get the latest status
        final jobTasks = await _queryJobTasks(
          context?.db,
          distinct: status.queryDistinct,
          where: status.queryWhere,
          whereArgs: status.queryWhereArgs,
          groupBy: status.queryGroupBy,
          having: status.queryHaving,
          orderBy: status.queryOrderBy,
          limit: status.queryLimit,
          offset: status.queryOffset,
        );

        // DISPATCH: LOAD - Success
        store.dispatch(LoadJobTasksSuccessAction(
          jobTasks,
          jobNo: jobNo,
          jobTaskNo: jobTaskNo,
          etag: etag,
          offline: offline,
          queryDistinct: status.queryDistinct,
          queryWhere: status.queryWhere,
          queryWhereArgs: status.queryWhereArgs,
          queryGroupBy: status.queryGroupBy,
          queryHaving: status.queryHaving,
          queryOrderBy: status.queryOrderBy,
          queryLimit: status.queryLimit,
          queryOffset: status.queryOffset,
        ));
      }
    };

const _JOB_SERVICE_ENDPOINT = 'E7MR_Jobs';
const _JOB_TABLE_NAME = 'Job';

class LoadJobsBeginAction {
  LoadJobsBeginAction({
    this.no,
    this.etag,
    this.offline,
  });
  final String no;
  final String etag;
  final bool offline;
}

class LoadJobsSuccessAction {
  LoadJobsSuccessAction(
    this.jobs, {
    this.no,
    this.etag,
    this.offline,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
  });
  final Iterable<JobState> jobs;
  final String no;
  final String etag;
  final bool offline;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;
}

class LoadJobsFailedAction {
  LoadJobsFailedAction({
    this.error,
    this.no,
    this.etag,
    this.offline,
  });
  final ActionError error;
  final String no;
  final String etag;
  final bool offline;
}

ThunkAction<AppState> loadJobs({
  String no,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = jobStateStatusSelector(store.state);
        if (status.isLoading) {
          return;
        }
        if (!loadPosted &&
            0 >
                DateTime.now()
                    .difference(status.lastUpdated)
                    .compareTo(const Duration(seconds: 1))) {
          // Limit loading to once per second
          return;
        }

        // DISPATCH: LOAD - Begin
        store.dispatch(LoadJobsBeginAction(
          no: no,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          final credentials = user.credentials;
          Response res;

          Iterable<JobState> jobs = Iterable.empty();
          final values = List<dynamic>();

          var doneFetching = false;
          var i = 0;
          do {
            try {
              if (no != null) {
                res = await NavService.getSingle(
                  credentials,
                  _JOB_SERVICE_ENDPOINT,
                  "No='$no'",
                  etag: etag,
                );
              } else {
                res = await NavService.getMultiple(
                  credentials,
                  _JOB_SERVICE_ENDPOINT,
                  skip: i++ * ODATA_MAX_ENTITIES,
                );
              }
            } catch (e) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadJobsFailedAction(
                error: ActionError(message: e.toString()),
                no: no,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            if (res == null || res.statusCode != 200) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadJobsFailedAction(
                error: ActionError.fromHttpResponse(res),
                no: no,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            final currentValues = NavService.valuesAPI(res);
            if (currentValues != null) {
              values.addAll(currentValues);
            }

            doneFetching = currentValues.length < ODATA_MAX_ENTITIES;
          } while (!doneFetching);

          if (values != null) {
            jobs = values.map((value) => JobState.decodeAPI(value));
          }

          // Save the records to the database
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              if (no == null) {
                // Delete all records
                batch.delete(
                  _JOB_TABLE_NAME,
                  where: '"_InternalState" = ?',
                  whereArgs: [INTERNAL_STATE_NONE],
                );

                // Insert new records
                for (final model in jobs) {
                  final values = model.encodeDB(user.username);
                  batch.insert(_JOB_TABLE_NAME, values);
                }
              } else {
                // Delete->Insert only the fetched records
                for (final model in jobs) {
                  final values = model.encodeDB(user.username);
                  final q = QueryArgs.fromJob(user.username, model);
                  if (q.isCorrect) {
                    batch.delete(_JOB_TABLE_NAME,
                        where: q.query, whereArgs: q.args);
                    batch.insert(_JOB_TABLE_NAME, values);
                  }
                }
              }

              batch.commit();
            });
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadJobsFailedAction(
                error: ActionError(
              message: 'An unexpected error occurred in the database.',
            )));
            return;
          }
        }

        // Query the records from the database
        final jobs = await DBJob.query(
          context.db,
          user.username,
          no: no,
        );

        // DISPATCH: LOAD - Success
        store.dispatch(LoadJobsSuccessAction(
          jobs,
          no: no,
          etag: etag,
          offline: offline,
        ));
      }
    };

const _LOCATION_SERVICE_ENDPOINT = 'E7MR_Locations';
const _LOCATION_TABLE_NAME = 'Location';

class LoadLocationsBeginAction {
  LoadLocationsBeginAction({
    this.code,
    this.etag,
    this.offline,
  });
  final String code;
  final String etag;
  final bool offline;
}

class LoadLocationsSuccessAction {
  LoadLocationsSuccessAction(
    this.locations, {
    this.code,
    this.etag,
    this.offline,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
  });
  final Iterable<LocationState> locations;
  final String code;
  final String etag;
  final bool offline;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;
}

class LoadLocationsFailedAction {
  LoadLocationsFailedAction({
    this.error,
    this.code,
    this.etag,
    this.offline,
  });
  final ActionError error;
  final String code;
  final String etag;
  final bool offline;
}

ThunkAction<AppState> loadLocations({
  String code,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = locationStateStatusSelector(store.state);
        if (status.isLoading) {
          return;
        }
        if (!loadPosted &&
            0 >
                DateTime.now()
                    .difference(status.lastUpdated)
                    .compareTo(const Duration(seconds: 1))) {
          // Limit loading to once per second
          return;
        }

        // DISPATCH: LOAD - Begin
        store.dispatch(LoadLocationsBeginAction(
          code: code,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          final credentials = user.credentials;
          Response res;

          Iterable<LocationState> locations = Iterable.empty();
          final values = List<dynamic>();

          var doneFetching = false;
          var i = 0;
          do {
            try {
              if (code != null) {
                res = await NavService.getSingle(
                  credentials,
                  _LOCATION_SERVICE_ENDPOINT,
                  "Code='$code'",
                  etag: etag,
                );
              } else {
                res = await NavService.getMultiple(
                  credentials,
                  _LOCATION_SERVICE_ENDPOINT,
                  skip: i++ * ODATA_MAX_ENTITIES,
                );
              }
            } catch (e) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadLocationsFailedAction(
                error: ActionError(message: e.toString()),
                code: code,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            if (res == null || res.statusCode != 200) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadLocationsFailedAction(
                error: ActionError.fromHttpResponse(res),
                code: code,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            final currentValues = NavService.valuesAPI(res);
            if (currentValues != null) {
              values.addAll(currentValues);
            }

            doneFetching = currentValues.length < ODATA_MAX_ENTITIES;
          } while (!doneFetching);

          if (values != null) {
            locations = values.map((value) => LocationState.decodeAPI(value));
          }

          // Save the records to the database
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              if (code == null) {
                // Delete all records
                batch.delete(
                  _LOCATION_TABLE_NAME,
                  where: '"_InternalState" = ?',
                  whereArgs: [INTERNAL_STATE_NONE],
                );

                // Insert new records
                for (final model in locations) {
                  final values = model.encodeDB(user.username);
                  batch.insert(_LOCATION_TABLE_NAME, values);
                }
              } else {
                // Delete->Insert only the fetched records
                for (final model in locations) {
                  final values = model.encodeDB(user.username);
                  final q = QueryArgs.fromLocation(user.username, model);
                  if (q.isCorrect) {
                    batch.delete(_LOCATION_TABLE_NAME,
                        where: q.query, whereArgs: q.args);
                    batch.insert(_LOCATION_TABLE_NAME, values);
                  }
                }
              }

              batch.commit();
            });
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadLocationsFailedAction(
                error: ActionError(
              message: 'An unexpected error occurred in the database.',
            )));
            return;
          }
        }

        // Query the records from the database
        final locations = await DBLocation.query(
          context.db,
          user.username,
          code: code,
        );

        // DISPATCH: LOAD - Success
        store.dispatch(LoadLocationsSuccessAction(
          locations,
          code: code,
          etag: etag,
          offline: offline,
        ));
      }
    };

const _LOG_SERVICE_ENDPOINT = 'E7MR_Log';
const _LOG_TABLE_NAME = 'Log';

class LoadLogsBeginAction {
  LoadLogsBeginAction({
    this.entryNo,
    this.etag,
    this.offline,
  });
  final int entryNo;
  final String etag;
  final bool offline;
}

class LoadLogsSuccessAction {
  LoadLogsSuccessAction(
    this.logs, {
    this.entryNo,
    this.etag,
    this.offline,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
  });
  final Iterable<LogState> logs;
  final int entryNo;
  final String etag;
  final bool offline;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;
}

class LoadLogsFailedAction {
  LoadLogsFailedAction({
    this.error,
    this.entryNo,
    this.etag,
    this.offline,
  });
  final ActionError error;
  final int entryNo;
  final String etag;
  final bool offline;
}

ThunkAction<AppState> queryLogs({
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        store.dispatch(LoadLogsBeginAction());
        try {
          final logs = await _queryLogs(
            context?.db,
            distinct: distinct,
            where: where,
            whereArgs: whereArgs,
            groupBy: groupBy,
            having: having,
            orderBy: orderBy,
            limit: limit,
            offset: offset,
          );
          store.dispatch(
            LoadLogsSuccessAction(
              logs,
              queryDistinct: distinct,
              queryWhere: where,
              queryWhereArgs: whereArgs,
              queryGroupBy: groupBy,
              queryHaving: having,
              queryOrderBy: orderBy,
              queryLimit: limit,
              queryOffset: offset,
            ),
          );
        } catch (e) {
          store.dispatch(LoadLogsFailedAction(
              error: ActionError(message: 'Could\'nt read the database.')));
        }
      }
    };

Future<Iterable<LogState>> queryLogsDirect(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async =>
    _queryLogs(
      db,
      distinct: distinct,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

Future<Iterable<LogState>> _queryLogs(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async {
  // Query the records from the database
  final rows = await db?.query(
        DBLog.TABLE_NAME,
        distinct: distinct,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      ) ?? Iterable.empty();

  return rows.map((row) => LogState.decodeDB(Map.of(row)));
}

ThunkAction<AppState> loadLogs({
  int entryNo,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = logStateStatusSelector(store.state);
        if (status.isLoading) {
          return;
        }
        if (!loadPosted &&
            0 >
                DateTime.now()
                    .difference(status.lastUpdated)
                    .compareTo(const Duration(seconds: 1))) {
          // Limit loading to once per second
          return;
        }

        // DISPATCH: LOAD - Begin
        store.dispatch(LoadLogsBeginAction(
          entryNo: entryNo,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          final credentials = user.credentials;
          Response res;

          Iterable<LogState> logs = Iterable.empty();
          final values = List<dynamic>();

          var doneFetching = false;
          var i = 0;
          do {
            try {
              if (entryNo != null) {
                res = await NavService.getSingle(
                  credentials,
                  _LOG_SERVICE_ENDPOINT,
                  "Entry_No=$entryNo",
                  etag: etag,
                );
              } else {
                res = await NavService.getMultiple(
                  credentials,
                  _LOG_SERVICE_ENDPOINT,
                  skip: i++ * ODATA_MAX_ENTITIES,
                );
              }
            } catch (e) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadLogsFailedAction(
                error: ActionError(message: e.toString()),
                entryNo: entryNo,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            if (res == null || res.statusCode != 200) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadLogsFailedAction(
                error: ActionError.fromHttpResponse(res),
                entryNo: entryNo,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            final currentValues = NavService.valuesAPI(res);
            if (currentValues != null) {
              values.addAll(currentValues);
            }

            doneFetching = currentValues.length < ODATA_MAX_ENTITIES;
          } while (!doneFetching);

          if (values != null) {
            logs = values.map((value) => LogState.decodeAPI(value));
          }

          // Save the records to the database
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              if (entryNo == null) {
                // Delete all records
                batch.delete(
                  _LOG_TABLE_NAME,
                  where: '"_InternalState" = ?',
                  whereArgs: [INTERNAL_STATE_NONE],
                );

                // Insert new records
                for (final model in logs) {
                  final values = model.encodeDB(user.username);
                  batch.insert(_LOG_TABLE_NAME, values);
                }
              } else {
                // Delete->Insert only the fetched records
                for (final model in logs) {
                  final values = model.encodeDB(user.username);
                  final q = QueryArgs.fromLog(user.username, model);
                  if (q.isCorrect) {
                    batch.delete(_LOG_TABLE_NAME,
                        where: q.query, whereArgs: q.args);
                    batch.insert(_LOG_TABLE_NAME, values);
                  }
                }
              }

              batch.commit();
            });
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadLogsFailedAction(
                error: ActionError(
              message: 'An unexpected error occurred in the database.',
            )));
            return;
          }
        }


        // Reload last query.
        status = logStateStatusSelector(store.state); // Get the latest status
        final logs = await _queryLogs(
          context?.db,
          distinct: status.queryDistinct,
          where: status.queryWhere,
          whereArgs: status.queryWhereArgs,
          groupBy: status.queryGroupBy,
          having: status.queryHaving,
          orderBy: status.queryOrderBy,
          limit: status.queryLimit,
          offset: status.queryOffset,
        );

        // DISPATCH: LOAD - Success
        store.dispatch(LoadLogsSuccessAction(
          logs,
          entryNo: entryNo,
          etag: etag,
          offline: offline,
          queryDistinct: status.queryDistinct,
          queryWhere: status.queryWhere,
          queryWhereArgs: status.queryWhereArgs,
          queryGroupBy: status.queryGroupBy,
          queryHaving: status.queryHaving,
          queryOrderBy: status.queryOrderBy,
          queryLimit: status.queryLimit,
          queryOffset: status.queryOffset,
        ));
      }
    };

class PostLogsBeginAction {}

class PostLogsSuccessAction {}

class PostLogsFailedAction {
  PostLogsFailedAction({this.error});
  final ActionError error;
}

ThunkAction<AppState> postLog(
  LogState log, {
  bool syncImmediately = true,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        log = await DBLog.insert(
          context.db,
          user.username,
          log,
          internalState: INTERNAL_STATE_POST,
        );

        if (log.uuid != null && log.uuid.isNotEmpty) {
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              batch.delete(
                'LogExtraContent',
                where: 'User = ? AND UUID = ?',
                whereArgs: [
                  user.username,
                  log.uuid,
                ],
              );
              batch.insert('LogExtraContent', {
                'User': user.username,
                'UUID': log.uuid,
                'ExtraContentBLOB': log.extraContent,
              });

              batch.commit();
            });
          } catch (e) {}
        }

        if (syncImmediately) {
          store.dispatch(postLogs());
        }
      }
    };

ThunkAction<AppState> postLogs() =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        final credentials = user.credentials;

        // DISPATCH: LOAD - Begin
        store.dispatch(PostLogsBeginAction());

        // Query records to post from database
        final logs = await DBLog.query(
          context.db,
          user.username,
          internalState: INTERNAL_STATE_POST,
        );

        final success = List<LogState>();
        final failed = List<LogState>();

        final offline = offlineSelector(store.state);
        if (offline) {
          store.dispatch(PostLogsFailedAction(
            error: ActionError(code: -1, message: "Offline")));
          return;
        }

        await PostLog.postLogs(
          logs,
          credentials,
          success,
          failed,
        );

        // Update the posted records' internal state from POST to NONE
        try {
          await context.db.transaction((txn) async {
            final batch = txn.batch();

            for (var model in success) {
              final q = QueryArgs.fromLog(user.username, model);
              if (q.isCorrect) {
                model = model.copyWith(internalState: INTERNAL_STATE_NONE);
                final values = model.encodeDB(user.username);
                batch.update(
                  _LOG_TABLE_NAME,
                  values,
                  where: q.query,
                  whereArgs: q.args,
                );
              }
            }

            batch.commit();
          });
        } catch (e) {
          store.dispatch(PostLogsFailedAction(
              error: ActionError(
            message: 'An unexpected error occurred in the database.',
          )));
          return;
        }

        // DISPATCH: POST - Success
        store.dispatch(PostLogsSuccessAction());

        // Reload last query.
        final status = logStateStatusSelector(store.state); // Get the latest status
        store.dispatch(queryLogs(
          distinct: status.queryDistinct,
          where: status.queryWhere,
          whereArgs: status.queryWhereArgs,
          groupBy: status.queryGroupBy,
          having: status.queryHaving,
          orderBy: status.queryOrderBy,
          limit: status.queryLimit,
          offset: status.queryOffset,
        ));
      }
    };

const _REJECTED_HOUR_SERVICE_ENDPOINT = 'E7MR_Rejected_Hour';
const _REJECTED_HOUR_TABLE_NAME = 'RejectedHour';

class LoadRejectedHoursBeginAction {
  LoadRejectedHoursBeginAction({
    this.entryNo,
    this.etag,
    this.offline,
  });
  final int entryNo;
  final String etag;
  final bool offline;
}

class LoadRejectedHoursSuccessAction {
  LoadRejectedHoursSuccessAction(
    this.rejectedHours, {
    this.entryNo,
    this.etag,
    this.offline,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
  });
  final Iterable<RejectedHourState> rejectedHours;
  final int entryNo;
  final String etag;
  final bool offline;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;
}

class LoadRejectedHoursFailedAction {
  LoadRejectedHoursFailedAction({
    this.error,
    this.entryNo,
    this.etag,
    this.offline,
  });
  final ActionError error;
  final int entryNo;
  final String etag;
  final bool offline;
}

ThunkAction<AppState> queryRejectedHours({
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        store.dispatch(LoadRejectedHoursBeginAction());
        try {
          final rejectedHours = await _queryRejectedHours(
            context?.db,
            distinct: distinct,
            where: where,
            whereArgs: whereArgs,
            groupBy: groupBy,
            having: having,
            orderBy: orderBy,
            limit: limit,
            offset: offset,
          );
          store.dispatch(
            LoadRejectedHoursSuccessAction(
              rejectedHours,
              queryDistinct: distinct,
              queryWhere: where,
              queryWhereArgs: whereArgs,
              queryGroupBy: groupBy,
              queryHaving: having,
              queryOrderBy: orderBy,
              queryLimit: limit,
              queryOffset: offset,
            ),
          );
        } catch (e) {
          store.dispatch(LoadRejectedHoursFailedAction(
              error: ActionError(message: 'Could\'nt read the database.')));
        }
      }
    };

Future<Iterable<RejectedHourState>> queryRejectedHoursDirect(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async =>
    _queryRejectedHours(
      db,
      distinct: distinct,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

Future<Iterable<RejectedHourState>> _queryRejectedHours(
  Database db, {
  bool distinct,
  String where,
  List whereArgs,
  String groupBy,
  String having,
  String orderBy,
  int limit,
  int offset,
}) async {
  // Query the records from the database
  final rows = await db?.query(
        DBRejectedHour.TABLE_NAME,
        distinct: distinct,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      ) ?? Iterable.empty();

  return rows.map((row) => RejectedHourState.decodeDB(Map.of(row)));
}

ThunkAction<AppState> loadRejectedHours({
  int entryNo,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = rejectedHourStateStatusSelector(store.state);
        if (status.isLoading) {
          return;
        }
        if (!loadPosted &&
            0 >
                DateTime.now()
                    .difference(status.lastUpdated)
                    .compareTo(const Duration(seconds: 1))) {
          // Limit loading to once per second
          return;
        }

        // DISPATCH: LOAD - Begin
        store.dispatch(LoadRejectedHoursBeginAction(
          entryNo: entryNo,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          final credentials = user.credentials;
          Response res;

          Iterable<RejectedHourState> rejectedHours = Iterable.empty();
          final values = List<dynamic>();

          var doneFetching = false;
          var i = 0;
          do {
            try {
              if (entryNo != null) {
                res = await NavService.getSingle(
                  credentials,
                  _REJECTED_HOUR_SERVICE_ENDPOINT,
                  "Entry_No=$entryNo",
                  etag: etag,
                );
              } else {
                res = await NavService.getMultiple(
                  credentials,
                  _REJECTED_HOUR_SERVICE_ENDPOINT,
                  skip: i++ * ODATA_MAX_ENTITIES,
                );
              }
            } catch (e) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadRejectedHoursFailedAction(
                error: ActionError(message: e.toString()),
                entryNo: entryNo,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            if (res == null || res.statusCode != 200) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadRejectedHoursFailedAction(
                error: ActionError.fromHttpResponse(res),
                entryNo: entryNo,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            final currentValues = NavService.valuesAPI(res);
            if (currentValues != null) {
              values.addAll(currentValues);
            }

            doneFetching = currentValues.length < ODATA_MAX_ENTITIES;
          } while (!doneFetching);

          if (values != null) {
            rejectedHours = values.map((value) => RejectedHourState.decodeAPI(value));
          }

          // Save the records to the database
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              if (entryNo == null) {
                // Delete all records
                batch.delete(
                  _REJECTED_HOUR_TABLE_NAME,
                  where: '"_InternalState" = ?',
                  whereArgs: [INTERNAL_STATE_NONE],
                );

                // Insert new records
                for (final model in rejectedHours) {
                  final values = model.encodeDB(user.username);
                  batch.insert(_REJECTED_HOUR_TABLE_NAME, values);
                }
              } else {
                // Delete->Insert only the fetched records
                for (final model in rejectedHours) {
                  final values = model.encodeDB(user.username);
                  final q = QueryArgs.fromRejectedHour(user.username, model);
                  if (q.isCorrect) {
                    batch.delete(_REJECTED_HOUR_TABLE_NAME,
                        where: q.query, whereArgs: q.args);
                    batch.insert(_REJECTED_HOUR_TABLE_NAME, values);
                  }
                }
              }

              batch.commit();
            });
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadRejectedHoursFailedAction(
                error: ActionError(
              message: 'An unexpected error occurred in the database.',
            )));
            return;
          }
        }


        // Reload last query.
        status = rejectedHourStateStatusSelector(store.state); // Get the latest status
        final rejectedHours = await _queryRejectedHours(
          context?.db,
          distinct: status.queryDistinct,
          where: status.queryWhere,
          whereArgs: status.queryWhereArgs,
          groupBy: status.queryGroupBy,
          having: status.queryHaving,
          orderBy: status.queryOrderBy,
          limit: status.queryLimit,
          offset: status.queryOffset,
        );

        // DISPATCH: LOAD - Success
        store.dispatch(LoadRejectedHoursSuccessAction(
          rejectedHours,
          entryNo: entryNo,
          etag: etag,
          offline: offline,
          queryDistinct: status.queryDistinct,
          queryWhere: status.queryWhere,
          queryWhereArgs: status.queryWhereArgs,
          queryGroupBy: status.queryGroupBy,
          queryHaving: status.queryHaving,
          queryOrderBy: status.queryOrderBy,
          queryLimit: status.queryLimit,
          queryOffset: status.queryOffset,
        ));
      }
    };

const _SETUP_SERVICE_ENDPOINT = 'E7MR_Setup';
const _SETUP_TABLE_NAME = 'Setup';

class LoadSetupsBeginAction {
  LoadSetupsBeginAction({
    this.primaryKey,
    this.etag,
    this.offline,
  });
  final int primaryKey;
  final String etag;
  final bool offline;
}

class LoadSetupsSuccessAction {
  LoadSetupsSuccessAction(
    this.setups, {
    this.primaryKey,
    this.etag,
    this.offline,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
  });
  final Iterable<SetupState> setups;
  final int primaryKey;
  final String etag;
  final bool offline;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;
}

class LoadSetupsFailedAction {
  LoadSetupsFailedAction({
    this.error,
    this.primaryKey,
    this.etag,
    this.offline,
  });
  final ActionError error;
  final int primaryKey;
  final String etag;
  final bool offline;
}

ThunkAction<AppState> loadSetups({
  int primaryKey,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = setupStateStatusSelector(store.state);
        if (status.isLoading) {
          return;
        }
        if (!loadPosted &&
            0 >
                DateTime.now()
                    .difference(status.lastUpdated)
                    .compareTo(const Duration(seconds: 1))) {
          // Limit loading to once per second
          return;
        }

        // DISPATCH: LOAD - Begin
        store.dispatch(LoadSetupsBeginAction(
          primaryKey: primaryKey,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          final credentials = user.credentials;
          Response res;

          Iterable<SetupState> setups = Iterable.empty();
          final values = List<dynamic>();

          var doneFetching = false;
          var i = 0;
          do {
            try {
              if (primaryKey != null) {
                res = await NavService.getSingle(
                  credentials,
                  _SETUP_SERVICE_ENDPOINT,
                  "Primary_Key=$primaryKey",
                  etag: etag,
                );
              } else {
                res = await NavService.getMultiple(
                  credentials,
                  _SETUP_SERVICE_ENDPOINT,
                  skip: i++ * ODATA_MAX_ENTITIES,
                );
              }
            } catch (e) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadSetupsFailedAction(
                error: ActionError(message: e.toString()),
                primaryKey: primaryKey,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            if (res == null || res.statusCode != 200) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadSetupsFailedAction(
                error: ActionError.fromHttpResponse(res),
                primaryKey: primaryKey,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            final currentValues = NavService.valuesAPI(res);
            if (currentValues != null) {
              values.addAll(currentValues);
            }

            doneFetching = currentValues.length < ODATA_MAX_ENTITIES;
          } while (!doneFetching);

          if (values != null) {
            setups = values.map((value) => SetupState.decodeAPI(value));
          }

          // Save the records to the database
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              if (primaryKey == null) {
                // Delete all records
                batch.delete(
                  _SETUP_TABLE_NAME,
                  where: '"_InternalState" = ?',
                  whereArgs: [INTERNAL_STATE_NONE],
                );

                // Insert new records
                for (final model in setups) {
                  final values = model.encodeDB(user.username);
                  batch.insert(_SETUP_TABLE_NAME, values);
                }
              } else {
                // Delete->Insert only the fetched records
                for (final model in setups) {
                  final values = model.encodeDB(user.username);
                  final q = QueryArgs.fromSetup(user.username, model);
                  if (q.isCorrect) {
                    batch.delete(_SETUP_TABLE_NAME,
                        where: q.query, whereArgs: q.args);
                    batch.insert(_SETUP_TABLE_NAME, values);
                  }
                }
              }

              batch.commit();
            });
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadSetupsFailedAction(
                error: ActionError(
              message: 'An unexpected error occurred in the database.',
            )));
            return;
          }
        }

        // Query the records from the database
        final setups = await DBSetup.query(
          context.db,
          user.username,
          primaryKey: primaryKey,
        );

        // DISPATCH: LOAD - Success
        store.dispatch(LoadSetupsSuccessAction(
          setups,
          primaryKey: primaryKey,
          etag: etag,
          offline: offline,
        ));
      }
    };

const _USER_LOCATION_SERVICE_ENDPOINT = 'E7MR_User_Locations';
const _USER_LOCATION_TABLE_NAME = 'UserLocation';

class LoadUserLocationsBeginAction {
  LoadUserLocationsBeginAction({
    this.userID,
    this.locationCode,
    this.etag,
    this.offline,
  });
  final String userID;
  final String locationCode;
  final String etag;
  final bool offline;
}

class LoadUserLocationsSuccessAction {
  LoadUserLocationsSuccessAction(
    this.userLocations, {
    this.userID,
    this.locationCode,
    this.etag,
    this.offline,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
  });
  final Iterable<UserLocationState> userLocations;
  final String userID;
  final String locationCode;
  final String etag;
  final bool offline;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;
}

class LoadUserLocationsFailedAction {
  LoadUserLocationsFailedAction({
    this.error,
    this.userID,
    this.locationCode,
    this.etag,
    this.offline,
  });
  final ActionError error;
  final String userID;
  final String locationCode;
  final String etag;
  final bool offline;
}

ThunkAction<AppState> loadUserLocations({
  String userID,
  String locationCode,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = userLocationStateStatusSelector(store.state);
        if (status.isLoading) {
          return;
        }
        if (!loadPosted &&
            0 >
                DateTime.now()
                    .difference(status.lastUpdated)
                    .compareTo(const Duration(seconds: 1))) {
          // Limit loading to once per second
          return;
        }

        // DISPATCH: LOAD - Begin
        store.dispatch(LoadUserLocationsBeginAction(
          userID: userID,
          locationCode: locationCode,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          final credentials = user.credentials;
          Response res;

          Iterable<UserLocationState> userLocations = Iterable.empty();
          final values = List<dynamic>();

          var doneFetching = false;
          var i = 0;
          do {
            try {
              if (userID != null && locationCode != null) {
                res = await NavService.getSingle(
                  credentials,
                  _USER_LOCATION_SERVICE_ENDPOINT,
                  "User_ID='$userID',Location_Code='$locationCode'",
                  etag: etag,
                );
              } else {
                res = await NavService.getMultiple(
                  credentials,
                  _USER_LOCATION_SERVICE_ENDPOINT,
                  skip: i++ * ODATA_MAX_ENTITIES,
                );
              }
            } catch (e) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadUserLocationsFailedAction(
                error: ActionError(message: e.toString()),
                userID: userID,
                locationCode: locationCode,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            if (res == null || res.statusCode != 200) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadUserLocationsFailedAction(
                error: ActionError.fromHttpResponse(res),
                userID: userID,
                locationCode: locationCode,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            final currentValues = NavService.valuesAPI(res);
            if (currentValues != null) {
              values.addAll(currentValues);
            }

            doneFetching = currentValues.length < ODATA_MAX_ENTITIES;
          } while (!doneFetching);

          if (values != null) {
            userLocations = values.map((value) => UserLocationState.decodeAPI(value));
          }

          // Save the records to the database
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              if (userID == null && locationCode == null) {
                // Delete all records
                batch.delete(
                  _USER_LOCATION_TABLE_NAME,
                  where: '"_InternalState" = ?',
                  whereArgs: [INTERNAL_STATE_NONE],
                );

                // Insert new records
                for (final model in userLocations) {
                  final values = model.encodeDB(user.username);
                  batch.insert(_USER_LOCATION_TABLE_NAME, values);
                }
              } else {
                // Delete->Insert only the fetched records
                for (final model in userLocations) {
                  final values = model.encodeDB(user.username);
                  final q = QueryArgs.fromUserLocation(user.username, model);
                  if (q.isCorrect) {
                    batch.delete(_USER_LOCATION_TABLE_NAME,
                        where: q.query, whereArgs: q.args);
                    batch.insert(_USER_LOCATION_TABLE_NAME, values);
                  }
                }
              }

              batch.commit();
            });
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadUserLocationsFailedAction(
                error: ActionError(
              message: 'An unexpected error occurred in the database.',
            )));
            return;
          }
        }

        // Query the records from the database
        final userLocations = await DBUserLocation.query(
          context.db,
          user.username,
          userID: userID,
          locationCode: locationCode,
        );

        // DISPATCH: LOAD - Success
        store.dispatch(LoadUserLocationsSuccessAction(
          userLocations,
          userID: userID,
          locationCode: locationCode,
          etag: etag,
          offline: offline,
        ));
      }
    };

const _USER_SETUP_SERVICE_ENDPOINT = 'E7MR_User_Setup';
const _USER_SETUP_TABLE_NAME = 'UserSetup';

class LoadUserSetupsBeginAction {
  LoadUserSetupsBeginAction({
    this.userID,
    this.etag,
    this.offline,
  });
  final String userID;
  final String etag;
  final bool offline;
}

class LoadUserSetupsSuccessAction {
  LoadUserSetupsSuccessAction(
    this.userSetups, {
    this.userID,
    this.etag,
    this.offline,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
  });
  final Iterable<UserSetupState> userSetups;
  final String userID;
  final String etag;
  final bool offline;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;
}

class LoadUserSetupsFailedAction {
  LoadUserSetupsFailedAction({
    this.error,
    this.userID,
    this.etag,
    this.offline,
  });
  final ActionError error;
  final String userID;
  final String etag;
  final bool offline;
}

ThunkAction<AppState> loadUserSetups({
  String userID,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = userSetupStateStatusSelector(store.state);
        if (status.isLoading) {
          return;
        }
        if (!loadPosted &&
            0 >
                DateTime.now()
                    .difference(status.lastUpdated)
                    .compareTo(const Duration(seconds: 1))) {
          // Limit loading to once per second
          return;
        }

        // DISPATCH: LOAD - Begin
        store.dispatch(LoadUserSetupsBeginAction(
          userID: userID,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          final credentials = user.credentials;
          Response res;

          Iterable<UserSetupState> userSetups = Iterable.empty();
          final values = List<dynamic>();

          var doneFetching = false;
          var i = 0;
          do {
            try {
              if (userID != null) {
                res = await NavService.getSingle(
                  credentials,
                  _USER_SETUP_SERVICE_ENDPOINT,
                  "User_ID='$userID'",
                  etag: etag,
                );
              } else {
                res = await NavService.getMultiple(
                  credentials,
                  _USER_SETUP_SERVICE_ENDPOINT,
                  skip: i++ * ODATA_MAX_ENTITIES,
                );
              }
            } catch (e) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadUserSetupsFailedAction(
                error: ActionError(message: e.toString()),
                userID: userID,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            if (res == null || res.statusCode != 200) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadUserSetupsFailedAction(
                error: ActionError.fromHttpResponse(res),
                userID: userID,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            final currentValues = NavService.valuesAPI(res);
            if (currentValues != null) {
              values.addAll(currentValues);
            }

            doneFetching = currentValues.length < ODATA_MAX_ENTITIES;
          } while (!doneFetching);

          if (values != null) {
            userSetups = values.map((value) => UserSetupState.decodeAPI(value));
          }

          // Save the records to the database
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              if (userID == null) {
                // Delete all records
                batch.delete(
                  _USER_SETUP_TABLE_NAME,
                  where: '"_InternalState" = ?',
                  whereArgs: [INTERNAL_STATE_NONE],
                );

                // Insert new records
                for (final model in userSetups) {
                  final values = model.encodeDB(user.username);
                  batch.insert(_USER_SETUP_TABLE_NAME, values);
                }
              } else {
                // Delete->Insert only the fetched records
                for (final model in userSetups) {
                  final values = model.encodeDB(user.username);
                  final q = QueryArgs.fromUserSetup(user.username, model);
                  if (q.isCorrect) {
                    batch.delete(_USER_SETUP_TABLE_NAME,
                        where: q.query, whereArgs: q.args);
                    batch.insert(_USER_SETUP_TABLE_NAME, values);
                  }
                }
              }

              batch.commit();
            });
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadUserSetupsFailedAction(
                error: ActionError(
              message: 'An unexpected error occurred in the database.',
            )));
            return;
          }
        }

        // Query the records from the database
        final userSetups = await DBUserSetup.query(
          context.db,
          user.username,
          userID: userID,
        );

        // DISPATCH: LOAD - Success
        store.dispatch(LoadUserSetupsSuccessAction(
          userSetups,
          userID: userID,
          etag: etag,
          offline: offline,
        ));
      }
    };

const _WORK_TYPE_SERVICE_ENDPOINT = 'E7MR_Work_Types';
const _WORK_TYPE_TABLE_NAME = 'WorkType';

class LoadWorkTypesBeginAction {
  LoadWorkTypesBeginAction({
    this.code,
    this.etag,
    this.offline,
  });
  final String code;
  final String etag;
  final bool offline;
}

class LoadWorkTypesSuccessAction {
  LoadWorkTypesSuccessAction(
    this.workTypes, {
    this.code,
    this.etag,
    this.offline,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
  });
  final Iterable<WorkTypeState> workTypes;
  final String code;
  final String etag;
  final bool offline;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;
}

class LoadWorkTypesFailedAction {
  LoadWorkTypesFailedAction({
    this.error,
    this.code,
    this.etag,
    this.offline,
  });
  final ActionError error;
  final String code;
  final String etag;
  final bool offline;
}

ThunkAction<AppState> loadWorkTypes({
  String code,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = workTypeStateStatusSelector(store.state);
        if (status.isLoading) {
          return;
        }
        if (!loadPosted &&
            0 >
                DateTime.now()
                    .difference(status.lastUpdated)
                    .compareTo(const Duration(seconds: 1))) {
          // Limit loading to once per second
          return;
        }

        // DISPATCH: LOAD - Begin
        store.dispatch(LoadWorkTypesBeginAction(
          code: code,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          final credentials = user.credentials;
          Response res;

          Iterable<WorkTypeState> workTypes = Iterable.empty();
          final values = List<dynamic>();

          var doneFetching = false;
          var i = 0;
          do {
            try {
              if (code != null) {
                res = await NavService.getSingle(
                  credentials,
                  _WORK_TYPE_SERVICE_ENDPOINT,
                  "Code='$code'",
                  etag: etag,
                );
              } else {
                res = await NavService.getMultiple(
                  credentials,
                  _WORK_TYPE_SERVICE_ENDPOINT,
                  skip: i++ * ODATA_MAX_ENTITIES,
                );
              }
            } catch (e) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadWorkTypesFailedAction(
                error: ActionError(message: e.toString()),
                code: code,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            if (res == null || res.statusCode != 200) {
              // DISPATCH: LOAD - Failed
              store.dispatch(LoadWorkTypesFailedAction(
                error: ActionError.fromHttpResponse(res),
                code: code,
                etag: etag,
                offline: offline,
              ));
              return;
            }

            final currentValues = NavService.valuesAPI(res);
            if (currentValues != null) {
              values.addAll(currentValues);
            }

            doneFetching = currentValues.length < ODATA_MAX_ENTITIES;
          } while (!doneFetching);

          if (values != null) {
            workTypes = values.map((value) => WorkTypeState.decodeAPI(value));
          }

          // Save the records to the database
          try {
            await context.db.transaction((txn) async {
              final batch = txn.batch();

              if (code == null) {
                // Delete all records
                batch.delete(
                  _WORK_TYPE_TABLE_NAME,
                  where: '"_InternalState" = ?',
                  whereArgs: [INTERNAL_STATE_NONE],
                );

                // Insert new records
                for (final model in workTypes) {
                  final values = model.encodeDB(user.username);
                  batch.insert(_WORK_TYPE_TABLE_NAME, values);
                }
              } else {
                // Delete->Insert only the fetched records
                for (final model in workTypes) {
                  final values = model.encodeDB(user.username);
                  final q = QueryArgs.fromWorkType(user.username, model);
                  if (q.isCorrect) {
                    batch.delete(_WORK_TYPE_TABLE_NAME,
                        where: q.query, whereArgs: q.args);
                    batch.insert(_WORK_TYPE_TABLE_NAME, values);
                  }
                }
              }

              batch.commit();
            });
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadWorkTypesFailedAction(
                error: ActionError(
              message: 'An unexpected error occurred in the database.',
            )));
            return;
          }
        }

        // Query the records from the database
        final workTypes = await DBWorkType.query(
          context.db,
          user.username,
          code: code,
        );

        // DISPATCH: LOAD - Success
        store.dispatch(LoadWorkTypesSuccessAction(
          workTypes,
          code: code,
          etag: etag,
          offline: offline,
        ));
      }
    };

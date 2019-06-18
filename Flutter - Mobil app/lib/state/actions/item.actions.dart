import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:e7mr/state/actions/base.actions.dart';
import 'package:e7mr/state/middleware/thunk/thunk.middleware.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/item_state.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/item_state_status_selectors.dart';
import 'package:e7mr/state/services/nav.service.dart';
import 'package:e7mr/utils/db.util.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

const _PACKAGE_SERVICE_ENDPOINT = 'E7MR_Packages';
const _PACKAGE_NO_ITEM = 'PACKAGE_NO_27';
const _ITEM_TABLE_NAME = 'Item';

class LoadItemsBeginAction {
  LoadItemsBeginAction({
    this.no,
    this.etag,
    this.offline,
  });
  final String no;
  final String etag;
  final bool offline;
}

class LoadItemsProgressAction {
  LoadItemsProgressAction(this.current, this.total);

  final int current;
  final int total;
}

class LoadItemsSuccessAction {
  LoadItemsSuccessAction({
    this.items,
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
  final Iterable<ItemState> items;
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

class LoadItemsFailedAction {
  LoadItemsFailedAction({
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

ThunkAction<AppState> queryItems({
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
        store.dispatch(LoadItemsBeginAction());
        try {
          final items = await _queryItems(
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
            LoadItemsSuccessAction(
              items: items,
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
          store.dispatch(LoadItemsFailedAction(
              error: ActionError(message: 'Could\'nt read the database.')));
        }
      }
    };

Future<Iterable<ItemState>> queryItemsDirect(
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
    _queryItems(
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

Future<Iterable<ItemState>> _queryItems(
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
        _ITEM_TABLE_NAME,
        distinct: distinct,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      ) ??
      Iterable.empty();

  return rows.map((row) => ItemState.decodeDB(Map.of(row)));
}

ThunkAction<AppState> loadItems({
  String no,
  String etag,
  bool offline = false,
  bool loadPosted = false,
}) =>
    (store, context) async {
      final user = userSelector(store.state);
      if (user != null && user.username.isNotEmpty) {
        var status = itemStateStatusSelector(store.state);
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
        store.dispatch(LoadItemsBeginAction(
          no: no,
          etag: etag,
          offline: offline,
        ));

        if (!offline) {
          // Fetch new records from the server
          Response response;

          // Retrieve previous package no
          final sharedPrefs = await SharedPreferences.getInstance();
          final prevPackageNo = sharedPrefs.getInt(_PACKAGE_NO_ITEM) ?? 0;
          var newPackageNo;

          try {
            response = await NavService.getMultiple(
              user.credentials,
              _PACKAGE_SERVICE_ENDPOINT,
              filter: 'Source_Table_ID eq 27 and Package_No gt $prevPackageNo',
              orderby: 'Package_No desc',
              top: 1,
            );
          } catch (e) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadItemsFailedAction(
              error: ActionError(message: e.toString()),
              no: no,
              etag: etag,
              offline: offline,
            ));
            return;
          }

          if (response == null || response.statusCode != 200) {
            // DISPATCH: LOAD - Failed
            store.dispatch(LoadItemsFailedAction(
              error: ActionError.fromHttpResponse(response),
              no: no,
              etag: etag,
              offline: offline,
            ));
            return;
          }

          final values = NavService.valuesAPI(response);

          if (values == null || values.isEmpty) {
            store.dispatch(LoadItemsSuccessAction());
            return;
          }

          final map = values.first as Map<String, dynamic>;
          newPackageNo = map['Package_No'];

          // Unwrap package
          final receivePort = ReceivePort();
          await Isolate.spawn(
              processItemsAPI,
              ProcessItemsAPIModel(
                receivePort.sendPort,
                user.username,
                map['ContentBLOB'] as String,
              ));

          await for (final message in receivePort) {
            if (message is ProcessItemsAPIDone) {
              receivePort.close();
            } else if (message is ProcessItemsAPIResult) {
              // Save the records to the database
              try {
                final db = await DbUtil.db;
                // Replace the whole table
                int i = 0;
                await db.delete(_ITEM_TABLE_NAME);

                const BATCH_SIZE = 100;
                final totalItems = message.items.length;

                var batch = db.batch();
                for (final item in message.items) {
                  if (i % BATCH_SIZE == 0) {
                    store.dispatch(LoadItemsProgressAction(i, totalItems));
                    await batch.commit();
                    batch = db.batch();
                  }
                  batch.insert(_ITEM_TABLE_NAME, item);
                  i++;
                }
                await batch.commit();
                store.dispatch(LoadItemsProgressAction(totalItems, totalItems));
              } catch (e) {
                // DISPATCH: LOAD - Failed
                store.dispatch(LoadItemsFailedAction(
                    error: ActionError(
                  message: 'An unexpected error occurred in the database.',
                )));
              }
            }
          }

          // Update the package no.
          if (newPackageNo != null) {
            sharedPrefs.setInt(_PACKAGE_NO_ITEM, newPackageNo);
          }
        }

        // Reload last query.
        status = itemStateStatusSelector(store.state); // Get the latest status
        var reloadedItems;
        if ([
          status.queryDistinct,
          status.queryWhere,
          status.queryWhereArgs,
          status.queryGroupBy,
          status.queryHaving,
          status.queryOrderBy,
          status.queryLimit,
          status.queryOffset,
        ].any((a) => a != null)) {
          reloadedItems = await _queryItems(
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
        }

        // DISPATCH: LOAD - Success
        store.dispatch(LoadItemsSuccessAction(
          items: reloadedItems,
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

void processItemsAPI(ProcessItemsAPIModel model) async {
  final compressed = base64.decode(model.content);
  final uncompressed = gzip.decode(compressed);
  final records = utf8.decode(uncompressed);
  final items = Stream.fromIterable(LineSplitter.split(records))
      .where((record) => record.isNotEmpty)
      .map((record) => json.decode(record))
      .map((record) => ItemState.decodeAPI(record as Map<String, dynamic>))
      .map((record) => record.encodeDB(model.username));

  model.sendPort.send(ProcessItemsAPIResult(await items.toList()));
  model.sendPort.send(ProcessItemsAPIDone());
}

class ProcessItemsAPIModel {
  final SendPort sendPort;
  final String username;
  final String content;

  ProcessItemsAPIModel(this.sendPort, this.username, this.content);
}

class ProcessItemsAPIResult {
  final List items;

  ProcessItemsAPIResult(this.items);
}

class ProcessItemsAPIDone {}

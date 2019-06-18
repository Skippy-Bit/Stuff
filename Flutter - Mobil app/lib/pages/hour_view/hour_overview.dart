import 'dart:convert';

import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/actions/log_commands/job_hour.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/job_journal_line_state.dart';
import 'package:e7mr/state/models/generated/job_ledger_entry_state.dart';
import 'package:e7mr/state/models/generated/log_state.dart';
import 'package:e7mr/state/models/usage_model.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/utils/constants.dart';
import 'package:e7mr/utils/db.util.dart';
import 'package:e7mr/widgets/date_heading_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sqflite/sqflite.dart';

class HourViewPage extends StatefulWidget {
  HourViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HourViewPageState createState() => _HourViewPageState();
}

class _HourViewPageState extends State<HourViewPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<UsageItemModel>> getModels(BuildContext context) async {
    if (!this.mounted) {
      return List<UsageItemModel>();
    }

    final store = StoreProvider.of<AppState>(context);
    final user = userSelector(store.state);
    if (user != null && user.username.isNotEmpty) {
      final db = await DbUtil.db;
      final lines = await _loadJobJournalLines(db, store, user.username);
      final entries = await _loadJobLedgerEntries(db, store, user.username);
      final hours = (await _loadLogs(db, store, user.username))
          .where(
              (log) => log.command == JobHour.COMMAND && log.content.isNotEmpty)
          .map((log) => JobHour.decode(json.decode(utf8.decode(log.content))));

      final items = List<UsageItemModel>();
      items.addAll(lines
          .where((a) => a.typeAsInt == JOB_JOURNAL_LINE_TYPE_RESOURCE)
          .map((line) => UsageItemModel.fromJobJournalLine(line)));
      items.addAll(entries
          .where((a) => a.typeAsInt == JOB_JOURNAL_LINE_TYPE_RESOURCE)
          .map((entry) => UsageItemModel.fromJobLedgerEntry(entry)));
      items.addAll(hours.map((hour) => UsageItemModel.fromJobHour(hour)));
      items.sort((a, b) => b.postingDateTime.compareTo(a.postingDateTime));
      return items;
    }
    return List<UsageItemModel>();
  }

  Future<Iterable<JobJournalLineState>> _loadJobJournalLines(
      Database db, Store<AppState> store, String username) async {
    final where = 'User = ?';
    final whereArgs = [username];
    return await queryJobJournalLinesDirect(db,
        where: where, whereArgs: whereArgs);
  }

  Future<Iterable<JobLedgerEntryState>> _loadJobLedgerEntries(
      Database db, Store<AppState> store, String username) async {
    final where = 'User = ?';
    final whereArgs = [username];
    return await queryJobLedgerEntriesDirect(db,
        where: where, whereArgs: whereArgs);
  }

  Future<Iterable<LogState>> _loadLogs(
      Database db, Store<AppState> store, String username) async {
    final where = 'User = ? AND Command = ?';
    final whereArgs = [username, JobHour.COMMAND];
    return await queryLogsDirect(db, where: where, whereArgs: whereArgs);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StoreConnector<AppState, void>(
        converter: (store) {},
        ignoreChange: (state) => isLoadingStateStatusSelector(state),
        builder: (context, _) => FutureBuilder<List<UsageItemModel>>(
            future: getModels(context),
            initialData: List<UsageItemModel>(),
            builder: (context, snapshot) {
              return _buildListView(snapshot.data);
            }),
      ),
    );
  }

  ListView _buildListView(List<UsageItemModel> items) {
    final listTiles = _groupListItems(items).toList();
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => listTiles[index],
      itemCount: listTiles?.length ?? 0,
    );
  }

  Iterable<Widget> _groupListItems(Iterable<UsageItemModel> lines) sync* {
    if (lines != null) {
      var prevDate = DateTime.fromMicrosecondsSinceEpoch(0);
      for (final line in lines) {
        final newDate = line.postingDateTime;
        if (!_isSameDate(prevDate, newDate)) {
          yield DateHeadingListTile(date: newDate);
        }
        prevDate = newDate;
        yield line.buildUsageListTile();
      }
    }
  }

  bool _isSameDate(DateTime a, DateTime b) {
    assert(a != null && b != null);
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

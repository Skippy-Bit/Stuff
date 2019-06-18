import 'dart:collection';
import 'dart:convert';

import 'package:e7mr/e7mr_theme.dart';
import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/actions/log_commands/job_hour.dart';
import 'package:e7mr/state/actions/log_commands/job_item_usage.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/state/models/usage_model.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/utils/constants.dart';
import 'package:e7mr/utils/db.util.dart';
import 'package:e7mr/widgets/date_heading_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class UsageType {
  const UsageType(this.label, this.value);
  final String label;
  final int value;
}

class JobUsagePage extends StatefulWidget {
  final JobState job;

  JobUsagePage({
    Key key,
    this.title,
    @required this.job,
  }) : super(key: key);

  final String title;

  @override
  _JobUsagePageState createState() => _JobUsagePageState();
}

class _JobUsagePageState extends State<JobUsagePage> {
  DateFormat ymdFormat;
  static const List<UsageType> _types = [
    const UsageType('Timer', JOB_JOURNAL_LINE_TYPE_RESOURCE),
    const UsageType('Varer', JOB_JOURNAL_LINE_TYPE_ITEM),
  ];
  HashSet<int> _activeFilters = HashSet.of(_types.map((f) => f.value));

  @override
  void initState() {
    super.initState();
    ymdFormat = DateFormat.yMd();
  }

  Future<List<UsageItemModel>> getModels(BuildContext context) async {
    if (!this.mounted) {
      return List<UsageItemModel>();
    }
    final store = StoreProvider.of<AppState>(context);
    final user = userSelector(store.state);

    if (user != null && user.username.isNotEmpty) {
      assert(widget.job != null && widget.job.no.isNotEmpty);
      final db = await DbUtil.db;

      var where = 'User = ? AND Job_No = ?';
      var whereArgs = [user.username, widget.job.no];
      final lines = await queryJobJournalLinesDirect(db,
          where: where, whereArgs: whereArgs);
      final entries = await queryJobLedgerEntriesDirect(db,
          where: where, whereArgs: whereArgs);

      where =
          'User = ? AND ((Command = ? AND Hash LIKE ?) OR (Command = ? AND Hash LIKE ?))';
      whereArgs = [
        user.username,
        JobHour.COMMAND,
        JobHour.buildSqlLikeHash(widget.job.no),
        JobItemUsage.COMMAND,
        JobItemUsage.buildSqlLikeHash(jobNo: widget.job.no),
      ];
      final logs =
          await queryLogsDirect(db, where: where, whereArgs: whereArgs);

      final hours = logs
          .where(
              (log) => log.command == JobHour.COMMAND && log.content.isNotEmpty)
          .map((log) => JobHour.decode(json.decode(utf8.decode(log.content))));

      final usages = logs
          .where((log) =>
              log.command == JobItemUsage.COMMAND && log.content.isNotEmpty)
          .map((log) =>
              JobItemUsage.decode(json.decode(utf8.decode(log.content))));

      final items = List<UsageItemModel>();
      items.addAll(
        lines.map((line) => UsageItemModel.fromJobJournalLine(line)),
      );
      items.addAll(
        entries.map((entry) => UsageItemModel.fromJobLedgerEntry(entry)),
      );
      items.addAll(hours.map((hour) => UsageItemModel.fromJobHour(hour)));
      items.addAll(
          usages.map((usage) => UsageItemModel.fromJobItemUsage(usage)));
      items.sort((a, b) => b.postingDateTime.compareTo(a.postingDateTime));

      return items;
    }
    return List<UsageItemModel>();
  }

  Iterable<Widget> get filterWidgets sync* {
    for (UsageType type in _types) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          label: Text(type.label ?? ''),
          backgroundColor: E7MRTheme.primary,
          selected: _activeFilters.contains(type.value),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _activeFilters.add(type.value);
              } else {
                _activeFilters.remove(type.value);
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: filterWidgets.toList(),
          ),
        ),
        Divider(),
        StoreConnector<AppState, void>(
          converter: (store) {},
          ignoreChange: (state) => isLoadingStateStatusSelector(state),
          builder: (context, _) => FutureBuilder<List<UsageItemModel>>(
                future: getModels(context),
                initialData: List<UsageItemModel>(),
                builder: (context, snapshot) {
                  var lines = snapshot.data;
                  final activeFilters = _activeFilters.toList();
                  lines = lines.where((line) {
                    return activeFilters.contains(line.typeAsInt);
                  }).toList();
                  final listTiles = _groupListItems(lines);
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) =>
                          listTiles[index],
                      itemCount: listTiles?.length ?? 0,
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }

  List<Widget> _groupListItems(Iterable<UsageItemModel> lines) {
    if (lines == null) {
      lines = Iterable.empty();
    }

    final result = List<Widget>();
    var prevDate = DateTime.fromMicrosecondsSinceEpoch(0);
    for (var i = 0; i < lines.length; i++) {
      final line = lines.elementAt(i);
      final date = line.postingDateTime;
      if (i == 0 ||
          prevDate.year != date.year ||
          prevDate.month != date.month ||
          prevDate.day != date.day) {
        result.add(DateHeadingListTile(date: date));
      }
      prevDate = line.postingDateTime;
      result.add(line.buildUsageListTile(showJob: false));
    }
    return result;
  }
}

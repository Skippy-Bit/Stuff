import 'dart:async';

import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/demand_model.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/state/models/generated/job_task_state.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/utils/db.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';

class JobDemandPage extends StatefulWidget {
  final String title;
  final JobState job;
  final JobTaskState jobTask;

  JobDemandPage({
    Key key,
    this.title,
    @required this.job,
    @required this.jobTask,
  }) : super(key: key);

  @override
  _JobDemandPageState createState() => _JobDemandPageState();
}

class _JobDemandPageState extends State<JobDemandPage> {
  Future<List<DemandModel>> getModels(BuildContext context) async {
    if (!this.mounted) {
      return List<DemandModel>();
    }
    final store = StoreProvider.of<AppState>(context);
    final user = userSelector(store.state);
    if (user != null && user.username.isNotEmpty) {
      assert(widget.jobTask != null &&
          widget.jobTask.jobNo != null &&
          widget.jobTask.jobNo.isNotEmpty &&
          widget.jobTask.jobTaskNo != null &&
          widget.jobTask.jobTaskNo.isNotEmpty);
      final db = await DbUtil.db;

      var where = 'User = ? AND Job_No = ? AND Job_Task_No = ?';
      var whereArgs = [
        user.username,
        widget.jobTask.jobNo,
        widget.jobTask.jobTaskNo,
      ];
      final lines = await queryJobPlanningLinesDirect(
        db,
        where: where,
        whereArgs: whereArgs,
      );

      final models = lines.map((line) => DemandModel.fromJobPlanningLine(line));
      return models.toList();
    }
    return List<DemandModel>();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, void>(
      converter: (store) {},
      ignoreChange: (state) => isLoadingStateStatusSelector(state),
      builder: (context, _) => FutureBuilder<List<DemandModel>>(
            future: getModels(context),
            initialData: List<DemandModel>(),
            builder: (context, snapshot) {
              final listTiles = _buildListItems(snapshot.data);
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    listTiles[index],
                itemCount: listTiles?.length ?? 0,
              );
            },
          ),
    );
  }

  List<Widget> _buildListItems(Iterable<DemandModel> lines) {
    if (lines == null) {
      lines = Iterable.empty();
    }

    final result = List<Widget>();
    lines.forEach((line) {
      result.add(line.buildDemandListTile());
    });

    return result;
  }
}

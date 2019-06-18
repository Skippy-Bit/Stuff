import 'package:e7mr/e7mr_theme.dart';
import 'package:e7mr/pages/job/job_task.dart';
import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/state/models/generated/job_task_state.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/utils/db.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

typedef Future<void> FutureVoidCallback();

class JobTaskListPage extends StatefulWidget {
  final String title;
  final JobState job;

  JobTaskListPage({Key key, this.title, @required this.job}) : super(key: key);

  @override
  _JobTaskListPageState createState() => _JobTaskListPageState();
}

class _JobTaskListPageState extends State<JobTaskListPage> {
  TextEditingController search;
  String _searchTerm;

  @override
  void initState() {
    super.initState();
    search = TextEditingController();
  }

  Future<List<JobTaskState>> getModels(BuildContext context) async {
    if (!this.mounted) {
      return List<JobTaskState>();
    }

    final store = StoreProvider.of<AppState>(context);
    final user = userSelector(store.state);
    if (user != null && user.username.isNotEmpty) {
      assert(widget.job.no.isNotEmpty);
      final db = await DbUtil.db;

      var where = 'User = ? AND Job_No = ?';
      var whereArgs = [user.username, widget.job.no];
      return (await queryJobTasksDirect(db, where: where, whereArgs: whereArgs))
          .toList();
    }
    return List<JobTaskState>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildSearchBar(),
        buildJobTaskList(),
      ],
    );
  }

  Widget buildJobTaskList() {
    return StoreConnector<AppState, void>(
      converter: (store) {},
      ignoreChange: (state) => isLoadingStateStatusSelector(state),
      builder: (context, _) => FutureBuilder<List<JobTaskState>>(
            future: getModels(context),
            initialData: List<JobTaskState>(),
            builder: (context, snapshot) {
              return jobTaskList(filterSearch(snapshot.data));
            },
          ),
    );
  }

  Expanded jobTaskList(List<JobTaskState> jobTasks) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            JobTaskListEntry(widget.job, jobTasks[index]),
        itemCount: jobTasks.length,
        physics: const AlwaysScrollableScrollPhysics(),
      ),
    );
  }

  List<JobTaskState> filterSearch(List<JobTaskState> jobTasks) {
    if (_searchTerm != null && _searchTerm != '') {
      final st = _searchTerm.toUpperCase();
      jobTasks = jobTasks
          .where((jobTask) =>
              jobTask.description.toUpperCase().contains(st) ||
              jobTask.jobTaskNo.toUpperCase().contains(st))
          .toList();
    }
    return jobTasks;
  }

  Widget buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: E7MRTheme.secondary,
            style: BorderStyle.solid,
          ),
          bottom: BorderSide(
            color: E7MRTheme.secondary,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          searchInput(),
          searchButton(),
        ],
      ),
    );
  }

  Expanded searchInput() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        child: TextField(
          controller: search,
          onEditingComplete: () {
            setState(() {
              _searchTerm = search.text;
            });
          },
        ),
      ),
    );
  }

  IconButton searchButton() {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        setState(() {
          _searchTerm = search.text;
        });
      },
    );
  }
}

class JobTaskListEntry extends StatelessWidget {
  JobTaskListEntry(
    this.job,
    this.jobTask, {
    Key key,
  }) : super(key: key);

  final JobState job;
  final JobTaskState jobTask;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          key: PageStorageKey<String>(jobTask.jobTaskNo),
          title: _buildTitle(),
          onTap: () => _onTap(context),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildTitle() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                jobTask.jobTaskNo,
                textScaleFactor: 0.75,
              ),
              Text(jobTask.description),
            ],
          ),
        ),
      ],
    );
  }

  void _onTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return JobTaskPage(
            job: job,
            jobTask: jobTask,
          );
        },
      ),
    );
  }
}

import 'dart:async';

import 'package:e7mr/e7mr_theme.dart';
import 'package:e7mr/pages/job/job.dart';
import 'package:e7mr/state/middleware/generated/job_task/db_job_task.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/state/selectors/job_selectors.dart';
import 'package:e7mr/utils/db.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class JobListPageModel {
  JobListPageModel({@required this.jobs});

  final List<JobState> jobs;
}

class JobListPage extends StatefulWidget {
  JobListPage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  TextEditingController search;
  String _searchTerm;

  @override
  void initState() {
    super.initState();
    search = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildSearchBar(),
        _buildMain(),
      ],
    );
  }

// TODO: Rewrite
  Widget _buildMain() {
    return StoreConnector<AppState, JobListPageModel>(
      converter: (store) =>
          JobListPageModel(jobs: jobsSelector(store.state).toList()),
      ignoreChange: (state) => isLoadingStateStatusSelector(state),
      builder: (context, model) {
        final filteredJobs = _filterSearch(model.jobs);
        return _buildJobList(filteredJobs);
      },
    );
  }

  Widget _buildJobList(List<JobState> jobs) {
    return Expanded(
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: jobs.length,
        itemBuilder: (BuildContext context, int index) {
          return JobListEntry(jobs[index]);
        },
      ),
    );
  }

  List<JobState> _filterSearch(List<JobState> jobs) {
    if (_searchTerm != null && _searchTerm.isNotEmpty) {
      final term = _searchTerm.toUpperCase();
      jobs = jobs.where((job) {
        final fields = [
          job.no.toUpperCase(),
          job.description.toUpperCase(),
        ];
        return fields.any((field) => field.contains(term));
      }).toList();
    }
    return jobs;
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: _searchBarDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildSearchInput(),
          _buildSearchButton(),
        ],
      ),
    );
  }

  BoxDecoration get _searchBarDecoration {
    return BoxDecoration(
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
    );
  }

  Widget _buildSearchInput() {
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

  Widget _buildSearchButton() {
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

class JobListEntry extends StatelessWidget {
  JobListEntry(
    this.job, {
    Key key,
  }) : super(key: key);

  final JobState job;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: PageStorageKey<String>(job.no),
      title: _buildTitle(context),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => JobPage(job: job)),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    return Row(
      children: <Widget>[
        _buildTitleLeading(),
        _buildTitleTrailing(store),
      ],
    );
  }

  Expanded _buildTitleLeading() {
    return Expanded(
        child: Column(
      children: <Widget>[
        Text(job.no, textScaleFactor: 0.9),
        Text(job.description),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    ));
  }

  Widget _buildTitleTrailing(Store<AppState> store) {
    return Expanded(
        child: Align(
      alignment: Alignment.topRight,
      child: FutureBuilder(
        initialData: 'Laster...',
        future: _fetchJobTaskCount(store),
        builder: (context, snapshot) =>
            Text("Oppgaver: ${snapshot?.data ?? 'n/a'}"),
      ),
    ));
  }

  Future<String> _fetchJobTaskCount(Store<AppState> store) async {
    final db = await DbUtil.db;
    final username = userSelector(store.state)?.username;
    if (username != null && username.isNotEmpty) {
      assert(job != null && job.no != null && job.no.isNotEmpty);

      var count = 0;

      final rows = await db.rawQuery(
        'SELECT count(*) as count FROM ${DBJobTask.TABLE_NAME} WHERE User=? AND Job_No=?',
        [username, job.no],
      );

      if (rows != null && rows.isNotEmpty) {
        final row = rows.first;
        count = row['count'];
      }

      return count.toString();
    }
    return null;
  }
}

import 'package:e7mr/pages/job/image/job_images.dart';
import 'package:e7mr/pages/job/job_task_list.dart';
import 'package:e7mr/pages/job/usage/job_usage.dart';
import 'package:e7mr/pages/job/job_details.dart';
import 'package:e7mr/state/middleware/generated/initial_load.middleware.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/state/selectors/item_state_status_selectors.dart';
import 'package:e7mr/widgets/dual_title.dart';
import 'package:e7mr/widgets/e7mr_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

@immutable
class JobPage extends StatelessWidget {
  JobPage({
    Key key,
    @required this.job,
  })  : tabs = _buildTabs(job),
        super(key: key);

  final JobState job;
  final E7MRTabs tabs;

  static const _STATUS_SELECTORS = [
    jobTaskStateStatusSelector,
    jobJournalLineStateStatusSelector,
    jobLedgerEntryStateStatusSelector,
    logStateStatusSelector,
    itemStateStatusSelector,
  ];

  final List<Widget> actions = [
    StoreBuilder<AppState>(
      rebuildOnChange: false,
      builder: (context, store) => IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              final statuses = _STATUS_SELECTORS.map((s) => s(store.state));
              final isLoading = statuses.any((status) => status.isLoading);

              // Only sync if nothing is loading.
              if (!isLoading) {
                syncAll(store);
              }
            },
          ),
    ),
  ];

  static E7MRTabs _buildTabs(JobState job) => E7MRTabs(
        statusSelectors: _STATUS_SELECTORS,
        tabs: [
          E7MRTab(
            icon: Icons.view_headline,
            text: 'Oppgaver',
            view: JobTaskListPage(job: job),
          ),
          E7MRTab(
            icon: Icons.folder_shared,
            text: 'Detaljer',
            view: JobDetailsPage(job: job),
          ),
          E7MRTab(
            icon: Icons.list,
            text: 'Forbruk',
            view: JobUsagePage(job: job),
          ),
          E7MRTab(
            icon: Icons.camera_alt,
            text: 'Bilder',
            view: JobImagePage(jobNo: job.no),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: DualTitle(
            primary: job.no,
            secondary: job.description,
          ),
          actions: actions,
          titleSpacing: 1.0,
          bottom: tabs.tabBar,
        ),
        body: tabs.body,
      ),
    );
  }
}

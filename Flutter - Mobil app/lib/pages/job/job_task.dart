import 'dart:math' as math;
import 'package:e7mr/pages/job/demand/job_demand.dart';
import 'package:e7mr/pages/job/image/job_images.dart';
import 'package:e7mr/pages/job/image/job_new_image.dart';
import 'package:e7mr/pages/job/usage/job_add_usage.dart';
import 'package:e7mr/pages/job/job_task_details.dart';
import 'package:e7mr/pages/job/usage/job_task_usage.dart';
import 'package:e7mr/pages/job/hour_reg/job_hour_reg.dart';
import 'package:e7mr/state/middleware/generated/initial_load.middleware.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/state/models/generated/job_task_state.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/state/selectors/item_state_status_selectors.dart';
import 'package:e7mr/widgets/dual_title.dart';
import 'package:e7mr/widgets/e7mr_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

@immutable
class JobTaskPage extends StatelessWidget {
  JobTaskPage({
    Key key,
    @required this.job,
    @required this.jobTask,
  })  : tabs = _buildTabs(job, jobTask),
        super(key: key);

  final JobState job;
  final JobTaskState jobTask;
  final E7MRTabs tabs;

  static const _STATUS_SELECTORS = [
    jobTaskStateStatusSelector,
    jobJournalLineStateStatusSelector,
    jobLedgerEntryStateStatusSelector,
    logStateStatusSelector,
    itemStateStatusSelector,
  ];

  static E7MRTabs _buildTabs(JobState job, JobTaskState jobTask) => E7MRTabs(
        statusSelectors: _STATUS_SELECTORS,
        tabs: [
          E7MRTab(
            icon: Icons.folder_shared,
            text: 'Detaljer',
            view: JobTaskDetailsPage(
              job: job,
              jobTask: jobTask,
            ),
          ),
          E7MRTab(
            icon: Icons.list,
            text: 'Forbruk',
            view: JobTaskUsagePage(
              job: job,
              jobTask: jobTask,
            ),
          ),
          E7MRTab(
            icon: Icons.assignment,
            text: 'Varebehov',
            view: JobDemandPage(
              job: job,
              jobTask: jobTask,
            ),
          ),
          E7MRTab(
            icon: Icons.camera_alt,
            text: 'Bilder',
            view: JobImagePage(
              jobNo: jobTask.jobNo,
              jobTaskNo: jobTask.jobTaskNo,
            ),
          ),
        ],
      );

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: DualTitle(
            primary: job.no,
            secondary: jobTask.description,
          ),
          titleSpacing: 1.0,
          bottom: tabs.tabBar,
          actions: actions,
        ),
        body: tabs.body,
        floatingActionButton: StoreConnector<AppState, bool>(
          converter: (store) {
            final statuses = _STATUS_SELECTORS.map((s) => s(store.state));
            return statuses.any((status) => status.isLoading);
          },
          builder: (context, isLoading) => IgnorePointer(
                ignoring: isLoading,
                child: JobFAB(job: job, jobTask: jobTask),
              ),
        ),
      ),
    );
  }
}

class FABItem {
  Widget route;
  IconData icon;
  String label;
  VoidCallback onAfterPopped;

  FABItem({
    @required this.route,
    @required this.icon,
    @required this.label,
    this.onAfterPopped,
  });
}

class JobFAB extends StatefulWidget {
  final JobState job;
  final JobTaskState jobTask;
  final VoidCallback onAfterPictureUploaded;

  const JobFAB({
    Key key,
    @required this.job,
    @required this.jobTask,
    this.onAfterPictureUploaded,
  }) : super(key: key);

  // JobFAB({Key key, this.controllerkey}) : super(key: key);
  // final GlobalKey controllerkey;

  @override
  State createState() => JobFABState();
}

class JobFABState extends State<JobFAB> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Color fabColor;
  Color textbgColor;

  JobFABState();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  Widget build(BuildContext context) {
    fabColor = Theme.of(context).accentColor;
    textbgColor = Theme.of(context).primaryColor;

    final List<FABItem> fabItems = [
      FABItem(
        label: 'Timeføring',
        icon: Icons.playlist_add,
        route: JobHourRegPage(
          job: widget.job,
          jobTask: widget.jobTask,
        ),
      ),
      FABItem(
        label: 'Legg til forbruk',
        icon: Icons.add,
        route: JobAddUsagePage(
          jobNo: widget.job.no,
          jobTaskNo: widget.jobTask.jobTaskNo,
        ),
      ),
      FABItem(
          label: 'Legg til bilde',
          icon: Icons.add_a_photo,
          route: NewImagePage(
            jobTask: widget.jobTask,
          ),
          onAfterPopped: () {
            widget?.onAfterPictureUploaded();
          }),
      // FABItem(
      //   label: 'Registrer avvik',
      //   icon: Icons.note_add,
      //   route: NewDeviationPage(),
      // ),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(fabItems.length, (int index) {
        Widget child = Container(
          height: 55.0,
          alignment: FractionalOffset.topRight,
          child: ScaleTransition(
            alignment: Alignment.centerRight,
            scale: CurvedAnimation(
              parent: controller,
              curve: Interval(0.0, 1.0 - index / fabItems.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  shape: StadiumBorder(),
                  color: textbgColor,
                  child: Text(
                    fabItems[index].label ?? '',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => fabItems[index].route,
                          ),
                        )
                        .then((_) => fabItems[index]?.onAfterPopped());
                  },
                ),
                FloatingActionButton(
                  heroTag: null,
                  backgroundColor: fabColor,
                  mini: true,
                  child: Icon(fabItems[index].icon),
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => fabItems[index].route,
                      ),
                    )
                        .then((_) {
                      if (fabItems[index]?.onAfterPopped != null) {
                        fabItems[index].onAfterPopped();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          Container(
            alignment: FractionalOffset.centerRight,
            child: FloatingActionButton(
              heroTag: null,
              child: AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    transform: Matrix4.rotationZ(
                        (controller.value ?? 0) * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child: Icon((controller.isDismissed ?? true)
                        ? Icons.add
                        : Icons.close),
                  );
                },
              ),
              onPressed: () {
                if (controller?.isDismissed ?? true) {
                  controller?.forward();
                } else {
                  controller?.reverse();
                }
              },
            ),
          ),
        ),
    );
  }
}

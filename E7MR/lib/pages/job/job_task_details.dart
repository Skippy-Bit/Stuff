import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/state/models/generated/job_task_state.dart';
import 'package:e7mr/widgets/field_list.dart';
import 'package:flutter/material.dart';

class JobTaskDetailsPage extends StatelessWidget {
  final JobState job;
  final JobTaskState jobTask;
  final String title;

  JobTaskDetailsPage({
    Key key,
    @required this.job,
    @required this.jobTask,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FieldList(fields: jobTask.detailFields);
}

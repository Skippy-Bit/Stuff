import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/widgets/field_list.dart';
import 'package:flutter/material.dart';

class JobDetailsPage extends StatelessWidget {
  JobDetailsPage({
    Key key,
    @required this.job,
    this.title,
  }) : super(key: key);

  final JobState job;
  final String title;

  @override
  Widget build(BuildContext context) => FieldList(fields: job.detailFields);
}

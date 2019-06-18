import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/job_planning_line_state.dart';

Iterable<JobPlanningLineState> jobPlanningLineSelector(AppState state) =>
    state.jobPlanningLines;

Iterable<JobPlanningLineState> jobPlanningLinesForJob(
        AppState state, String jobNo) =>
    jobPlanningLineSelector(state)
        .where((line) => line.jobNo.toUpperCase() == jobNo.toUpperCase());

Iterable<JobPlanningLineState> jobPlanningLinesForJobTask(
        AppState state, String jobNo, String jobTaskNo) =>
    jobPlanningLinesForJob(state, jobNo)
        .where((line) => line.jobTaskNo == jobTaskNo);

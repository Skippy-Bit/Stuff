import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/state/models/generated/job_task_state.dart';

Iterable<JobState> jobsSelector(AppState state) => state.jobs;
Iterable<JobTaskState> jobTasksSelector(AppState state) => state.jobTasks;
JobState jobSelector(AppState state, String jobNo) {
  if (jobNo == null || jobNo == '') {
    return null;
  }
  jobNo = jobNo.toUpperCase();
  return jobsSelector(state)
      .firstWhere((job) => job.no.toUpperCase() == jobNo, orElse: () => null);
}

JobTaskState jobTaskSelector(AppState state, String jobTaskNo) {
  if (jobTaskNo == null || jobTaskNo == '') {
    return null;
  }
  jobTaskNo = jobTaskNo.toUpperCase();
  return jobTasksSelector(state).firstWhere(
      (jobTask) => jobTask.jobTaskNo.toUpperCase() == jobTaskNo,
      orElse: () => null);
}

Iterable<JobTaskState> jobTasksForJobSelector(AppState state, String jobNo) {
  if (jobNo == null || jobNo == '') {
    return Iterable.empty();
  }
  jobNo = jobNo.toUpperCase();
  return jobTasksSelector(state)
      .where((jobTask) => jobTask.jobNo.toUpperCase() == jobNo);
}

import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/job_journal_line_state.dart';

Iterable<JobJournalLineState> jobJournalLineSelector(AppState state) =>
    state.jobJournalLines;

Iterable<JobJournalLineState> jobJournalLinesForJob(
        AppState state, String jobNo) =>
    jobJournalLineSelector(state)
        .where((line) => line.jobNo.toUpperCase() == jobNo.toUpperCase());

Iterable<JobJournalLineState> jobJournalLinesForJobTask(
        AppState state, String jobNo, String jobTaskNo) =>
    jobJournalLinesForJob(state, jobNo)
        .where((line) => line.jobTaskNo == jobTaskNo);

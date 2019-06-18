import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/job_ledger_entry_state.dart';

Iterable<JobLedgerEntryState> jobLedgerEntrySelector(AppState state) =>
    state.jobLedgerEntries;

Iterable<JobLedgerEntryState> jobLedgerEntriesForJob(
        AppState state, String jobNo) =>
    jobLedgerEntrySelector(state)
        .where((line) => line.jobNo.toUpperCase() == jobNo.toUpperCase());

Iterable<JobLedgerEntryState> jobLedgerEntriesForJobTask(
        AppState state, String jobNo, String jobTaskNo) =>
    jobLedgerEntriesForJob(state, jobNo)
        .where((line) => line.jobTaskNo == jobTaskNo);

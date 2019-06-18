import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/job_ledger_entry_state.dart';
import 'package:redux/redux.dart';

final jobLedgerEntriesReducer = combineReducers<Iterable<JobLedgerEntryState>>([
  TypedReducer<Iterable<JobLedgerEntryState>, LoadJobLedgerEntriesSuccessAction>(_loadJobLedgerEntriesSuccessAction),
]);

Iterable<JobLedgerEntryState> _loadJobLedgerEntriesSuccessAction(
  Iterable<JobLedgerEntryState> state,
  LoadJobLedgerEntriesSuccessAction action,
) {
  if (action.jobLedgerEntries != null) {
    state = action.jobLedgerEntries;
  }
  return state;
}
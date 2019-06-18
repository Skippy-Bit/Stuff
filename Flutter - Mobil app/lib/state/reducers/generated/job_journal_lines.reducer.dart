import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/job_journal_line_state.dart';
import 'package:redux/redux.dart';

final jobJournalLinesReducer = combineReducers<Iterable<JobJournalLineState>>([
  TypedReducer<Iterable<JobJournalLineState>, LoadJobJournalLinesSuccessAction>(_loadJobJournalLinesSuccessAction),
]);

Iterable<JobJournalLineState> _loadJobJournalLinesSuccessAction(
  Iterable<JobJournalLineState> state,
  LoadJobJournalLinesSuccessAction action,
) {
  if (action.jobJournalLines != null) {
    state = action.jobJournalLines;
  }
  return state;
}
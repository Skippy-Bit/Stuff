import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:redux/redux.dart';

final jobsReducer = combineReducers<Iterable<JobState>>([
  TypedReducer<Iterable<JobState>, LoadJobsSuccessAction>(_loadJobsSuccessAction),
]);

Iterable<JobState> _loadJobsSuccessAction(
  Iterable<JobState> state,
  LoadJobsSuccessAction action,
) {
  if (action.jobs != null) {
    state = action.jobs;
  }
  return state;
}
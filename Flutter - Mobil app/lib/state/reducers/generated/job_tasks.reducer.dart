import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/job_task_state.dart';
import 'package:redux/redux.dart';

final jobTasksReducer = combineReducers<Iterable<JobTaskState>>([
  TypedReducer<Iterable<JobTaskState>, LoadJobTasksSuccessAction>(_loadJobTasksSuccessAction),
]);

Iterable<JobTaskState> _loadJobTasksSuccessAction(
  Iterable<JobTaskState> state,
  LoadJobTasksSuccessAction action,
) {
  if (action.jobTasks != null) {
    state = action.jobTasks;
  }
  return state;
}
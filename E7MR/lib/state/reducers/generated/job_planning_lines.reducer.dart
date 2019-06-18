import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/job_planning_line_state.dart';
import 'package:redux/redux.dart';

final jobPlanningLinesReducer = combineReducers<Iterable<JobPlanningLineState>>([
  TypedReducer<Iterable<JobPlanningLineState>, LoadJobPlanningLinesSuccessAction>(_loadJobPlanningLinesSuccessAction),
]);

Iterable<JobPlanningLineState> _loadJobPlanningLinesSuccessAction(
  Iterable<JobPlanningLineState> state,
  LoadJobPlanningLinesSuccessAction action,
) {
  if (action.jobPlanningLines != null) {
    state = action.jobPlanningLines;
  }
  return state;
}
import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/work_type_state.dart';
import 'package:redux/redux.dart';

final workTypesReducer = combineReducers<Iterable<WorkTypeState>>([
  TypedReducer<Iterable<WorkTypeState>, LoadWorkTypesSuccessAction>(_loadWorkTypesSuccessAction),
]);

Iterable<WorkTypeState> _loadWorkTypesSuccessAction(
  Iterable<WorkTypeState> state,
  LoadWorkTypesSuccessAction action,
) {
  if (action.workTypes != null) {
    state = action.workTypes;
  }
  return state;
}
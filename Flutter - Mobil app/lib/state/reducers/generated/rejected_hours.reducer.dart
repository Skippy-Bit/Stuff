import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/rejected_hour_state.dart';
import 'package:redux/redux.dart';

final rejectedHoursReducer = combineReducers<Iterable<RejectedHourState>>([
  TypedReducer<Iterable<RejectedHourState>, LoadRejectedHoursSuccessAction>(_loadRejectedHoursSuccessAction),
]);

Iterable<RejectedHourState> _loadRejectedHoursSuccessAction(
  Iterable<RejectedHourState> state,
  LoadRejectedHoursSuccessAction action,
) {
  if (action.rejectedHours != null) {
    state = action.rejectedHours;
  }
  return state;
}
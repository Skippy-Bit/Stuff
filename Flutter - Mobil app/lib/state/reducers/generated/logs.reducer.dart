import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/log_state.dart';
import 'package:redux/redux.dart';

final logsReducer = combineReducers<Iterable<LogState>>([
  TypedReducer<Iterable<LogState>, LoadLogsSuccessAction>(_loadLogsSuccessAction),
]);

Iterable<LogState> _loadLogsSuccessAction(
  Iterable<LogState> state,
  LoadLogsSuccessAction action,
) {
  if (action.logs != null) {
    state = action.logs;
  }
  return state;
}
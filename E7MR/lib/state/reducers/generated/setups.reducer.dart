import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/setup_state.dart';
import 'package:redux/redux.dart';

final setupsReducer = combineReducers<Iterable<SetupState>>([
  TypedReducer<Iterable<SetupState>, LoadSetupsSuccessAction>(_loadSetupsSuccessAction),
]);

Iterable<SetupState> _loadSetupsSuccessAction(
  Iterable<SetupState> state,
  LoadSetupsSuccessAction action,
) {
  if (action.setups != null) {
    state = action.setups;
  }
  return state;
}
import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/user_setup_state.dart';
import 'package:redux/redux.dart';

final userSetupsReducer = combineReducers<Iterable<UserSetupState>>([
  TypedReducer<Iterable<UserSetupState>, LoadUserSetupsSuccessAction>(_loadUserSetupsSuccessAction),
]);

Iterable<UserSetupState> _loadUserSetupsSuccessAction(
  Iterable<UserSetupState> state,
  LoadUserSetupsSuccessAction action,
) {
  if (action.userSetups != null) {
    state = action.userSetups;
  }
  return state;
}
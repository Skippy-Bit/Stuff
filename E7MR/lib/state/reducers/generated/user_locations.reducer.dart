import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/user_location_state.dart';
import 'package:redux/redux.dart';

final userLocationsReducer = combineReducers<Iterable<UserLocationState>>([
  TypedReducer<Iterable<UserLocationState>, LoadUserLocationsSuccessAction>(_loadUserLocationsSuccessAction),
]);

Iterable<UserLocationState> _loadUserLocationsSuccessAction(
  Iterable<UserLocationState> state,
  LoadUserLocationsSuccessAction action,
) {
  if (action.userLocations != null) {
    state = action.userLocations;
  }
  return state;
}
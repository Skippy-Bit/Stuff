import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/location_state.dart';
import 'package:redux/redux.dart';

final locationsReducer = combineReducers<Iterable<LocationState>>([
  TypedReducer<Iterable<LocationState>, LoadLocationsSuccessAction>(_loadLocationsSuccessAction),
]);

Iterable<LocationState> _loadLocationsSuccessAction(
  Iterable<LocationState> state,
  LoadLocationsSuccessAction action,
) {
  if (action.locations != null) {
    state = action.locations;
  }
  return state;
}
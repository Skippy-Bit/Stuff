import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/state_status.dart';
import 'package:redux/redux.dart';

final locationStateStatusReducer = combineReducers<StateStatus>([
  TypedReducer<StateStatus, LoadLocationsBeginAction>(_loadLocationsBeginAction),
  TypedReducer<StateStatus, LoadLocationsSuccessAction>(_loadLocationsSuccessAction),
  TypedReducer<StateStatus, LoadLocationsFailedAction>(_loadLocationsFailedAction),
]);

StateStatus _loadLocationsBeginAction(
  StateStatus state,
  LoadLocationsBeginAction action,
) {
  state = StateStatus.loading(
    lastUpdated: state.lastUpdated,
    queryDistinct: state.queryDistinct,
    queryWhere: state.queryWhere,
    queryWhereArgs: state.queryWhereArgs,
    queryGroupBy: state.queryGroupBy,
    queryHaving: state.queryHaving,
    queryOrderBy: state.queryOrderBy,
    queryLimit: state.queryLimit,
    queryOffset: state.queryOffset,
    progressMessage: 'Laster lokasjoner',
  );
  return state;
}

StateStatus _loadLocationsSuccessAction(
  StateStatus state,
  LoadLocationsSuccessAction action,
) {
  if (action.locations == null) {
    state = state.isEmpty
        ? StateStatus.empty(
            lastUpdated: state.lastUpdated,
            queryDistinct: state.queryDistinct,
            queryWhere: state.queryWhere,
            queryWhereArgs: state.queryWhereArgs,
            queryGroupBy: state.queryGroupBy,
            queryHaving: state.queryHaving,
            queryOrderBy: state.queryOrderBy,
            queryLimit: state.queryLimit,
            queryOffset: state.queryOffset,
          )
        : StateStatus.loaded(
            lastUpdated: DateTime.now(),
            queryDistinct: state.queryDistinct,
            queryWhere: state.queryWhere,
            queryWhereArgs: state.queryWhereArgs,
            queryGroupBy: state.queryGroupBy,
            queryHaving: state.queryHaving,
            queryOrderBy: state.queryOrderBy,
            queryLimit: state.queryLimit,
            queryOffset: state.queryOffset,
          );
  } else if (action.locations.isEmpty) {
    state = StateStatus.empty(
      lastUpdated: state.lastUpdated,
      queryDistinct: action.queryDistinct,
      queryWhere: action.queryWhere,
      queryWhereArgs: action.queryWhereArgs,
      queryGroupBy: action.queryGroupBy,
      queryHaving: action.queryHaving,
      queryOrderBy: action.queryOrderBy,
      queryLimit: action.queryLimit,
      queryOffset: action.queryOffset,
    );
  } else {
    state = StateStatus.loaded(
      lastUpdated: DateTime.now(),
      queryDistinct: action.queryDistinct,
      queryWhere: action.queryWhere,
      queryWhereArgs: action.queryWhereArgs,
      queryGroupBy: action.queryGroupBy,
      queryHaving: action.queryHaving,
      queryOrderBy: action.queryOrderBy,
      queryLimit: action.queryLimit,
      queryOffset: action.queryOffset,
    );
  }
  return state;
}

StateStatus _loadLocationsFailedAction(
  StateStatus state,
  LoadLocationsFailedAction action,
) {
  state = StateStatus.err(
    action.error,
    lastUpdated: state.lastUpdated,
    queryDistinct: state.queryDistinct,
    queryWhere: state.queryWhere,
    queryWhereArgs: state.queryWhereArgs,
    queryGroupBy: state.queryGroupBy,
    queryHaving: state.queryHaving,
    queryOrderBy: state.queryOrderBy,
    queryLimit: state.queryLimit,
    queryOffset: state.queryOffset,
  );
  return state;
}
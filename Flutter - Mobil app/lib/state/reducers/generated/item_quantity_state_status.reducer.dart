import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/state_status.dart';
import 'package:redux/redux.dart';

final itemQuantityStateStatusReducer = combineReducers<StateStatus>([
  TypedReducer<StateStatus, LoadItemQuantitiesBeginAction>(_loadItemQuantitiesBeginAction),
  TypedReducer<StateStatus, LoadItemQuantitiesSuccessAction>(_loadItemQuantitiesSuccessAction),
  TypedReducer<StateStatus, LoadItemQuantitiesFailedAction>(_loadItemQuantitiesFailedAction),
]);

StateStatus _loadItemQuantitiesBeginAction(
  StateStatus state,
  LoadItemQuantitiesBeginAction action,
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
    progressMessage: 'Laster varebeholdning',
  );
  return state;
}

StateStatus _loadItemQuantitiesSuccessAction(
  StateStatus state,
  LoadItemQuantitiesSuccessAction action,
) {
  if (action.itemQuantities == null) {
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
  } else if (action.itemQuantities.isEmpty) {
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

StateStatus _loadItemQuantitiesFailedAction(
  StateStatus state,
  LoadItemQuantitiesFailedAction action,
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
import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/state_status.dart';
import 'package:redux/redux.dart';

final userSetupStateStatusReducer = combineReducers<StateStatus>([
  TypedReducer<StateStatus, LoadUserSetupsBeginAction>(_loadUserSetupsBeginAction),
  TypedReducer<StateStatus, LoadUserSetupsSuccessAction>(_loadUserSetupsSuccessAction),
  TypedReducer<StateStatus, LoadUserSetupsFailedAction>(_loadUserSetupsFailedAction),
]);

StateStatus _loadUserSetupsBeginAction(
  StateStatus state,
  LoadUserSetupsBeginAction action,
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
    progressMessage: 'Laster brukeroppsett',
  );
  return state;
}

StateStatus _loadUserSetupsSuccessAction(
  StateStatus state,
  LoadUserSetupsSuccessAction action,
) {
  if (action.userSetups == null) {
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
  } else if (action.userSetups.isEmpty) {
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

StateStatus _loadUserSetupsFailedAction(
  StateStatus state,
  LoadUserSetupsFailedAction action,
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
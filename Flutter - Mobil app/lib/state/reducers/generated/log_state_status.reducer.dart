import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/state_status.dart';
import 'package:redux/redux.dart';

final logStateStatusReducer = combineReducers<StateStatus>([
  TypedReducer<StateStatus, LoadLogsBeginAction>(_loadLogsBeginAction),
  TypedReducer<StateStatus, LoadLogsSuccessAction>(_loadLogsSuccessAction),
  TypedReducer<StateStatus, LoadLogsFailedAction>(_loadLogsFailedAction),
]);

StateStatus _loadLogsBeginAction(
  StateStatus state,
  LoadLogsBeginAction action,
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
    progressMessage: 'Laster loggposter',
  );
  return state;
}

StateStatus _loadLogsSuccessAction(
  StateStatus state,
  LoadLogsSuccessAction action,
) {
  if (action.logs == null) {
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
  } else if (action.logs.isEmpty) {
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

StateStatus _loadLogsFailedAction(
  StateStatus state,
  LoadLogsFailedAction action,
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
import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/state_status.dart';
import 'package:redux/redux.dart';

final jobLedgerEntryStateStatusReducer = combineReducers<StateStatus>([
  TypedReducer<StateStatus, LoadJobLedgerEntriesBeginAction>(_loadJobLedgerEntriesBeginAction),
  TypedReducer<StateStatus, LoadJobLedgerEntriesSuccessAction>(_loadJobLedgerEntriesSuccessAction),
  TypedReducer<StateStatus, LoadJobLedgerEntriesFailedAction>(_loadJobLedgerEntriesFailedAction),
]);

StateStatus _loadJobLedgerEntriesBeginAction(
  StateStatus state,
  LoadJobLedgerEntriesBeginAction action,
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
    progressMessage: 'Laster prosjektposter',
  );
  return state;
}

StateStatus _loadJobLedgerEntriesSuccessAction(
  StateStatus state,
  LoadJobLedgerEntriesSuccessAction action,
) {
  if (action.jobLedgerEntries == null) {
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
  } else if (action.jobLedgerEntries.isEmpty) {
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

StateStatus _loadJobLedgerEntriesFailedAction(
  StateStatus state,
  LoadJobLedgerEntriesFailedAction action,
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
import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/actions/login.actions.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/selectors/connection_state_selectors.dart';
import 'package:e7mr/state/actions/item.actions.dart';
import 'package:redux/redux.dart';

void initialLoadMiddleware(Store<AppState> store, action, NextDispatcher next) {
  next(action);
  if (action is LoginSuccessAction) {
    syncAll(store);
  }
}

void syncAll(Store<AppState> store) {
  final offline = offlineSelector(store.state);
  [
    loadItems(offline: offline),
    loadJobJournalLines(offline: offline),
    loadJobLedgerEntries(offline: offline),
    loadJobPlanningLines(offline: offline),
    loadJobTasks(offline: offline),
    loadJobs(offline: offline),
    loadLocations(offline: offline),
    loadLogs(offline: offline),
    loadRejectedHours(offline: offline),
    loadSetups(offline: offline),
    loadUserLocations(offline: offline),
    loadUserSetups(offline: offline),
    loadWorkTypes(offline: offline),
  ].forEach(store.dispatch);

  if (!offline) {
    [
      postLogs(),
    ].forEach(store.dispatch);
  }
}
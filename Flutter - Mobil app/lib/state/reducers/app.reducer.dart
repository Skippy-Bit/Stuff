import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/reducers/connection_status.reducer.dart';
import 'package:e7mr/state/reducers/auth.reducer.dart';
import 'package:e7mr/state/reducers/item_state_status.reducer.dart';
import 'package:e7mr/state/reducers/items.reducer.dart';
import 'package:e7mr/state/reducers/generated/item_quantity_state_status.reducer.dart';
import 'package:e7mr/state/reducers/generated/job_journal_line_state_status.reducer.dart';
import 'package:e7mr/state/reducers/generated/job_ledger_entry_state_status.reducer.dart';
import 'package:e7mr/state/reducers/generated/job_planning_line_state_status.reducer.dart';
import 'package:e7mr/state/reducers/generated/job_task_state_status.reducer.dart';
import 'package:e7mr/state/reducers/generated/job_state_status.reducer.dart';
import 'package:e7mr/state/reducers/generated/location_state_status.reducer.dart';
import 'package:e7mr/state/reducers/generated/log_state_status.reducer.dart';
import 'package:e7mr/state/reducers/generated/rejected_hour_state_status.reducer.dart';
import 'package:e7mr/state/reducers/generated/setup_state_status.reducer.dart';
import 'package:e7mr/state/reducers/generated/user_location_state_status.reducer.dart';
import 'package:e7mr/state/reducers/generated/user_setup_state_status.reducer.dart';
import 'package:e7mr/state/reducers/generated/work_type_state_status.reducer.dart';
import 'package:e7mr/state/reducers/generated/item_quantities.reducer.dart';
import 'package:e7mr/state/reducers/generated/job_journal_lines.reducer.dart';
import 'package:e7mr/state/reducers/generated/job_ledger_entries.reducer.dart';
import 'package:e7mr/state/reducers/generated/job_planning_lines.reducer.dart';
import 'package:e7mr/state/reducers/generated/job_tasks.reducer.dart';
import 'package:e7mr/state/reducers/generated/jobs.reducer.dart';
import 'package:e7mr/state/reducers/generated/locations.reducer.dart';
import 'package:e7mr/state/reducers/generated/logs.reducer.dart';
import 'package:e7mr/state/reducers/generated/rejected_hours.reducer.dart';
import 'package:e7mr/state/reducers/generated/setups.reducer.dart';
import 'package:e7mr/state/reducers/generated/user_locations.reducer.dart';
import 'package:e7mr/state/reducers/generated/user_setups.reducer.dart';
import 'package:e7mr/state/reducers/generated/work_types.reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    connectionStatus: connectionStatusReducer(state.connectionStatus, action),
    auth: authReducer(state.auth, action),
    itemStateStatus: itemStateStatusReducer(state.itemStateStatus, action),
    itemQuantityStateStatus: itemQuantityStateStatusReducer(state.itemQuantityStateStatus, action),
    jobJournalLineStateStatus: jobJournalLineStateStatusReducer(state.jobJournalLineStateStatus, action),
    jobLedgerEntryStateStatus: jobLedgerEntryStateStatusReducer(state.jobLedgerEntryStateStatus, action),
    jobPlanningLineStateStatus: jobPlanningLineStateStatusReducer(state.jobPlanningLineStateStatus, action),
    jobTaskStateStatus: jobTaskStateStatusReducer(state.jobTaskStateStatus, action),
    jobStateStatus: jobStateStatusReducer(state.jobStateStatus, action),
    locationStateStatus: locationStateStatusReducer(state.locationStateStatus, action),
    logStateStatus: logStateStatusReducer(state.logStateStatus, action),
    rejectedHourStateStatus: rejectedHourStateStatusReducer(state.rejectedHourStateStatus, action),
    setupStateStatus: setupStateStatusReducer(state.setupStateStatus, action),
    userLocationStateStatus: userLocationStateStatusReducer(state.userLocationStateStatus, action),
    userSetupStateStatus: userSetupStateStatusReducer(state.userSetupStateStatus, action),
    workTypeStateStatus: workTypeStateStatusReducer(state.workTypeStateStatus, action),
    items: itemsReducer(state.items, action),
    itemQuantities: itemQuantitiesReducer(state.itemQuantities, action),
    jobJournalLines: jobJournalLinesReducer(state.jobJournalLines, action),
    jobLedgerEntries: jobLedgerEntriesReducer(state.jobLedgerEntries, action),
    jobPlanningLines: jobPlanningLinesReducer(state.jobPlanningLines, action),
    jobTasks: jobTasksReducer(state.jobTasks, action),
    jobs: jobsReducer(state.jobs, action),
    locations: locationsReducer(state.locations, action),
    logs: logsReducer(state.logs, action),
    rejectedHours: rejectedHoursReducer(state.rejectedHours, action),
    setups: setupsReducer(state.setups, action),
    userLocations: userLocationsReducer(state.userLocations, action),
    userSetups: userSetupsReducer(state.userSetups, action),
    workTypes: workTypesReducer(state.workTypes, action),
  );
}

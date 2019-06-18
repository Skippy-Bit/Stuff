import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/state_status.dart';
import 'package:e7mr/state/selectors/item_state_status_selectors.dart';

StateStatus itemQuantityStateStatusSelector(AppState state) =>
    state.itemQuantityStateStatus;
StateStatus jobJournalLineStateStatusSelector(AppState state) =>
    state.jobJournalLineStateStatus;
StateStatus jobLedgerEntryStateStatusSelector(AppState state) =>
    state.jobLedgerEntryStateStatus;
StateStatus jobPlanningLineStateStatusSelector(AppState state) =>
    state.jobPlanningLineStateStatus;
StateStatus jobTaskStateStatusSelector(AppState state) =>
    state.jobTaskStateStatus;
StateStatus jobStateStatusSelector(AppState state) => state.jobStateStatus;
StateStatus locationStateStatusSelector(AppState state) =>
    state.locationStateStatus;
StateStatus logStateStatusSelector(AppState state) => state.logStateStatus;
StateStatus rejectedHourStateStatusSelector(AppState state) =>
    state.rejectedHourStateStatus;
StateStatus setupStateStatusSelector(AppState state) => state.setupStateStatus;
StateStatus userLocationStateStatusSelector(AppState state) =>
    state.userLocationStateStatus;
StateStatus userSetupStateStatusSelector(AppState state) =>
    state.userSetupStateStatus;
StateStatus workTypeStateStatusSelector(AppState state) =>
    state.workTypeStateStatus;
bool isLoadingStateStatusSelector(AppState state) => [
      itemQuantityStateStatusSelector(state),
      jobJournalLineStateStatusSelector(state),
      jobLedgerEntryStateStatusSelector(state),
      jobPlanningLineStateStatusSelector(state),
      jobTaskStateStatusSelector(state),
      jobStateStatusSelector(state),
      locationStateStatusSelector(state),
      logStateStatusSelector(state),
      rejectedHourStateStatusSelector(state),
      setupStateStatusSelector(state),
      userLocationStateStatusSelector(state),
      userSetupStateStatusSelector(state),
      workTypeStateStatusSelector(state),
      itemStateStatusSelector(state),
    ].any((status) => status.isLoading);

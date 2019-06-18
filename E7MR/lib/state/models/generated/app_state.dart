import 'package:meta/meta.dart';
import 'package:e7mr/state/models/connection_status.dart';
import 'package:e7mr/state/models/auth_state.dart';
import 'package:e7mr/state/models/state_status.dart';
import 'package:e7mr/state/models/item_state.dart';
import 'package:e7mr/state/models/generated/item_quantity_state.dart';
import 'package:e7mr/state/models/generated/job_journal_line_state.dart';
import 'package:e7mr/state/models/generated/job_ledger_entry_state.dart';
import 'package:e7mr/state/models/generated/job_planning_line_state.dart';
import 'package:e7mr/state/models/generated/job_task_state.dart';
import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/state/models/generated/location_state.dart';
import 'package:e7mr/state/models/generated/log_state.dart';
import 'package:e7mr/state/models/generated/rejected_hour_state.dart';
import 'package:e7mr/state/models/generated/setup_state.dart';
import 'package:e7mr/state/models/generated/user_location_state.dart';
import 'package:e7mr/state/models/generated/user_setup_state.dart';
import 'package:e7mr/state/models/generated/work_type_state.dart';

@immutable
class AppState {
  final ConnectionStatus connectionStatus;
  final AuthState auth;
  final StateStatus itemStateStatus;
  final StateStatus itemQuantityStateStatus;
  final StateStatus jobJournalLineStateStatus;
  final StateStatus jobLedgerEntryStateStatus;
  final StateStatus jobPlanningLineStateStatus;
  final StateStatus jobTaskStateStatus;
  final StateStatus jobStateStatus;
  final StateStatus locationStateStatus;
  final StateStatus logStateStatus;
  final StateStatus rejectedHourStateStatus;
  final StateStatus setupStateStatus;
  final StateStatus userLocationStateStatus;
  final StateStatus userSetupStateStatus;
  final StateStatus workTypeStateStatus;
  final Iterable<ItemState> items;
  final Iterable<ItemQuantityState> itemQuantities;
  final Iterable<JobJournalLineState> jobJournalLines;
  final Iterable<JobLedgerEntryState> jobLedgerEntries;
  final Iterable<JobPlanningLineState> jobPlanningLines;
  final Iterable<JobTaskState> jobTasks;
  final Iterable<JobState> jobs;
  final Iterable<LocationState> locations;
  final Iterable<LogState> logs;
  final Iterable<RejectedHourState> rejectedHours;
  final Iterable<SetupState> setups;
  final Iterable<UserLocationState> userLocations;
  final Iterable<UserSetupState> userSetups;
  final Iterable<WorkTypeState> workTypes;

  AppState({
    ConnectionStatus connectionStatus,
    AuthState auth,
    StateStatus itemStateStatus,
    StateStatus itemQuantityStateStatus,
    StateStatus jobJournalLineStateStatus,
    StateStatus jobLedgerEntryStateStatus,
    StateStatus jobPlanningLineStateStatus,
    StateStatus jobTaskStateStatus,
    StateStatus jobStateStatus,
    StateStatus locationStateStatus,
    StateStatus logStateStatus,
    StateStatus rejectedHourStateStatus,
    StateStatus setupStateStatus,
    StateStatus userLocationStateStatus,
    StateStatus userSetupStateStatus,
    StateStatus workTypeStateStatus,
    this.items = const Iterable.empty(),
    this.itemQuantities = const Iterable.empty(),
    this.jobJournalLines = const Iterable.empty(),
    this.jobLedgerEntries = const Iterable.empty(),
    this.jobPlanningLines = const Iterable.empty(),
    this.jobTasks = const Iterable.empty(),
    this.jobs = const Iterable.empty(),
    this.locations = const Iterable.empty(),
    this.logs = const Iterable.empty(),
    this.rejectedHours = const Iterable.empty(),
    this.setups = const Iterable.empty(),
    this.userLocations = const Iterable.empty(),
    this.userSetups = const Iterable.empty(),
    this.workTypes = const Iterable.empty(),
  })  : connectionStatus = connectionStatus ?? ConnectionStatus.disconnected(),
        auth = auth ?? AuthState(),
        itemStateStatus = itemStateStatus ?? StateStatus.empty(),
        itemQuantityStateStatus = itemQuantityStateStatus ?? StateStatus.empty(),
        jobJournalLineStateStatus = jobJournalLineStateStatus ?? StateStatus.empty(),
        jobLedgerEntryStateStatus = jobLedgerEntryStateStatus ?? StateStatus.empty(),
        jobPlanningLineStateStatus = jobPlanningLineStateStatus ?? StateStatus.empty(),
        jobTaskStateStatus = jobTaskStateStatus ?? StateStatus.empty(),
        jobStateStatus = jobStateStatus ?? StateStatus.empty(),
        locationStateStatus = locationStateStatus ?? StateStatus.empty(),
        logStateStatus = logStateStatus ?? StateStatus.empty(),
        rejectedHourStateStatus = rejectedHourStateStatus ?? StateStatus.empty(),
        setupStateStatus = setupStateStatus ?? StateStatus.empty(),
        userLocationStateStatus = userLocationStateStatus ?? StateStatus.empty(),
        userSetupStateStatus = userSetupStateStatus ?? StateStatus.empty(),
        workTypeStateStatus = workTypeStateStatus ?? StateStatus.empty();

  AppState copyWith({
    ConnectionStatus connectionStatus,
    AuthState auth,
    StateStatus itemStateStatus,
    StateStatus itemQuantityStateStatus,
    StateStatus jobJournalLineStateStatus,
    StateStatus jobLedgerEntryStateStatus,
    StateStatus jobPlanningLineStateStatus,
    StateStatus jobTaskStateStatus,
    StateStatus jobStateStatus,
    StateStatus locationStateStatus,
    StateStatus logStateStatus,
    StateStatus rejectedHourStateStatus,
    StateStatus setupStateStatus,
    StateStatus userLocationStateStatus,
    StateStatus userSetupStateStatus,
    StateStatus workTypeStateStatus,
    Iterable<ItemState> items,
    Iterable<ItemQuantityState> itemQuantities,
    Iterable<JobJournalLineState> jobJournalLines,
    Iterable<JobLedgerEntryState> jobLedgerEntries,
    Iterable<JobPlanningLineState> jobPlanningLines,
    Iterable<JobTaskState> jobTasks,
    Iterable<JobState> jobs,
    Iterable<LocationState> locations,
    Iterable<LogState> logs,
    Iterable<RejectedHourState> rejectedHours,
    Iterable<SetupState> setups,
    Iterable<UserLocationState> userLocations,
    Iterable<UserSetupState> userSetups,
    Iterable<WorkTypeState> workTypes,
  }) {
    return AppState(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      auth: auth ?? this.auth,
      itemStateStatus: itemStateStatus ?? this.itemStateStatus,
      itemQuantityStateStatus: itemQuantityStateStatus ?? this.itemQuantityStateStatus,
      jobJournalLineStateStatus: jobJournalLineStateStatus ?? this.jobJournalLineStateStatus,
      jobLedgerEntryStateStatus: jobLedgerEntryStateStatus ?? this.jobLedgerEntryStateStatus,
      jobPlanningLineStateStatus: jobPlanningLineStateStatus ?? this.jobPlanningLineStateStatus,
      jobTaskStateStatus: jobTaskStateStatus ?? this.jobTaskStateStatus,
      jobStateStatus: jobStateStatus ?? this.jobStateStatus,
      locationStateStatus: locationStateStatus ?? this.locationStateStatus,
      logStateStatus: logStateStatus ?? this.logStateStatus,
      rejectedHourStateStatus: rejectedHourStateStatus ?? this.rejectedHourStateStatus,
      setupStateStatus: setupStateStatus ?? this.setupStateStatus,
      userLocationStateStatus: userLocationStateStatus ?? this.userLocationStateStatus,
      userSetupStateStatus: userSetupStateStatus ?? this.userSetupStateStatus,
      workTypeStateStatus: workTypeStateStatus ?? this.workTypeStateStatus,
      items: items ?? this.items,
      itemQuantities: itemQuantities ?? this.itemQuantities,
      jobJournalLines: jobJournalLines ?? this.jobJournalLines,
      jobLedgerEntries: jobLedgerEntries ?? this.jobLedgerEntries,
      jobPlanningLines: jobPlanningLines ?? this.jobPlanningLines,
      jobTasks: jobTasks ?? this.jobTasks,
      jobs: jobs ?? this.jobs,
      locations: locations ?? this.locations,
      logs: logs ?? this.logs,
      rejectedHours: rejectedHours ?? this.rejectedHours,
      setups: setups ?? this.setups,
      userLocations: userLocations ?? this.userLocations,
      userSetups: userSetups ?? this.userSetups,
      workTypes: workTypes ?? this.workTypes,
    );
  }

  @override
  int get hashCode =>
      connectionStatus.hashCode ^
      auth.hashCode ^
      itemStateStatus.hashCode ^
      itemQuantityStateStatus.hashCode ^
      jobJournalLineStateStatus.hashCode ^
      jobLedgerEntryStateStatus.hashCode ^
      jobPlanningLineStateStatus.hashCode ^
      jobTaskStateStatus.hashCode ^
      jobStateStatus.hashCode ^
      locationStateStatus.hashCode ^
      logStateStatus.hashCode ^
      rejectedHourStateStatus.hashCode ^
      setupStateStatus.hashCode ^
      userLocationStateStatus.hashCode ^
      userSetupStateStatus.hashCode ^
      workTypeStateStatus.hashCode ^
      items.hashCode ^
      itemQuantities.hashCode ^
      jobJournalLines.hashCode ^
      jobLedgerEntries.hashCode ^
      jobPlanningLines.hashCode ^
      jobTasks.hashCode ^
      jobs.hashCode ^
      locations.hashCode ^
      logs.hashCode ^
      rejectedHours.hashCode ^
      setups.hashCode ^
      userLocations.hashCode ^
      userSetups.hashCode ^
      workTypes.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          connectionStatus == other.connectionStatus &&
          auth == other.auth &&
          itemStateStatus == other.itemStateStatus &&
          itemQuantityStateStatus == other.itemQuantityStateStatus &&
          jobJournalLineStateStatus == other.jobJournalLineStateStatus &&
          jobLedgerEntryStateStatus == other.jobLedgerEntryStateStatus &&
          jobPlanningLineStateStatus == other.jobPlanningLineStateStatus &&
          jobTaskStateStatus == other.jobTaskStateStatus &&
          jobStateStatus == other.jobStateStatus &&
          locationStateStatus == other.locationStateStatus &&
          logStateStatus == other.logStateStatus &&
          rejectedHourStateStatus == other.rejectedHourStateStatus &&
          setupStateStatus == other.setupStateStatus &&
          userLocationStateStatus == other.userLocationStateStatus &&
          userSetupStateStatus == other.userSetupStateStatus &&
          workTypeStateStatus == other.workTypeStateStatus &&
          items == other.items &&
          itemQuantities == other.itemQuantities &&
          jobJournalLines == other.jobJournalLines &&
          jobLedgerEntries == other.jobLedgerEntries &&
          jobPlanningLines == other.jobPlanningLines &&
          jobTasks == other.jobTasks &&
          jobs == other.jobs &&
          locations == other.locations &&
          logs == other.logs &&
          rejectedHours == other.rejectedHours &&
          setups == other.setups &&
          userLocations == other.userLocations &&
          userSetups == other.userSetups &&
          workTypes == other.workTypes;

  @override
  String toString() {
    return 'AppState{connectionStatus: $connectionStatus, auth: $auth, items: $items, itemQuantities: $itemQuantities, jobJournalLines: $jobJournalLines, jobLedgerEntries: $jobLedgerEntries, jobPlanningLines: $jobPlanningLines, jobTasks: $jobTasks, jobs: $jobs, locations: $locations, logs: $logs, rejectedHours: $rejectedHours, setups: $setups, userLocations: $userLocations, userSetups: $userSetups, workTypes: $workTypes, itemStateStatus: $itemStateStatus, itemQuantityStateStatus: $itemQuantityStateStatus, jobJournalLineStateStatus: $jobJournalLineStateStatus, jobLedgerEntryStateStatus: $jobLedgerEntryStateStatus, jobPlanningLineStateStatus: $jobPlanningLineStateStatus, jobTaskStateStatus: $jobTaskStateStatus, jobStateStatus: $jobStateStatus, locationStateStatus: $locationStateStatus, logStateStatus: $logStateStatus, rejectedHourStateStatus: $rejectedHourStateStatus, setupStateStatus: $setupStateStatus, userLocationStateStatus: $userLocationStateStatus, userSetupStateStatus: $userSetupStateStatus, workTypeStateStatus: $workTypeStateStatus}';
  }
}
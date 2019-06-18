import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/user_setup_state.dart';

Iterable<UserSetupState> userSetupsSelector(AppState state) => state.userSetups;

UserSetupState userSetupSelector(AppState state) =>
    userSetupsSelector(state).first;

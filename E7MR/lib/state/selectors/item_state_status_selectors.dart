import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/state_status.dart';

StateStatus itemStateStatusSelector(AppState state) => state.itemStateStatus;

import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/connection_status.dart';

ConnectionStatus connectionStateSelector(AppState state) =>
    state.connectionStatus;

bool offlineSelector(AppState state) =>
    !connectionStateSelector(state).isConnected;

bool isWifiSelector(AppState state) => connectionStateSelector(state).wifi;

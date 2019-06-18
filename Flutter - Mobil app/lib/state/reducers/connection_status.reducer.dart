import 'package:e7mr/state/actions/connection_status.actions.dart';
import 'package:e7mr/state/models/connection_status.dart';
import 'package:redux/redux.dart';

final connectionStatusReducer = combineReducers<ConnectionStatus>([
  TypedReducer<ConnectionStatus, ConnectionStatusAction>(
      _connectionStatusAction),
]);

ConnectionStatus _connectionStatusAction(
  ConnectionStatus state,
  ConnectionStatusAction action,
) {
  if (action.connected) {
    state = ConnectionStatus.connected(wifi: action.wifi);
  } else {
    state = ConnectionStatus.disconnected();
  }
  return state;
}

import 'package:connectivity/connectivity.dart';

class ConnectionStatusAction {
  ConnectionStatusAction._internal({
    this.connected = false,
    this.wifi = false,
  });

  factory ConnectionStatusAction.disconnected() =>
      ConnectionStatusAction._internal();
  factory ConnectionStatusAction.isConnected({bool wifi = false}) =>
      ConnectionStatusAction._internal(connected: true, wifi: wifi);

  factory ConnectionStatusAction.fromConnectivityResult(
      ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.none:
        return ConnectionStatusAction.disconnected();
        break;
      case ConnectivityResult.mobile:
        return ConnectionStatusAction.isConnected();
        break;
      case ConnectivityResult.wifi:
        return ConnectionStatusAction.isConnected(wifi: true);
        break;
      default:
        return ConnectionStatusAction.disconnected();
    }
  }

  final bool connected;
  final bool wifi;
  bool get mobile => !wifi;
}

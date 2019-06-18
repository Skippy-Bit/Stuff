import 'package:meta/meta.dart';

@immutable
class ConnectionStatus {
  ConnectionStatus._internal({
    this.isConnected = false,
    this.wifi = false,
  });

  factory ConnectionStatus.disconnected() => ConnectionStatus._internal();
  factory ConnectionStatus.connected({bool wifi}) =>
      ConnectionStatus._internal(isConnected: true, wifi: wifi);

  final bool isConnected;
  final bool wifi;
  bool get mobile => !wifi;
}

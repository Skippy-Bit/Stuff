import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:e7mr/state/actions/connection_status.actions.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ConnectionStatusUpdater extends StatefulWidget {
  final Widget child;
  ConnectionStatusUpdater({Key key, this.child}) : super(key: key);

  @override
  _ConnectionStatusUpdaterState createState() =>
      _ConnectionStatusUpdaterState();
}

class _ConnectionStatusUpdaterState extends State<ConnectionStatusUpdater> {
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    subscription =
        Connectivity().onConnectivityChanged.listen(onConnectivityChanged);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void onConnectivityChanged(ConnectivityResult result) {
    if (this.mounted) {
      Store<AppState> store = StoreProvider.of<AppState>(context);
      assert(store != null);
      store.dispatch(ConnectionStatusAction.fromConnectivityResult(result));
    }
  }
}

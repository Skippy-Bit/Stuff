import 'package:connectivity/connectivity.dart';
import 'package:e7mr/state/actions/connection_status.actions.dart';
import 'package:e7mr/state/actions/login.actions.dart';
import 'package:e7mr/state/middleware/middleware_context.dart';
import 'package:e7mr/state/middleware/store_middleware.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/reducers/app.reducer.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import 'package:sqflite/sqflite.dart';

Store<AppState> createStore(
        Database db, GlobalKey<NavigatorState> navigatorKey) =>
    Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: createStoreMiddleware(MiddlewareContext(db, navigatorKey)),
    );

initializeStore(Store<AppState> store) async {
  // Initial Connection Status
  final connectivityResult = await Connectivity().checkConnectivity();
  store.dispatch(
      ConnectionStatusAction.fromConnectivityResult(connectivityResult));

  store.dispatch(new CheckStoredCredentialsAction());
}

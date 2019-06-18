// import 'package:background_fetch/background_fetch.dart';
import 'package:e7mr/e7mr_theme.dart';
import 'package:e7mr/lifecycle.dart';
import 'package:e7mr/routes.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/store.dart';
import 'package:e7mr/utils/db.util.dart';
import 'package:e7mr/widgets/connection_status_updater.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // Initialize services and database connections,
  // before running the app.
  Intl.defaultLocale = 'no';
  await initializeDateFormatting('no');

  final db = await DbUtil.db;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  final store = createStore(db, navigatorKey);
  await initializeStore(store);

  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  runApp(MyApp(
    store: store,
    navigatorKey: navigatorKey,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({
    Key key,
    @required this.store,
    @required this.navigatorKey,
  }) : super(key: key);

  final Store<AppState> store;
  final GlobalKey<NavigatorState> navigatorKey;

  final _theme = ThemeData(
    primarySwatch: E7MRTheme.secondary,
    accentColor: E7MRTheme.primary,
  );

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = _errorWidgetBuilder;

    return StoreProvider<AppState>(
      store: store,
      child: ConnectionStatusUpdater(
        child: Lifecycle(
          child: _buildMain(),
        ),
      ),
    );
  }

  Widget _buildMain() {
    return MaterialApp(
      title: 'Montørrollen',
      theme: _theme,
      navigatorKey: navigatorKey,
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _errorWidgetBuilder(FlutterErrorDetails errorDetails) {
    return Center(
      child: Text(
        "Error appeared.",
        style: _theme.textTheme.title.copyWith(color: Colors.grey),
      ),
    );
  }
}

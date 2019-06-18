import 'package:e7mr/pages/hour_view/hour_overview.dart';
import 'package:e7mr/pages/item_relocation/item_relocation.dart';
import 'package:e7mr/pages/job/job_list.dart';
import 'package:e7mr/state/actions/login.actions.dart';
import 'package:e7mr/state/middleware/generated/initial_load.middleware.dart';
import 'package:e7mr/state/models/credentials.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/state_status.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/state/selectors/item_state_status_selectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabData {
  TabData({this.text, this.icon, this.tabView});

  final String text;
  final Widget icon;
  final Widget tabView;
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.initialTabIndex = 0}) : super(key: key);

  final String title;
  final int initialTabIndex;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController tabController;
  final Key jobPosKey = PageStorageKey('Prosjekt');
  final Key hoursPosKey = PageStorageKey('Mine timer');

  List<TabData> _tabData;
  List<TabData> get _tabs {
    if (_tabData == null) {
      // Lazy-initialize these once. Most likely in initState.
      // This means that the disabled tabs should be passed to the HomePage constructor (if you want to disable any tabs).
      // The reason for initializing them once, is so that the tab controller stays the same. Don't know if that's needed though. You decide.
      _tabData = [
        TabData(
          icon: Icon(Icons.assignment),
          text: 'Prosjekt',
          tabView: JobListPage(
            key: jobPosKey,
          ),
        ),
        TabData(
          icon: Icon(Icons.access_time),
          text: 'Mine timer',
          tabView: HourViewPage(
            key: hoursPosKey,
          ),
        ),
        TabData(
          icon: Icon(Icons.move_to_inbox),
          text: 'Flytt vare',
          tabView: ItemRelocationPage(),
        ),
      ];
    }
    return _tabData;
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: widget.initialTabIndex,
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.title ?? ''),
        bottom: TabBar(
          controller: tabController,
          tabs:
              _tabs.map((tab) => Tab(text: tab.text, icon: tab.icon)).toList(),
        ),
        actions: <Widget>[
          StoreBuilder<AppState>(
            rebuildOnChange: false,
            builder: (context, store) => IconButton(
                  icon: Icon(Icons.refresh),
                  tooltip: 'Refresh',
                  onPressed: () {
                    final isLoading = [
                      jobStateStatusSelector(store.state),
                      jobJournalLineStateStatusSelector(store.state),
                      itemStateStatusSelector(store.state),
                    ]
                        .map((status) => status.isLoading)
                        .reduce((v, e) => v || e);
                    if (!isLoading) {
                      syncAll(store);
                    }
                  },
                ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            StoreConnector<AppState, Credentials>(
              converter: (store) => credentialsSelector(store.state),
              ignoreChange: (state) => isLoadingStateStatusSelector(state),
              builder: (context, credentials) => UserAccountsDrawerHeader(
                    accountName: Text(credentials?.username ?? ''),
                    accountEmail: Text(credentials?.company ?? ''),
                    currentAccountPicture: CircleAvatar(
                      child: ImageIcon(
                        AssetImage('assets/icon/icon_512.png'),
                      ),
                    ),
                  ),
            ),
            ListTile(
              title: Text('Tøm hurtiglager'),
              leading: Icon(Icons.cached),
              onTap: () async {
                final sharedPrefs = await SharedPreferences.getInstance();
                sharedPrefs.remove('PACKAGE_NO_27');
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Text('Logg ut'),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () {
                    final store = StoreProvider.of<AppState>(context);
                    store.dispatch(LogoutAction());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: StoreConnector<AppState, List<StateStatus>>(
        converter: (Store<AppState> store) => [
              jobStateStatusSelector(store.state),
              jobJournalLineStateStatusSelector(store.state),
              itemStateStatusSelector(store.state)
            ],
        builder: (context, statuses) {
          return Stack(
            children: _buildStackChildren(statuses).toList(),
          );
        },
      ),
    );
  }

  Iterable<Widget> _buildStackChildren(List<StateStatus> statuses) sync* {
    final tabBarView = TabBarView(
      controller: tabController,
      children: _tabs.map((tab) => tab.tabView).toList(),
    );

    if (_isLoading(statuses)) {
      yield IgnorePointer(
        child: Container(
          color: Color.fromARGB(100, 0, 0, 0),
          child: tabBarView,
        ),
      );
      yield Center(
        heightFactor: 1.5,
        child: FractionallySizedBox(
          heightFactor: 0.4,
          widthFactor: 0.8,
          child: Card(
            margin: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CircularProgressIndicator(),
                Text(_getProgressMessage(statuses) ?? ''),
              ],
            ),
          ),
        ),
      );
    } else {
      yield tabBarView;
    }
  }

  bool _isLoading(List<StateStatus> statuses) {
    if (statuses == null) {
      return false;
    }
    return statuses.any((s) => s.isLoading);
  }

  String _getProgressMessage(List<StateStatus> statuses) {
    return statuses
        .firstWhere((status) => status.isLoading && status.inProgress,
            orElse: () => null)
        ?.progressMessage;
  }
}

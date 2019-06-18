import 'package:flutter/material.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/state_status.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

typedef StateStatus StateStatusSelectorDelegate(AppState state);

class E7MRTabs {
  E7MRTabs({
    this.tabs,
    this.statusSelectors,
  }) {
    _tabViews = tabs.map((t) => t.view).toList();
    _tabBarView = TabBarView(children: _tabViews);
  }

  final List<E7MRTab> tabs;
  final List<StateStatusSelectorDelegate> statusSelectors;

  List<Widget> _tabViews;
  TabBarView _tabBarView;

  int get length {
    assert(tabs != null);
    return tabs.length;
  }

  TabBar get tabBar => TabBar(tabs: tabs.map((t) => t.tab).toList());

  Widget get body => StoreConnector<AppState, List<StateStatus>>(
        converter: (Store<AppState> store) {
          return statusSelectors.map((s) => s(store.state)).toList();
        },
        builder: (context, statuses) {
          return _buildStack(statuses);
        },
      );

  Widget _buildStack(List<StateStatus> statuses) {
    return Stack(
      children: _buildStackChildren(statuses).toList(),
    );
  }

  Iterable<Widget> _buildStackChildren(List<StateStatus> statuses) sync* {
    if (_isLoading(statuses)) {
      yield IgnorePointer(
        child: Container(
          color: Color.fromARGB(100, 0, 0, 0),
          child: _tabBarView,
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
      yield _tabBarView;
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

class E7MRTab {
  E7MRTab({
    this.text,
    this.icon,
    this.view,
  });

  final String text;
  final IconData icon;
  final Widget view;

  Tab get tab => Tab(text: text, icon: Icon(icon));
}

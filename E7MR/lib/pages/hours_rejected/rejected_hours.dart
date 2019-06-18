import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/rejected_hour_state.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/utils/db.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class RejectedHoursPage extends StatefulWidget {
  RejectedHoursPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _RejectedHourPageState();
}

class _RejectedHourPageState extends State<RejectedHoursPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<RejectedHourState>> getModels(BuildContext context) async {
    if (!this.mounted) {
      return List<RejectedHourState>();
    }
    final store = StoreProvider.of<AppState>(context);
    final user = userSelector(store.state);
    if (user != null && user.username.isNotEmpty) {
      final db = await DbUtil.db;
      var where = 'User = ?';
      var whereArgs = [user.username];
      return (await queryRejectedHoursDirect(db,
              where: where, whereArgs: whereArgs))
          .toList();
    }
    return List<RejectedHourState>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StoreConnector<AppState, void>(
        converter: (store) {},
        ignoreChange: (state) => isLoadingStateStatusSelector(state),
        builder: (context, _) => FutureBuilder<List<RejectedHourState>>(
              future: getModels(context),
              initialData: List<RejectedHourState>(),
              builder: (context, snapshot) {
                final items = _groupListItems(snapshot.data);
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      items[index],
                  itemCount: items?.length ?? 0,
                  physics: const AlwaysScrollableScrollPhysics(),
                );
              },
            ),
      ),
    );
  }

  List<Widget> _groupListItems(Iterable<RejectedHourState> lines) {
    if (lines == null) {
      return List();
    }
    return lines.map((line) => RejectedHourEntry(line)).toList();
  }
}

class RejectedHourEntry extends StatelessWidget {
  const RejectedHourEntry(
    this.hour, {
    Key key,
  }) : super(key: key);

  final RejectedHourState hour;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: PageStorageKey<String>(hour.guid),
      title: _title,
      onTap: () {
        // TODO
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => JobHourRegPage()),
        // );
      },
    );
  }

  Widget get _title {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                hour.jobNo + ' - ' + hour.jobTaskNo,
                textScaleFactor: 0.9,
              ),
              Text(hour.description),
            ],
          ),
        ),
      ],
    );
  }
}

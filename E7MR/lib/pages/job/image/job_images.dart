import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/actions/log.actions.dart';
import 'package:e7mr/state/actions/log_commands/upload_picture.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/log_state.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/utils/db.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ImageStorage {
  // Future
}

class JobImagePage extends StatefulWidget {
  JobImagePage({
    Key key,
    this.title,
    this.jobNo,
    this.jobTaskNo,
  }) : super(key: key);

  final String title;
  final String jobNo;
  final String jobTaskNo;

  JobImagePageState _state;

  @override
  JobImagePageState createState() {
    _state = JobImagePageState(title: title);
    return _state;
  }
}

class JobImagePageState extends State<JobImagePage> {
  String title;

  JobImagePageState({this.title});

  void initState() {
    super.initState();
  }

  Future<List<LogState>> getPictures(BuildContext context) async {
    final store = StoreProvider.of<AppState>(context);
    final user = userSelector(store.state);
    if (user != null && user.username.isNotEmpty) {
      final where = 'User = ? AND Command = ? AND Hash LIKE ?';
      final whereArgs = [
        user.username,
        UploadPicture.COMMAND,
        UploadPicture.buildSqlLikeHash(
          jobNo: widget.jobNo,
          jobTaskNo: widget.jobTaskNo,
        ),
      ];
      try {
        return (await queryLogsDirect(
          await DbUtil.db,
          where: where,
          whereArgs: whereArgs,
        ))
            .toList();
      } catch (e) {}
    }
    return List<LogState>();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StoreConnector<AppState, void>(
        converter: (store) {},
        ignoreChange: (state) => isLoadingStateStatusSelector(state),
        builder: (context, _) => FutureBuilder<List<LogState>>(
              future: getPictures(context),
              initialData: List<LogState>(),
              builder: (context, snapshot) =>
                  _buildImageGrid(context, snapshot.data),
            ),
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context, List<LogState> logs) {
    return GridView.count(
      crossAxisCount: 3,
      children: _logsToImages(logs).toList(),
    );
  }

  Iterable<Widget> _logsToImages(List<LogState> logs) sync* {
    if (logs == null) {
      return;
    }

    final store = StoreProvider.of<AppState>(context);
    final username = userSelector(store.state)?.username;
    if (username != null && username.isNotEmpty) {
      for (final log in logs) {
        final command =
            UploadPicture.decode(json.decode(utf8.decode(log.content)));
        yield FutureBuilder<Uint8List>(
          initialData: command.picture,
          future: _getLogImageData(command, username, log.uuid),
          builder: (context, snapshot) =>
              snapshot.hasData && snapshot.data.isNotEmpty
                  ? _buildImage(snapshot.data)
                  : _buildImagePlaceholder(),
        );
      }
    }
  }

  Future<Uint8List> _getLogImageData(
    UploadPicture command,
    String username,
    String uuid,
  ) async {
    var picture = command.picture;
    if (picture == null || picture.isEmpty) {
      final db = await DbUtil.db;
      final row = await queryLogExtraContent(db, username, uuid);
      final extraContent = json.decode(utf8.decode(row?.extraContent));
      picture = base64.decode(extraContent['picture']);
    }
    return picture;
  }

  Widget _buildImage(Uint8List data) {
    return Image.memory(data, filterQuality: FilterQuality.low);
  }

  Widget _buildImagePlaceholder() {
    return Container();
  }
}

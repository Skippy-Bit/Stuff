import 'package:e7mr/state/models/item_state.dart';
import 'package:e7mr/utils/db.util.dart';
import 'package:flutter/material.dart';

class ItemSearch extends SearchDelegate<ItemState> {
  ItemSearch({@required this.username});

  final String username;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: () async {
        final db = await DbUtil.db;
        assert(db != null);
        if (username != null && username.isNotEmpty) {
          final likeQuery = '%' + query.replaceAll('%', '') + '%';
          final rows = await db.rawQuery(
              'SELECT * FROM Item WHERE User = ? AND (no LIKE ? OR description LIKE ?) LIMIT 50',
              [username, likeQuery, likeQuery]);

          final results = rows.map((row) => ItemState.decodeDB(Map.of(row)));

          return results.toList();
        }
        return List<ItemState>();
      }(),
      builder: (context, AsyncSnapshot<List<ItemState>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final item = snapshot.data[index];
              return ListTile(
                title: Text(item.no),
                subtitle: Text(item.description),
                onTap: () {
                  close(context, item);
                },
              );
            },
          );
        }
        return Container();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: () async {
        if (query == null || query.isEmpty) {
          return null;
        }
        final db = await DbUtil.db;

        if (username != null && username.isNotEmpty) {
          final likeQuery = '%' + query.replaceAll('%', '') + '%';
          final rows = await db.rawQuery(
              'SELECT * FROM Item WHERE User = ? AND (no LIKE ? OR description LIKE ?) LIMIT 50',
              [username, likeQuery, likeQuery]);

          final results = rows.map((row) => ItemState.decodeDB(Map.of(row)));

          return results.toList();
        }
        return List<ItemState>();
      }(),
      builder: (context, AsyncSnapshot<List<ItemState>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final item = snapshot.data[index];
              final no = (item.no ?? '');
              final desc = (item.description ?? '');
              final suggestion = no + (desc.isNotEmpty ? ' - ' + desc : '');
              return ListTile(
                title: Text(suggestion),
                onTap: () {
                  close(context, item);
                },
              );
            },
          );
        }
        return Container();
      },
    );
  }
}

import 'package:e7mr/state/models/generated/field_data.dart';
import 'package:e7mr/widgets/field_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FieldListPage extends StatelessWidget {
  FieldListPage(
    this.fields, {
    Key key,
    this.title,
    this.actions,
  })  : ymdFormatter = DateFormat.yMd(),
        super(key: key) {
    assert(fields != null);
  }

  final String title;
  final List<FieldData> fields;
  final DateFormat ymdFormatter;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: FieldList(fields: fields),
    );
  }
}

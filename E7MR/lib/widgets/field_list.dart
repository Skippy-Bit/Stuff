import 'package:e7mr/state/models/generated/field_data.dart';
import 'package:e7mr/widgets/field_data_list_tile.dart';
import 'package:flutter/material.dart';

class FieldList extends StatelessWidget {
  const FieldList({
    Key key,
    this.fields,
  }) : super(key: key);

  final List<FieldData> fields;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: fields.length,
      itemBuilder: (context, index) => FieldDataListTile(data: fields[index]),
    );
  }
}

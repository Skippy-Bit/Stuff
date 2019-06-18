import 'package:e7mr/state/models/generated/field_data.dart';
import 'package:flutter/material.dart';

class FieldDataListTile extends StatelessWidget {
  const FieldDataListTile({
    Key key,
    this.data,
  }) : super(key: key);

  final FieldData data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data.caption),
      trailing: Text(data.value.toString()),
    );
  }
}

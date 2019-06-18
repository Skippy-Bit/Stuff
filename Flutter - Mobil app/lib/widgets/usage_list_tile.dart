import 'package:e7mr/state/models/generated/field_data.dart';
import 'package:e7mr/widgets/field_list_page.dart';
import 'package:flutter/material.dart';

class UsageListTileModel {
  UsageListTileModel({
    this.title,
    this.subtitle,
    this.description,
    this.trailingTitle,
    this.trailingValue,
    this.detailFields,
    this.actions,
  });

  final String title;
  final String subtitle;
  final String description;
  final String trailingTitle;
  final String trailingValue;
  final List<FieldData> detailFields;
  final List<Widget> actions;

  Widget get titleWidget {
    final children = <Widget>[];
    if (title != null && title.isNotEmpty) {
      children.add(Text(title));
    }
    if (subtitle != null && subtitle.isNotEmpty) {
      children.add(Text(subtitle));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget get subtitleWidget => Text(description ?? '');
}

class UsageListTile extends StatelessWidget {
  final UsageListTileModel model;

  UsageListTile(this.model, {Key key}) : super(key: key) {
    assert(model != null);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: model.titleWidget,
        subtitle: model.subtitleWidget,
        isThreeLine: true,
        trailing: SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      model.trailingTitle ?? '',
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    model.trailingValue ?? '',
                    textAlign: TextAlign.right,
                  ),
                ],
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FieldListPage(
                    model.detailFields,
                    actions: model.actions,
                    title: 'Forbruksdetaljer',
                  ),
            ),
          );
        });
  }
}

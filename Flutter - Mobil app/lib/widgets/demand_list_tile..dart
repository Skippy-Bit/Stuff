import 'package:e7mr/state/models/generated/field_data.dart';
import 'package:e7mr/widgets/field_list_page.dart';
import 'package:flutter/material.dart';

class DemandListTileModel {
  DemandListTileModel({
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

  Widget get titleWidget => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _titleWidgetChildren.toList(),
      );

  Iterable<Widget> get _titleWidgetChildren sync* {
    if (title != null && title.isNotEmpty) {
      yield Text(title);
    }
    if (subtitle != null && subtitle.isNotEmpty) {
      yield Text(subtitle);
    }
  }

  Widget get subtitleWidget => Text(description ?? '');
}

class DemandListTile extends StatelessWidget {
  final DemandListTileModel model;

  DemandListTile(this.model, {Key key}) : super(key: key) {
    assert(model != null);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: model.titleWidget,
      subtitle: model.subtitleWidget,
      isThreeLine: true,
      onTap: () => _onTap(context),
      trailing: _trailing,
    );
  }

  _onTap(BuildContext context) {
    final page = FieldListPage(
      model.detailFields,
      actions: model.actions,
      title: 'Behovsdetaljer',
    );
    final route = MaterialPageRoute(builder: (context) => page);
    Navigator.of(context).push(route);
  }

  Widget get _trailing {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _trailingTitle,
          _trailingValue,
        ],
      ),
    );
  }

  Widget get _trailingTitle {
    return Padding(
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
    );
  }

  Widget get _trailingValue {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          model.trailingValue ?? '',
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

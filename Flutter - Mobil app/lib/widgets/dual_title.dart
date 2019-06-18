import 'package:flutter/material.dart';

class DualTitle extends StatelessWidget {
  DualTitle({
    Key key,
    this.primary,
    this.secondary,
  }) : super(key: key);

  final String primary;
  final String secondary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildPrimary(context),
        buildSecondary(),
      ],
    );
  }

  Widget buildPrimary(BuildContext context) {
    return Text(
      primary,
      textScaleFactor: 0.75,
      style: buildPrimaryStyle(context),
    );
  }

  TextStyle buildPrimaryStyle(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      color: theme.primaryTextTheme.headline.color.withAlpha(153),
    );
  }

  Widget buildSecondary() => Text(secondary);
}

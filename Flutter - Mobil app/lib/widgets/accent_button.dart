import 'package:flutter/material.dart';

@immutable
class AccentButton extends StatelessWidget {
  const AccentButton({
    Key key,
    this.child,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RaisedButton(
      onPressed: onPressed,
      child: child,
      textColor: theme.accentTextTheme.button.color,
      highlightColor: theme.accentColor,
      color: theme.accentColor,
    );
  }
}

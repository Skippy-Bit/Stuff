import 'package:flutter/material.dart';

class RadioTextButton<T> extends StatelessWidget {
  RadioTextButton({
    Key key,
    this.value,
    this.groupValue,
    this.text,
    this.onChanged,
  }) : super(key: key);

  final T value;
  final T groupValue;
  final String text;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _radioButton,
          _radioLabel,
        ],
      ),
    );
  }

  Widget get _radioButton {
    return Radio(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }

  Widget get _radioLabel {
    return Text(
      text,
      softWrap: true,
      textAlign: TextAlign.center,
    );
  }
}

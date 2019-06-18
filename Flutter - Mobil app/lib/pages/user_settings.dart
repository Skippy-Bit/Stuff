import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}

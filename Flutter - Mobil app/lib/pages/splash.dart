import 'package:e7mr/e7mr_theme.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: E7MRTheme.secondary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icon/icon_512.png"),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(E7MRTheme.primary),
              backgroundColor: E7MRTheme.primary,
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              child: Text(
                'Laster inn',
                style: TextStyle(
                  color: E7MRTheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

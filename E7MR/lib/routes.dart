import 'package:e7mr/pages/home.dart';
import 'package:e7mr/pages/login/login_new.dart';
import 'package:e7mr/pages/splash.dart';
import 'package:e7mr/pages/todo/todo.dart';
import 'package:e7mr/pages/user_settings.dart';
import 'package:flutter/material.dart';

final routes = {
  '/': (BuildContext context) => SplashPage(),
  '/login': (BuildContext context) => LoginNewPage(),
  '/home': (BuildContext context) => HomePage(title: 'Hjem'),
  '/settings': (BuildContext context) => SettingsPage(),
  '/todo': (BuildContext context) => ToDoPage(),
  '/projects': (BuildContext context) => HomePage(
        title: 'Hjem',
        initialTabIndex: 0,
      ),
  '/warehouse': (BuildContext context) => HomePage(
        title: 'Hjem',
        initialTabIndex: 1,
      ),
};

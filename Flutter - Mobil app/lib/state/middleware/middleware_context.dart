import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class MiddlewareContext {
  final Database db;
  final GlobalKey<NavigatorState> navigatorKey;

  MiddlewareContext(this.db, this.navigatorKey);
}

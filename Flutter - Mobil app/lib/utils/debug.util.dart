import 'package:flutter/foundation.dart';

void runInDebug(VoidCallback func) {
  assert(() {
    func();
    return true;
  }());
}

Future<void> runInDebugAsync(AsyncCallback func) async {
  assert(await () async {
    await func();
    return true;
  }());
}

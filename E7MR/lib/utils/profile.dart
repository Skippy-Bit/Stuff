import 'dart:ui';

void profile(String tag, VoidCallback func) {
  final stopwatch = Stopwatch()..start();
  func();
  stopwatch.stop();
  print('$tag: ${stopwatch.elapsed}');
}

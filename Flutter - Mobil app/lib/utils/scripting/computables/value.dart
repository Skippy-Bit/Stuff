import 'package:e7mr/utils/scripting/computables/computable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

@immutable
class IntComputable<T extends int> implements NumComputable<T> {
  IntComputable(this._value);

  final int _value;

  @override
  Future<T> compute() async => SynchronousFuture(_value);
}

@immutable
class DoubleComputable<T extends double> implements NumComputable<T> {
  DoubleComputable(this._value);

  final double _value;

  @override
  Future<T> compute() async => SynchronousFuture(_value);
}

@immutable
class NumComputable<T extends num> implements Computable<T> {
  NumComputable(this._value);

  final num _value;

  @override
  Future<T> compute() async => SynchronousFuture(_value);
}

@immutable
class StringComputable<T extends String> implements Computable<T> {
  StringComputable(this._value);

  final String _value;

  @override
  Future<T> compute() async => SynchronousFuture(_value);
}

@immutable
class BoolComputable<T extends bool> implements Computable<T> {
  BoolComputable(this._value);

  final bool _value;

  @override
  Future<T> compute() async => SynchronousFuture(_value);
}

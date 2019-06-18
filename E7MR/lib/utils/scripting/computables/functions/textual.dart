import 'package:e7mr/utils/scripting/computables/computable.dart';
import 'package:e7mr/utils/scripting/computables/value.dart';
import 'package:meta/meta.dart';

@immutable
class TrimComputable implements StringComputable {
  TrimComputable(this._value);

  final StringComputable _value;

  @override
  Future<String> compute() async => (await _value.compute()).trim();
}

@immutable
class TrimLeftComputable implements StringComputable {
  TrimLeftComputable(this._value);

  final StringComputable _value;

  @override
  Future<String> compute() async => (await _value.compute()).trimLeft();
}

@immutable
class TrimRightComputable implements StringComputable {
  TrimRightComputable(this._value);

  final StringComputable _value;

  @override
  Future<String> compute() async => (await _value.compute()).trimRight();
}

@immutable
class SubStrComputable implements StringComputable {
  SubStrComputable(this._value, this._startIndex, this._length);

  final StringComputable _value;
  final IntComputable _startIndex;
  final IntComputable _length;

  @override
  Future<String> compute() async {
    final start = await _startIndex.compute();
    final length = await _length.compute();
    final end = start + length;
    return (await _value.compute()).substring(start, end);
  }
}

@immutable
class LowerComputable implements StringComputable {
  LowerComputable(this._value);

  final StringComputable _value;

  @override
  Future<String> compute() async => (await _value.compute()).toLowerCase();
}

@immutable
class UpperComputable implements StringComputable {
  UpperComputable(this._value);

  final StringComputable _value;

  @override
  Future<String> compute() async => (await _value.compute()).toUpperCase();
}

@immutable
class LengthComputable implements IntComputable {
  LengthComputable(this._value);

  final StringComputable _value;

  @override
  Future<int> compute() async => (await _value.compute()).length;
}

@immutable
class FormatFixedComputable implements StringComputable {
  FormatFixedComputable(this._value, this._fractionDigits);

  final NumComputable _value;
  final IntComputable _fractionDigits;

  @override
  Future<String> compute() async =>
      (await _value.compute()).toStringAsFixed(await _fractionDigits.compute());
}

@immutable
class ToStringComputable implements StringComputable {
  ToStringComputable(this._value);

  final Computable _value;

  @override
  Future<String> compute() async => (await _value.compute()).toString();
}

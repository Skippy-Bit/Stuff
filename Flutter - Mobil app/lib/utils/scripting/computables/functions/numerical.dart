import 'dart:collection';

import 'package:e7mr/utils/scripting/computables/computable.dart';
import 'package:e7mr/utils/scripting/computables/value.dart';
import 'package:meta/meta.dart';
import 'dart:math';

@immutable
class MinComputable implements NumComputable {
  MinComputable(this._values);

  final Iterable<NumComputable> _values;

  @override
  Future<num> compute() async =>
      (await computeAll(_values)).map((value) => value).reduce(min);
}

@immutable
class MaxComputable implements NumComputable {
  MaxComputable(this._values);

  final Iterable<NumComputable> _values;

  @override
  Future<num> compute() async =>
      (await computeAll(_values)).map((value) => value).reduce(max);
}

@immutable
class MeanComputable implements NumComputable {
  MeanComputable(this._values);

  final Iterable<NumComputable> _values;

  @override
  Future<num> compute() async =>
      (await computeAll(_values)).reduce((sum, value) => sum + value) /
      _values.length;
}

@immutable
class MedianComputable implements NumComputable {
  MedianComputable(this._values);

  final Iterable<NumComputable> _values;

  @override
  Future<num> compute() async => _median(await computeAll(_values));

  num _median(Iterable<num> iter) {
    final list = iter.toList();
    list.sort();
    final length = list.length;
    if (length % 2 == 1) {
      return list[length ~/ 2];
    } else {
      return (list[(length ~/ 2) - 1] + list[length ~/ 2]) / 2;
    }
  }
}

@immutable
class ModeComputable implements NumComputable {
  ModeComputable(this._values);

  final Iterable<NumComputable> _values;

  @override
  Future<num> compute() async => _mode(await computeAll(_values));

  num _mode(Iterable<num> iter) {
    final counts = HashMap<num, int>();
    iter.forEach((value) {
      counts.putIfAbsent(value, () => 0);
      return counts[value]++;
    });

    num maxKey = -1, maxVal = 0;
    for (num k in counts.keys) {
      if (counts[k] > maxVal) {
        maxKey = k;
        maxVal = counts[k];
      }
    }
    return maxKey;
  }
}

@immutable
class PowComputable implements NumComputable {
  PowComputable(this._x, this._exponent);

  final NumComputable _x;
  final NumComputable _exponent;

  @override
  Future<num> compute() async =>
      pow(await _x.compute(), await _exponent.compute());
}

@immutable
class ParseNumComputable implements NumComputable {
  ParseNumComputable(this._value);

  final StringComputable _value;

  @override
  Future<num> compute() async => num.parse(await _value.compute());
}

@immutable
class ParseIntComputable implements IntComputable {
  ParseIntComputable(this._value);

  final StringComputable _value;

  @override
  Future<int> compute() async => int.parse(await _value.compute());
}

@immutable
class ParseDoubleComputable implements DoubleComputable {
  ParseDoubleComputable(this._value);

  final StringComputable _value;

  @override
  Future<double> compute() async => double.parse(await _value.compute());
}

@immutable
class FloorComputable implements IntComputable {
  FloorComputable(this._value);

  final NumComputable _value;

  @override
  Future<int> compute() async => (await _value.compute()).floor();
}

@immutable
class CeilComputable implements IntComputable {
  CeilComputable(this._value);

  final NumComputable _value;

  @override
  Future<int> compute() async => (await _value.compute()).ceil();
}

@immutable
class RoundComputable implements IntComputable {
  RoundComputable(this._value);

  final NumComputable _value;

  @override
  Future<int> compute() async => (await _value.compute()).round();
}

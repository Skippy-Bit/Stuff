import 'package:e7mr/utils/scripting/computables/computable.dart';
import 'package:e7mr/utils/scripting/computables/value.dart';
import 'package:meta/meta.dart';

@immutable
class InvertComputable implements BoolComputable {
  InvertComputable(this._value);

  final BoolComputable _value;

  @override
  Future<bool> compute() async => !(await _value.compute());
}

@immutable
class EqualComputable implements BoolComputable {
  EqualComputable(this._values);

  final Iterable<Computable> _values;

  @override
  Future<bool> compute() async {
    final iter = await computeAll(_values);
    if (iter.isEmpty) {
      return true;
    }
    var prev = iter.first;
    for (final val in iter.skip(1)) {
      if (val != prev) {
        return false;
      }
      prev = val;
    }
    return true;
  }
}

@immutable
class AndComputable implements BoolComputable {
  AndComputable(this._values);

  final Iterable<BoolComputable> _values;

  @override
  Future<bool> compute() async =>
      (await computeAll(_values)).every((value) => value);
}

@immutable
class OrComputable implements BoolComputable {
  OrComputable(this._values);

  final Iterable<BoolComputable> _values;

  @override
  Future<bool> compute() async =>
      (await computeAll(_values)).any((value) => value);
}

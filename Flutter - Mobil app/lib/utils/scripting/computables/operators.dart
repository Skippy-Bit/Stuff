import 'package:e7mr/utils/scripting/computables/computable.dart';
import 'package:e7mr/utils/scripting/computables/value.dart';
import 'package:meta/meta.dart';

Operator parseOperator(String input) {
  assert(input.length == 1);
  switch (input) {
    case '&':
      return Operator.CONCAT;
    case '+':
      return Operator.ADD;
    case '-':
      return Operator.SUB;
    case '*':
      return Operator.MUL;
    case '/':
      return Operator.DIV;
  }
  return null;
}

enum Operator { ADD, SUB, MUL, DIV, CONCAT }

@immutable
class ConcatOpComputable implements StringComputable {
  ConcatOpComputable(this._values);

  final Iterable<Computable> _values;

  @override
  Future<String> compute() async {
    StringBuffer buf = StringBuffer();
    (await computeAll(_values)).forEach(buf.write);
    return buf.toString();
  }
}

@immutable
class AddOpComputable implements NumComputable {
  AddOpComputable(this._lhs, this._rhs);

  final NumComputable _lhs;
  final NumComputable _rhs;

  @override
  Future<num> compute() async => await _lhs.compute() + await _rhs.compute();
}

@immutable
class SubOpComputable implements NumComputable {
  SubOpComputable(this._lhs, this._rhs);

  final NumComputable _lhs;
  final NumComputable _rhs;

  @override
  Future<num> compute() async => await _lhs.compute() - await _rhs.compute();
}

@immutable
class MulOpComputable implements NumComputable {
  MulOpComputable(this._lhs, this._rhs);

  final NumComputable _lhs;
  final NumComputable _rhs;

  @override
  Future<num> compute() async => await _lhs.compute() * await _rhs.compute();
}

@immutable
class DivOpComputable implements NumComputable {
  DivOpComputable(this._lhs, this._rhs);

  final NumComputable _lhs;
  final NumComputable _rhs;

  @override
  Future<num> compute() async => await _lhs.compute() / await _rhs.compute();
}

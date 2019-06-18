import 'dart:collection';

import 'package:e7mr/utils/scripting/computables/computable.dart';
import 'package:e7mr/utils/scripting/computables/operators.dart';

const OPERATOR_PRECEDENCE = <Operator, int>{
  Operator.DIV: 2,
  Operator.MUL: 2,
  Operator.SUB: 1,
  Operator.ADD: 1,
  Operator.CONCAT: 0,
};

Computable shuntingYard(Iterable<dynamic> values) =>
    rpnToComputable(rpn(values));

Queue rpn(Iterable<dynamic> infix) {
  final stack = Queue();
  final rpn = Queue();
  for (final val in infix) {
    if (val is Computable) {
      rpn.addLast(val);
    } else if (val is Operator) {
      if (stack.isNotEmpty &&
          OPERATOR_PRECEDENCE[stack.last] > OPERATOR_PRECEDENCE[val]) {
        rpn.addLast(stack.removeLast());
      }
      stack.addLast(val);
    }
  }
  while (stack.isNotEmpty) {
    rpn.addLast(stack.removeLast());
  }
  return rpn;
}

Computable rpnToComputable(Queue rpn) {
  assert(rpn.isNotEmpty);
  final stack = Queue();
  for (final val in rpn) {
    if (val is Computable) {
      stack.addLast(val);
    } else if (val is Operator) {
      switch (val) {
        case Operator.DIV:
          assert(stack.length >= 2);
          final rhs = stack.removeLast();
          final lhs = stack.removeLast();
          stack.addLast(DivOpComputable(lhs, rhs));
          break;
        case Operator.MUL:
          assert(stack.length >= 2);
          final rhs = stack.removeLast();
          final lhs = stack.removeLast();
          stack.addLast(MulOpComputable(lhs, rhs));
          break;
        case Operator.SUB:
          assert(stack.length >= 2);
          final rhs = stack.removeLast();
          final lhs = stack.removeLast();
          stack.addLast(SubOpComputable(lhs, rhs));
          break;
        case Operator.ADD:
          assert(stack.length >= 2);
          final rhs = stack.removeLast();
          final lhs = stack.removeLast();
          stack.addLast(AddOpComputable(lhs, rhs));
          break;
        case Operator.CONCAT:
          assert(stack.every((val) => val is Computable));
          final args = List<Computable>();
          for (final val in stack) {
            if (val is Computable) {
              args.add(val);
            }
          }
          stack.clear();
          stack.addLast(ConcatOpComputable(args));
          break;
      }
    }
  }
  assert(stack.length == 1);
  return stack.last;
}

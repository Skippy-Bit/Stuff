import 'dart:collection';

import 'package:e7mr/utils/scripting/computables/operators.dart';
import 'package:e7mr/utils/scripting/computables/value.dart';
import 'package:e7mr/utils/scripting/shunting_yard.dart';
import 'package:flutter_test/flutter_test.dart';

main() async {
  test('should order the tokens in the correct RPN order', () async {
    final tokens = Queue();
    tokens.addAll([
      IntComputable(2),
      Operator.ADD,
      DoubleComputable(5.5),
      Operator.MUL,
      NumComputable(3),
      Operator.DIV,
      IntComputable(10),
    ]);

    final result = shuntingYard(tokens);

    assert(result is NumComputable);
    assert((await (result as NumComputable).compute()) == 3.65);
  });
}

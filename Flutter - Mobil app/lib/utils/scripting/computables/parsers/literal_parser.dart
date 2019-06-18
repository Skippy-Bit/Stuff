import 'dart:collection';
import 'package:e7mr/utils/scripting/computables/functions/boolean.dart';
import 'package:e7mr/utils/scripting/computables/functions/functions.dart';
import 'package:e7mr/utils/scripting/computables/functions/textual.dart';
import 'package:e7mr/utils/scripting/computables/operators.dart';
import 'package:e7mr/utils/scripting/computables/value.dart';
import 'package:e7mr/utils/scripting/shunting_yard.dart';
import 'package:petitparser/petitparser.dart';
import 'package:e7mr/utils/scripting/computables/computable.dart';

/// Parses the content of [input] into a single [StringComputable].
/// The content of [input] should not be encapsulated in quotes [']/["].
Result<StringComputable> parseLiteral(String input) => _parser.parse(input);

final Parser<StringComputable> _parser = _createParser();

Parser<StringComputable> _createParser() {
  final parser = undefined<StringComputable>();
  final expression = undefined<Computable>();
  final statements = undefined<Computable>();

  // Content in a literal.
  final literalContent = (String termChar) {
    final a = (expression | any());
    final b = termChar == null ? a.star() : a.starLazy(char(termChar));
    return b.map((values) {
      final computables = Queue<StringComputable>();
      StringBuffer buf = StringBuffer();
      for (final value in values) {
        if (value is Computable) {
          if (buf.isNotEmpty) {
            computables.addLast(StringComputable(buf.toString()));
            buf.clear();
          }
          computables.addLast(ToStringComputable(value));
        } else {
          buf.write(value);
        }
      }
      computables.addLast(StringComputable(buf.toString()));
      return ConcatOpComputable(computables);
    });
  };
  final literalContentSQ = literalContent('\'');
  final literalContentDQ = literalContent('\"');
  final literalContentNonTerm = literalContent(null);

  final prefixOperator = (char('!') | char('-')).cast();

  // An integer constant.
  final intConst = digit()
      .plus()
      .trim()
      .flatten()
      .map((str) => IntComputable(int.parse(str)));
  // A double constant.
  final doubleConst = (digit().plus() & char('.') & digit().plus())
      .trim()
      .flatten()
      .map((str) => DoubleComputable(double.parse(str)));
  // An integer or a double constant.
  final Parser<NumComputable> numConst = (doubleConst | intConst).cast();

  // A boolean constant.
  final boolConst = (string('true') | string('false'))
      .map((val) => BoolComputable(val == 'true'));

  // Literal (single quote).
  const normalSQ = '\'';
  const escapedSQ = '\\\'';
  final terminatingSQ = string(escapedSQ).not() & char(normalSQ);
  final literalSQ = (char(normalSQ) & literalContentSQ & terminatingSQ)
      .pick<StringComputable>(1);

  // Literal (double quote).
  const normalDQ = '"';
  const escapedDQ = '\\"';
  final terminatingDQ = string(escapedDQ).not() & char(normalDQ);
  final literalDQ = (char(normalDQ) & literalContentDQ & terminatingDQ)
      .pick<StringComputable>(1);

  // A numerical, boolean or literal constant.
  final Parser<Computable> constant =
      (numConst | boolConst | literalSQ | literalDQ).cast();

  // An identifier, such as a function name, variable name, etc.
  final identifier = (word() & (word() | digit()).star()).flatten();

  final concatOp = char('&').trim().map((val) => parseOperator(val));
  final arithmeticOp = (char('+') | char('-') | char('*') | char('/'))
      .trim()
      .map((val) => parseOperator(val));
  // Operators for string concatenation and the four fundamental mathematical operators +-*/
  final Parser<Operator> operation = (concatOp | arithmeticOp).cast();

  // A universal separator for arguments, list items, etc.
  final separator = char(',').trim();
  // Zero or more arguments separated by ','.
  final args = (statements & (separator & statements).star()).map((values) {
    final computables = Queue<Computable>();
    computables.addLast(values[0]);
    if (values.length > 1) {
      for (final pair in values[1]) {
        computables.addLast(pair[1]);
      }
    }
    return computables;
  });

  // Identifier, directly followed by a '(', then zero or more arguments, ended by a ')'.
  final invocation = (identifier & char('(') & args & char(')'))
      .map((values) => parseFunction(values[0], values[2]));

  // Statements in a new context: ( ... )
  final newContext = (char('(').trim() & statements & char(')').trim()).pick(1);

  // A single statement, such as a function call, a constant, etc.
  final Parser<Computable> statement =
      (prefixOperator.optional() & (newContext | invocation | constant))
          .map((values) {
    var result = values[1];
    final prefixOp = values[0];
    if (prefixOp != null) {
      if (prefixOp == '!' && result is BoolComputable) {
        result = InvertComputable(result);
      } else if (prefixOp == '-' && result is NumComputable) {
        result = SubOpComputable(NumComputable(0), result);
      }
    }
    return result;
  });
  // One or more statements, adjoined by operators.
  statements.set((statement & (operation & statement).star()).map((values) {
    final tokens = Queue();
    tokens.addLast(values[0]);
    if (values.length > 1) {
      for (final pair in values[1]) {
        tokens.addAll(pair);
      }
    }
    return shuntingYard(tokens);
  }));

  // Literal expression. Used in top-level text or string literals. Syntax: ${...}
  expression.set((string(r'${') & statements & char('}')).pick<Computable>(1));

  // The final parser, parsing literal content.
  parser.set(literalContentNonTerm);
  return parser.end();
}

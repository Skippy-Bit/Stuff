import 'package:e7mr/utils/scripting/computables/parsers/literal_parser.dart';
import 'package:flutter_test/flutter_test.dart';

main() async {
  test('should expand expressions - literal', () async {
    final input = r"Hello ${'World'}!";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'Hello World!');
  });
  test('should expand expressions - literal concatenation', () async {
    final input = r"Hello ${'World' & '!'}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'Hello World!');
  });
  test('should expand expressions - nested expressions', () async {
    final input = r"Hello ${'World${'!'}'}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'Hello World!');
  });
  test('should expand expressions - arithmetic', () async {
    final input = r"My house is ${2+5.5*3/10}m high!";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'My house is 3.65m high!');
  });
  test('should expand expressions - prefix operator: negation (boolean)',
      () async {
    final input = r"${!AND(true,false)}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'true');
  });
  test('should expand expressions - prefix operator: negation (numerical)',
      () async {
    final input = r"${-(-4 + 3)}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == '1');
  });
  test('should expand expressions - new context', () async {
    final input = r"${2 * 3 + (4/(2-0))}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == '8.0');
  });

  // Functions
  test('should expand expressions - function: TRIM', () async {
    final input = r"${TRIM('  abc  ')}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'abc');
  });
  test('should expand expressions - function: TRIMLEFT', () async {
    final input = r"${TRIMLEFT('  abc  ')}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'abc  ');
  });
  test('should expand expressions - function: TRIMRIGHT', () async {
    final input = r"${TRIMRIGHT('  abc  ')}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == '  abc');
  });
  test('should expand expressions - function: SUBSTR', () async {
    final input = r"${SUBSTR('Hello World!', 2, 3)}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'llo');
  });
  test('should expand expressions - function: UPPER', () async {
    final input = r"${UPPER('Hello World!')}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'HELLO WORLD!');
  });
  test('should expand expressions - function: LOWER', () async {
    final input = r"${LOWER('Hello World!')}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'hello world!');
  });
  test('should expand expressions - function: LENGTH', () async {
    final input = r"${LENGTH('abcd ef')}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == '7');
  });
  test('should expand expressions - function: FORMATFIXED', () async {
    final input = r"My house is ${FORMATFIXED(2+5.5*3/10,4)}m high!";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'My house is 3.6500m high!');
  });
  test('should expand expressions - function: TOSTRING', () async {
    final input = r"My house is ${TOSTRING(2+5.5*3/10)}m high!";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'My house is 3.65m high!');
  });
  test('should expand expressions - function: MIN and MAX', () async {
    final input = r"${MIN(11, MAX(6, 10))}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == '10');
  });
  test('should expand expressions - function: MEAN', () async {
    final input = r"${MEAN(1,2,4,5,6,3)}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == '3.5');
  });
  test('should expand expressions - function: MEDIAN', () async {
    final inputEvenElements = r"${MEDIAN(1,2,4,5,6,3)}";
    final inputOddElements = r"${MEDIAN(1,2,4,5,6,3,7)}";

    final resultEvenElements = parseLiteral(inputEvenElements);
    final resultOddElements = parseLiteral(inputOddElements);

    assert(resultEvenElements.isSuccess);
    assert(resultOddElements.isSuccess);
    assert(await resultEvenElements.value.compute() == '3.5');
    assert(await resultOddElements.value.compute() == '4');
  });
  test('should expand expressions - function: MODE', () async {
    final input = r"${MODE(0,1,5,4,5,5,12)}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == '5');
  });
  test('should expand expressions - function: POW', () async {
    final input = r"${POW(10,2)}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == '100');
  });
  test(
      'should expand expressions - function: PARSENUM, PARSEINT and PARSEDOUBLE',
      () async {
    final input = r"${PARSENUM('2.4') + PARSEINT('4') + PARSEDOUBLE('5.6')}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == '12.0');
  });
  test('should expand expressions - function: FLOOR', () async {
    final input = r"${FLOOR(3.8)}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == '3');
  });
  test('should expand expressions - function: CEIL', () async {
    final input = r"${CEIL(3.2)}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == '4');
  });
  test('should expand expressions - function: ROUND', () async {
    final input = r"${ROUND(3.5)}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == '4');
  });
  test('should expand expressions - function: AND, OR and INVERT', () async {
    final input = r"${AND(true, true, OR(false, true), INVERT(false))}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'true');
  });
  test('should expand expressions - function: EQUAL', () async {
    final input = r"${EQUAL(4,2+2,6-2,2*2)}";

    final result = parseLiteral(input);

    assert(result.isSuccess);
    assert(await result.value.compute() == 'true');
  });
}

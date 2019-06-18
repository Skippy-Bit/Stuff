import 'package:e7mr/utils/scripting/computables/computable.dart';
import 'package:e7mr/utils/scripting/computables/functions/boolean.dart';
import 'package:e7mr/utils/scripting/computables/functions/numerical.dart';
import 'package:e7mr/utils/scripting/computables/functions/textual.dart';
import 'package:e7mr/utils/scripting/computables/value.dart';

typedef Computable ComputableParserDelegate(Iterable<Computable> args);

Computable parseFunction(String funcName, Iterable<Computable> args) =>
    COMPUTABLE_PARSER_DELEGATE_MAP[funcName.toUpperCase()](args);

const COMPUTABLE_PARSER_DELEGATE_MAP = <String, ComputableParserDelegate>{
  'TRIM': parseFunctionTrim,
  'TRIMLEFT': parseFunctionTrimLeft,
  'TRIML': parseFunctionTrimLeft,
  'TRIMRIGHT': parseFunctionTrimRight,
  'TRIMR': parseFunctionTrimRight,
  'SUBSTR': parseFunctionSubStr,
  'LOWER': parseFunctionLower,
  'UPPER': parseFunctionUpper,
  'LENGTH': parseFunctionLength,
  'FORMATFIXED': parseFunctionFormatFixed,
  'TOSTRING': parseFunctionToString,
  // 'REGEX': parseFunctionRegex,
  // 'REPLACE': parseFunctionReplace,
  // 'TEST': parseFunctionTest,
  'MIN': parseFunctionMin,
  'MAX': parseFunctionMax,
  'MEAN': parseFunctionMean,
  'MEDIAN': parseFunctionMedian,
  'MODE': parseFunctionMode,
  'POW': parseFunctionPow,
  'PARSENUM': parseFunctionParseNum,
  'PARSEINT': parseFunctionParseInt,
  'PARSEDOUBLE': parseFunctionParseDouble,
  'FLOOR': parseFunctionFloor,
  'CEIL': parseFunctionCeil,
  'ROUND': parseFunctionRound,
  // 'MATH': parseFunctionMath,
  'INVERT': parseFunctionInvert,
  'EQUAL': parseFunctionEqual,
  'AND': parseFunctionAnd,
  'OR': parseFunctionOr,
};

TrimComputable parseFunctionTrim(Iterable<Computable> args) =>
    TrimComputable(args.elementAt(0) as StringComputable);
TrimLeftComputable parseFunctionTrimLeft(Iterable<Computable> args) =>
    TrimLeftComputable(args.elementAt(0) as StringComputable);
TrimRightComputable parseFunctionTrimRight(Iterable<Computable> args) =>
    TrimRightComputable(args.elementAt(0) as StringComputable);
SubStrComputable parseFunctionSubStr(Iterable<Computable> args) =>
    SubStrComputable(
      args.elementAt(0) as StringComputable,
      args.elementAt(1) as IntComputable,
      args.elementAt(2) as IntComputable,
    );
LowerComputable parseFunctionLower(Iterable<Computable> args) =>
    LowerComputable(args.elementAt(0) as StringComputable);
UpperComputable parseFunctionUpper(Iterable<Computable> args) =>
    UpperComputable(args.elementAt(0) as StringComputable);
LengthComputable parseFunctionLength(Iterable<Computable> args) =>
    LengthComputable(args.elementAt(0) as StringComputable);
FormatFixedComputable parseFunctionFormatFixed(Iterable<Computable> args) =>
    FormatFixedComputable(
      args.elementAt(0) as NumComputable,
      args.elementAt(1) as IntComputable,
    );
ToStringComputable parseFunctionToString(Iterable<Computable> args) =>
    ToStringComputable(args.elementAt(0));
// RegexComputable parseFunctionRegex(Iterable<Computable> args) =>
//     RegexComputable(args.elementAt(0), args.elementAt(1), args.elementAt(2));
// ReplaceComputable parseFunctionReplace(Iterable<Computable> args) =>
//     ReplaceComputable(args.elementAt(0));
// TestComputable parseFunctionTest(Iterable<Computable> args) =>
//     TestComputable(args.elementAt(0));

MinComputable parseFunctionMin(Iterable<Computable> args) =>
    MinComputable(args.cast<NumComputable>());
MaxComputable parseFunctionMax(Iterable<Computable> args) =>
    MaxComputable(args.cast<NumComputable>());
MeanComputable parseFunctionMean(Iterable<Computable> args) =>
    MeanComputable(args.cast<NumComputable>());
MedianComputable parseFunctionMedian(Iterable<Computable> args) =>
    MedianComputable(args.cast<NumComputable>());
ModeComputable parseFunctionMode(Iterable<Computable> args) =>
    ModeComputable(args.cast<NumComputable>());
PowComputable parseFunctionPow(Iterable<Computable> args) => PowComputable(
      args.elementAt(0) as NumComputable,
      args.elementAt(1) as NumComputable,
    );
ParseNumComputable parseFunctionParseNum(Iterable<Computable> args) =>
    ParseNumComputable(args.elementAt(0) as StringComputable);
ParseIntComputable parseFunctionParseInt(Iterable<Computable> args) =>
    ParseIntComputable(args.elementAt(0) as StringComputable);
ParseDoubleComputable parseFunctionParseDouble(Iterable<Computable> args) =>
    ParseDoubleComputable(args.elementAt(0) as StringComputable);
FloorComputable parseFunctionFloor(Iterable<Computable> args) =>
    FloorComputable(args.elementAt(0) as NumComputable);
CeilComputable parseFunctionCeil(Iterable<Computable> args) =>
    CeilComputable(args.elementAt(0) as NumComputable);
RoundComputable parseFunctionRound(Iterable<Computable> args) =>
    RoundComputable(args.elementAt(0) as NumComputable);
// MathComputable parseFunctionMath(Iterable<Computable> args) =>
//     MathComputable(args.elementAt(0));

InvertComputable parseFunctionInvert(Iterable<Computable> args) =>
    InvertComputable(args.elementAt(0) as BoolComputable);
EqualComputable parseFunctionEqual(Iterable<Computable> args) =>
    EqualComputable(args);
AndComputable parseFunctionAnd(Iterable<Computable> args) =>
    AndComputable(args.cast<BoolComputable>());
OrComputable parseFunctionOr(Iterable<Computable> args) =>
    OrComputable(args.cast<BoolComputable>());

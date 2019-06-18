typedef T LogCommandDecoder<T extends LogCommand>(Map<String, dynamic> map);

abstract class LogCommand {
  String get name;
  String get hash;

  Map<String, dynamic> encode();
  Map<String, dynamic> encodeExtraContent();
  bool hasExtraContent();
}

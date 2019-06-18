import 'package:e7mr/state/actions/log_commands/log_command.dart';

class RelocateItem extends LogCommand {
  static const COMMAND = 'relocate_item';

  @override
  String get name => COMMAND;

  @override
  String get hash => '$itemNo#$fromLocationCode#$toLocationCode';

  RelocateItem(
    this.itemNo,
    this.fromLocationCode,
    this.toLocationCode,
    this.quantity,
  );

  final String itemNo;
  final String fromLocationCode;
  final String toLocationCode;
  final num quantity;

  @override
  Map<String, dynamic> encode() {
    return {
      'itemNo': itemNo,
      'fromLoc': fromLocationCode,
      'toLoc': toLocationCode,
      'qty': quantity,
    };
  }

  @override
  Map<String, dynamic> encodeExtraContent() {
    return null;
  }

  @override
  bool hasExtraContent() {
    return false;
  }

  static RelocateItem decode(Map<String, dynamic> map) {
    return RelocateItem(
      map['itemNo'] as String,
      map['fromLoc'] as String,
      map['toLoc'] as String,
      map['qty'] as num,
    );
  }
}

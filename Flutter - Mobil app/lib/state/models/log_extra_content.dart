import 'package:meta/meta.dart';
import 'dart:typed_data';

@immutable
class LogExtraContent {
  final int rowID;
  final String uuid;
  final Uint8List extraContent;

  LogExtraContent({
    this.rowID,
    this.uuid,
    this.extraContent,
  });

  LogExtraContent copyWith({
    int rowID,
    String uuid,
    Uint8List extraContent,
  }) {
    return LogExtraContent(
      rowID: rowID ?? this.rowID,
      uuid: uuid ?? this.uuid,
      extraContent: extraContent ?? this.extraContent,
    );
  }

  static LogExtraContent decodeDB(Map<String, dynamic> map) => LogExtraContent(
        rowID: map['ROWID'] as int,
        uuid: map['UUID'] as String,
        extraContent: map['ExtraContentBLOB'] as Uint8List,
      );

  @override
  int get hashCode => rowID.hashCode ^ uuid.hashCode ^ extraContent.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogExtraContent &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          uuid == other.uuid &&
          extraContent == other.extraContent;

  @override
  String toString() {
    return 'LogExtraContent{rowID: $rowID, uuid: $uuid, extraContent: $extraContent}';
  }
}

import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';
import 'dart:typed_data';
import 'dart:typed_data';

@immutable
class LogState {
  final int rowID;
  final int internalState;
  final String etag;

  final int entryNo;
  final DateTime timeStamp;
  final int statusAsInt;
  final String statusMessage;
  final Uint8List content;
  final String userID;
  final String uuid;
  final String command;
  final String hash;
  final Uint8List extraContent;

  LogState({
    this.rowID,
    this.internalState,
    this.etag,
    this.entryNo,
    this.timeStamp,
    this.statusAsInt,
    this.statusMessage,
    this.content,
    this.userID,
    this.uuid,
    this.command,
    this.hash,
    this.extraContent,
  });


  LogState copyWith({
    int rowID,
    int internalState,
    String etag,
    int entryNo,
    DateTime timeStamp,
    int statusAsInt,
    String statusMessage,
    Uint8List content,
    String userID,
    String uuid,
    String command,
    String hash,
    Uint8List extraContent,
  }) {
    return LogState(
      rowID: rowID ?? this.rowID,
      internalState: internalState ?? this.internalState,
      etag: etag ?? this.etag,
      entryNo: entryNo ?? this.entryNo,
      timeStamp: timeStamp ?? this.timeStamp,
      statusAsInt: statusAsInt ?? this.statusAsInt,
      statusMessage: statusMessage ?? this.statusMessage,
      content: content ?? this.content,
      userID: userID ?? this.userID,
      uuid: uuid ?? this.uuid,
      command: command ?? this.command,
      hash: hash ?? this.hash,
      extraContent: extraContent ?? this.extraContent,
    );
  }

  Map<String, dynamic> encodeAPI({bool fromEncodeDB = false}) {
    final map = HashMap<String, dynamic>();
    if (entryNo != null) {
      map['Entry_No'] = entryNo;
    }
    if (timeStamp != null) {
      map['Time_Stamp'] = timeStamp?.toUtc()?.toIso8601String();
    }
    if (statusAsInt != null) {
      map['StatusAsInt'] = statusAsInt;
    }
    if (statusMessage != null) {
      map['Status_Message'] = statusMessage;
    }
    if (content != null) {
      if (fromEncodeDB) {
        map['ContentBLOB'] = content;
      } else {
        map['ContentBLOB'] = base64.encode(content);
      }
    }
    if (userID != null) {
      map['User_ID'] = userID;
    }
    if (uuid != null) {
      map['UUID'] = uuid;
    }
    if (command != null) {
      map['Command'] = command;
    }
    if (hash != null) {
      map['Hash'] = hash;
    }
    if (extraContent != null) {
      if (fromEncodeDB) {
        map['ExtraContentBLOB'] = extraContent;
      } else {
        map['ExtraContentBLOB'] = base64.encode(extraContent);
      }
    }
    return map;
  }

  static LogState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    int internalState,
    dynamic content,
    dynamic extraContent,
    }
  ) => LogState(
        rowID: rowID,
        internalState: internalState,
        etag: map['@odata.etag'] as String,
        entryNo: map['Entry_No'] as int,
        timeStamp: DateTime.tryParse(map['Time_Stamp'] as String ?? ''),
        statusAsInt: map['StatusAsInt'] as int,
        statusMessage: map['Status_Message'] as String,
        content: content != null ? content : base64.decode(map['ContentBLOB'] as String ?? ''),
        userID: map['User_ID'] as String,
        uuid: map['UUID'] as String,
        command: map['Command'] as String,
        hash: map['Hash'] as String,
        extraContent: extraContent != null ? extraContent : base64.decode(map['ExtraContentBLOB'] as String ?? ''),
      );

  Map<String, dynamic> encodeDB(String username) {
    final map = encodeAPI(fromEncodeDB: true);
    map['ETag'] = etag ?? '';
    map['_InternalState'] = internalState ?? 0;
    map['User'] = username ?? '';
    return map;
  }

  static LogState decodeDB(Map<String, dynamic> map) {
    map['@odata.etag'] = map['ETag'];
    return decodeAPI(
      map,
      rowID: map['ROWID'] as int,
      internalState: map['_InternalState'] as int,
      content: map['ContentBLOB'] as Uint8List,
      extraContent: map['ExtraContentBLOB'] as Uint8List,
    );
  }

  @override
  int get hashCode =>
      rowID.hashCode ^
      internalState.hashCode ^
      etag.hashCode ^
      entryNo.hashCode ^
      timeStamp.hashCode ^
      statusAsInt.hashCode ^
      statusMessage.hashCode ^
      content.hashCode ^
      userID.hashCode ^
      uuid.hashCode ^
      command.hashCode ^
      hash.hashCode ^
      extraContent.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          internalState == other.internalState &&
          etag == other.etag &&
          entryNo == other.entryNo &&
          timeStamp == other.timeStamp &&
          statusAsInt == other.statusAsInt &&
          statusMessage == other.statusMessage &&
          content == other.content &&
          userID == other.userID &&
          uuid == other.uuid &&
          command == other.command &&
          hash == other.hash &&
          extraContent == other.extraContent;

  @override
  String toString() {
    return 'LogState{rowID: $rowID, internalState: $internalState, etag: $etag, entryNo: $entryNo, timeStamp: $timeStamp, statusAsInt: $statusAsInt, statusMessage: $statusMessage, content: $content, userID: $userID, uuid: $uuid, command: $command, hash: $hash, extraContent: $extraContent}';
  }
}
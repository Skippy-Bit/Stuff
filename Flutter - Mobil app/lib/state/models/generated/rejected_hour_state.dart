import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';

@immutable
class RejectedHourState {
  final int rowID;
  final int internalState;
  final String etag;

  final int entryNo;
  final String jobNo;
  final String jobTaskNo;
  final String description;
  final String reason;
  final num originalQuantity;
  final num adjustedQuantity;
  final String guid;

  RejectedHourState({
    this.rowID,
    this.internalState,
    this.etag,
    this.entryNo,
    this.jobNo,
    this.jobTaskNo,
    this.description,
    this.reason,
    this.originalQuantity,
    this.adjustedQuantity,
    this.guid,
  });


  RejectedHourState copyWith({
    int rowID,
    int internalState,
    String etag,
    int entryNo,
    String jobNo,
    String jobTaskNo,
    String description,
    String reason,
    num originalQuantity,
    num adjustedQuantity,
    String guid,
  }) {
    return RejectedHourState(
      rowID: rowID ?? this.rowID,
      internalState: internalState ?? this.internalState,
      etag: etag ?? this.etag,
      entryNo: entryNo ?? this.entryNo,
      jobNo: jobNo ?? this.jobNo,
      jobTaskNo: jobTaskNo ?? this.jobTaskNo,
      description: description ?? this.description,
      reason: reason ?? this.reason,
      originalQuantity: originalQuantity ?? this.originalQuantity,
      adjustedQuantity: adjustedQuantity ?? this.adjustedQuantity,
      guid: guid ?? this.guid,
    );
  }

  Map<String, dynamic> encodeAPI({bool fromEncodeDB = false}) {
    final map = HashMap<String, dynamic>();
    if (entryNo != null) {
      map['Entry_No'] = entryNo;
    }
    if (jobNo != null) {
      map['Job_No'] = jobNo;
    }
    if (jobTaskNo != null) {
      map['Job_Task_No'] = jobTaskNo;
    }
    if (description != null) {
      map['Description'] = description;
    }
    if (reason != null) {
      map['Reason'] = reason;
    }
    if (originalQuantity != null) {
      map['Original_Quantity'] = originalQuantity;
    }
    if (adjustedQuantity != null) {
      map['Adjusted_Quantity'] = adjustedQuantity;
    }
    if (guid != null) {
      map['GUID'] = guid;
    }
    return map;
  }

  static RejectedHourState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    int internalState,
    }
  ) => RejectedHourState(
        rowID: rowID,
        internalState: internalState,
        etag: map['@odata.etag'] as String,
        entryNo: map['Entry_No'] as int,
        jobNo: map['Job_No'] as String,
        jobTaskNo: map['Job_Task_No'] as String,
        description: map['Description'] as String,
        reason: map['Reason'] as String,
        originalQuantity: map['Original_Quantity'] as num,
        adjustedQuantity: map['Adjusted_Quantity'] as num,
        guid: map['GUID'] as String,
      );

  Map<String, dynamic> encodeDB(String username) {
    final map = encodeAPI(fromEncodeDB: true);
    map['ETag'] = etag ?? '';
    map['_InternalState'] = internalState ?? 0;
    map['User'] = username ?? '';
    return map;
  }

  static RejectedHourState decodeDB(Map<String, dynamic> map) {
    map['@odata.etag'] = map['ETag'];
    return decodeAPI(
      map,
      rowID: map['ROWID'] as int,
      internalState: map['_InternalState'] as int,
    );
  }

  @override
  int get hashCode =>
      rowID.hashCode ^
      internalState.hashCode ^
      etag.hashCode ^
      entryNo.hashCode ^
      jobNo.hashCode ^
      jobTaskNo.hashCode ^
      description.hashCode ^
      reason.hashCode ^
      originalQuantity.hashCode ^
      adjustedQuantity.hashCode ^
      guid.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RejectedHourState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          internalState == other.internalState &&
          etag == other.etag &&
          entryNo == other.entryNo &&
          jobNo == other.jobNo &&
          jobTaskNo == other.jobTaskNo &&
          description == other.description &&
          reason == other.reason &&
          originalQuantity == other.originalQuantity &&
          adjustedQuantity == other.adjustedQuantity &&
          guid == other.guid;

  @override
  String toString() {
    return 'RejectedHourState{rowID: $rowID, internalState: $internalState, etag: $etag, entryNo: $entryNo, jobNo: $jobNo, jobTaskNo: $jobTaskNo, description: $description, reason: $reason, originalQuantity: $originalQuantity, adjustedQuantity: $adjustedQuantity, guid: $guid}';
  }
}
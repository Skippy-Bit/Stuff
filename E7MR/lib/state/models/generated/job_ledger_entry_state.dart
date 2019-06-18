import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';

@immutable
class JobLedgerEntryState {
  final int rowID;
  final int internalState;
  final String etag;

  final int entryNo;
  final String jobNo;
  final DateTime postingDate;
  final int typeAsInt;
  final String no;
  final String description;
  final num quantity;
  final String unitOfMeasureCode;
  final String locationCode;
  final String workTypeCode;
  final String userID;
  final String jobTaskNo;
  final String description2;
  final String lineType;
  final DateTime postingDateTime;
  final List<FieldData> detailFields;

  JobLedgerEntryState({
    this.rowID,
    this.internalState,
    this.etag,
    this.entryNo,
    this.jobNo,
    this.postingDate,
    this.typeAsInt,
    this.no,
    this.description,
    this.quantity,
    this.unitOfMeasureCode,
    this.locationCode,
    this.workTypeCode,
    this.userID,
    this.jobTaskNo,
    this.description2,
    this.lineType,
    this.postingDateTime,
    List<FieldData> detailFields,
  }):
      detailFields = detailFields ?? List<FieldData>();


  JobLedgerEntryState copyWith({
    int rowID,
    int internalState,
    String etag,
    int entryNo,
    String jobNo,
    DateTime postingDate,
    int typeAsInt,
    String no,
    String description,
    num quantity,
    String unitOfMeasureCode,
    String locationCode,
    String workTypeCode,
    String userID,
    String jobTaskNo,
    String description2,
    String lineType,
    DateTime postingDateTime,
    List<FieldData> detailFields,
  }) {
    return JobLedgerEntryState(
      rowID: rowID ?? this.rowID,
      internalState: internalState ?? this.internalState,
      etag: etag ?? this.etag,
      entryNo: entryNo ?? this.entryNo,
      jobNo: jobNo ?? this.jobNo,
      postingDate: postingDate ?? this.postingDate,
      typeAsInt: typeAsInt ?? this.typeAsInt,
      no: no ?? this.no,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitOfMeasureCode: unitOfMeasureCode ?? this.unitOfMeasureCode,
      locationCode: locationCode ?? this.locationCode,
      workTypeCode: workTypeCode ?? this.workTypeCode,
      userID: userID ?? this.userID,
      jobTaskNo: jobTaskNo ?? this.jobTaskNo,
      description2: description2 ?? this.description2,
      lineType: lineType ?? this.lineType,
      postingDateTime: postingDateTime ?? this.postingDateTime,
      detailFields: detailFields ?? this.detailFields,
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
    if (postingDate != null) {
      map['Posting_Date'] = postingDate?.toUtc()?.toIso8601String();
    }
    if (typeAsInt != null) {
      map['TypeAsInt'] = typeAsInt;
    }
    if (no != null) {
      map['No'] = no;
    }
    if (description != null) {
      map['Description'] = description;
    }
    if (quantity != null) {
      map['Quantity'] = quantity;
    }
    if (unitOfMeasureCode != null) {
      map['Unit_of_Measure_Code'] = unitOfMeasureCode;
    }
    if (locationCode != null) {
      map['Location_Code'] = locationCode;
    }
    if (workTypeCode != null) {
      map['Work_Type_Code'] = workTypeCode;
    }
    if (userID != null) {
      map['User_ID'] = userID;
    }
    if (jobTaskNo != null) {
      map['Job_Task_No'] = jobTaskNo;
    }
    if (description2 != null) {
      map['Description_2'] = description2;
    }
    if (lineType != null) {
      map['Line_Type'] = lineType;
    }
    if (postingDateTime != null) {
      map['Posting_Date_Time'] = postingDateTime?.toUtc()?.toIso8601String();
    }
    return map;
  }

  static JobLedgerEntryState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    int internalState,
    List<FieldData> detailFields,
    }
  ) => JobLedgerEntryState(
        rowID: rowID,
        internalState: internalState,
        etag: map['@odata.etag'] as String,
        entryNo: map['Entry_No'] as int,
        jobNo: map['Job_No'] as String,
        postingDate: DateTime.tryParse(map['Posting_Date'] as String ?? ''),
        typeAsInt: map['TypeAsInt'] as int,
        no: map['No'] as String,
        description: map['Description'] as String,
        quantity: map['Quantity'] as num,
        unitOfMeasureCode: map['Unit_of_Measure_Code'] as String,
        locationCode: map['Location_Code'] as String,
        workTypeCode: map['Work_Type_Code'] as String,
        userID: map['User_ID'] as String,
        jobTaskNo: map['Job_Task_No'] as String,
        description2: map['Description_2'] as String,
        lineType: map['Line_Type'] as String,
        postingDateTime: DateTime.tryParse(map['Posting_Date_Time'] as String ?? ''),
        detailFields: detailFields ?? FieldData.decodeAPI(json.decode(map['_DetailFields'])),
      );

  Map<String, dynamic> encodeDB(String username) {
    final map = encodeAPI(fromEncodeDB: true);
    map['_DetailFields'] = json.encode(detailFields.map((f) => f.encodeDB()).toList());
    map['ETag'] = etag ?? '';
    map['_InternalState'] = internalState ?? 0;
    map['User'] = username ?? '';
    return map;
  }

  static JobLedgerEntryState decodeDB(Map<String, dynamic> map) {
    map['@odata.etag'] = map['ETag'];
    return decodeAPI(
      map,
      rowID: map['ROWID'] as int,
      internalState: map['_InternalState'] as int,
      detailFields: (json.decode(map['_DetailFields']) as List)
          .map((f) => FieldData.decodeDB(f))
          .toList(),
    );
  }

  @override
  int get hashCode =>
      rowID.hashCode ^
      internalState.hashCode ^
      etag.hashCode ^
      entryNo.hashCode ^
      jobNo.hashCode ^
      postingDate.hashCode ^
      typeAsInt.hashCode ^
      no.hashCode ^
      description.hashCode ^
      quantity.hashCode ^
      unitOfMeasureCode.hashCode ^
      locationCode.hashCode ^
      workTypeCode.hashCode ^
      userID.hashCode ^
      jobTaskNo.hashCode ^
      description2.hashCode ^
      lineType.hashCode ^
      postingDateTime.hashCode ^
      detailFields.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobLedgerEntryState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          internalState == other.internalState &&
          etag == other.etag &&
          entryNo == other.entryNo &&
          jobNo == other.jobNo &&
          postingDate == other.postingDate &&
          typeAsInt == other.typeAsInt &&
          no == other.no &&
          description == other.description &&
          quantity == other.quantity &&
          unitOfMeasureCode == other.unitOfMeasureCode &&
          locationCode == other.locationCode &&
          workTypeCode == other.workTypeCode &&
          userID == other.userID &&
          jobTaskNo == other.jobTaskNo &&
          description2 == other.description2 &&
          lineType == other.lineType &&
          postingDateTime == other.postingDateTime &&
          detailFields == other.detailFields;

  @override
  String toString() {
    return 'JobLedgerEntryState{rowID: $rowID, internalState: $internalState, etag: $etag, entryNo: $entryNo, jobNo: $jobNo, postingDate: $postingDate, typeAsInt: $typeAsInt, no: $no, description: $description, quantity: $quantity, unitOfMeasureCode: $unitOfMeasureCode, locationCode: $locationCode, workTypeCode: $workTypeCode, userID: $userID, jobTaskNo: $jobTaskNo, description2: $description2, lineType: $lineType, postingDateTime: $postingDateTime, detailFields: $detailFields}';
  }
}
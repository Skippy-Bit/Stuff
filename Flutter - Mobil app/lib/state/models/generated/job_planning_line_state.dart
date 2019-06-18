import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';

@immutable
class JobPlanningLineState {
  final int rowID;
  final int internalState;
  final String etag;

  final String jobNo;
  final String jobTaskNo;
  final int lineNo;
  final int type;
  final String no;
  final num quantity;
  final String description;
  final String unitOfMeasureCode;
  final String description2;
  final List<FieldData> detailFields;

  JobPlanningLineState({
    this.rowID,
    this.internalState,
    this.etag,
    this.jobNo,
    this.jobTaskNo,
    this.lineNo,
    this.type,
    this.no,
    this.quantity,
    this.description,
    this.unitOfMeasureCode,
    this.description2,
    List<FieldData> detailFields,
  }):
      detailFields = detailFields ?? List<FieldData>();


  JobPlanningLineState copyWith({
    int rowID,
    int internalState,
    String etag,
    String jobNo,
    String jobTaskNo,
    int lineNo,
    int type,
    String no,
    num quantity,
    String description,
    String unitOfMeasureCode,
    String description2,
    List<FieldData> detailFields,
  }) {
    return JobPlanningLineState(
      rowID: rowID ?? this.rowID,
      internalState: internalState ?? this.internalState,
      etag: etag ?? this.etag,
      jobNo: jobNo ?? this.jobNo,
      jobTaskNo: jobTaskNo ?? this.jobTaskNo,
      lineNo: lineNo ?? this.lineNo,
      type: type ?? this.type,
      no: no ?? this.no,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      unitOfMeasureCode: unitOfMeasureCode ?? this.unitOfMeasureCode,
      description2: description2 ?? this.description2,
      detailFields: detailFields ?? this.detailFields,
    );
  }

  Map<String, dynamic> encodeAPI({bool fromEncodeDB = false}) {
    final map = HashMap<String, dynamic>();
    if (jobNo != null) {
      map['Job_No'] = jobNo;
    }
    if (jobTaskNo != null) {
      map['Job_Task_No'] = jobTaskNo;
    }
    if (lineNo != null) {
      map['Line_No'] = lineNo;
    }
    if (type != null) {
      map['Type'] = type;
    }
    if (no != null) {
      map['No'] = no;
    }
    if (quantity != null) {
      map['Quantity'] = quantity;
    }
    if (description != null) {
      map['Description'] = description;
    }
    if (unitOfMeasureCode != null) {
      map['Unit_of_Measure_Code'] = unitOfMeasureCode;
    }
    if (description2 != null) {
      map['Description_2'] = description2;
    }
    return map;
  }

  static JobPlanningLineState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    int internalState,
    List<FieldData> detailFields,
    }
  ) => JobPlanningLineState(
        rowID: rowID,
        internalState: internalState,
        etag: map['@odata.etag'] as String,
        jobNo: map['Job_No'] as String,
        jobTaskNo: map['Job_Task_No'] as String,
        lineNo: map['Line_No'] as int,
        type: map['Type'] as int,
        no: map['No'] as String,
        quantity: map['Quantity'] as num,
        description: map['Description'] as String,
        unitOfMeasureCode: map['Unit_of_Measure_Code'] as String,
        description2: map['Description_2'] as String,
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

  static JobPlanningLineState decodeDB(Map<String, dynamic> map) {
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
      jobNo.hashCode ^
      jobTaskNo.hashCode ^
      lineNo.hashCode ^
      type.hashCode ^
      no.hashCode ^
      quantity.hashCode ^
      description.hashCode ^
      unitOfMeasureCode.hashCode ^
      description2.hashCode ^
      detailFields.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobPlanningLineState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          internalState == other.internalState &&
          etag == other.etag &&
          jobNo == other.jobNo &&
          jobTaskNo == other.jobTaskNo &&
          lineNo == other.lineNo &&
          type == other.type &&
          no == other.no &&
          quantity == other.quantity &&
          description == other.description &&
          unitOfMeasureCode == other.unitOfMeasureCode &&
          description2 == other.description2 &&
          detailFields == other.detailFields;

  @override
  String toString() {
    return 'JobPlanningLineState{rowID: $rowID, internalState: $internalState, etag: $etag, jobNo: $jobNo, jobTaskNo: $jobTaskNo, lineNo: $lineNo, type: $type, no: $no, quantity: $quantity, description: $description, unitOfMeasureCode: $unitOfMeasureCode, description2: $description2, detailFields: $detailFields}';
  }
}
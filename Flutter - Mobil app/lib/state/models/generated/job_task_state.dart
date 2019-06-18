import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';

@immutable
class JobTaskState {
  final int rowID;
  final int internalState;
  final String etag;

  final String jobNo;
  final String jobTaskNo;
  final String description;
  final String jobTaskType;
  final DateTime startDate;
  final DateTime endDate;
  final String personResponsible;
  final String personResponsibleName;
  final List<FieldData> detailFields;

  JobTaskState({
    this.rowID,
    this.internalState,
    this.etag,
    this.jobNo,
    this.jobTaskNo,
    this.description,
    this.jobTaskType,
    this.startDate,
    this.endDate,
    this.personResponsible,
    this.personResponsibleName,
    List<FieldData> detailFields,
  }):
      detailFields = detailFields ?? List<FieldData>();


  JobTaskState copyWith({
    int rowID,
    int internalState,
    String etag,
    String jobNo,
    String jobTaskNo,
    String description,
    String jobTaskType,
    DateTime startDate,
    DateTime endDate,
    String personResponsible,
    String personResponsibleName,
    List<FieldData> detailFields,
  }) {
    return JobTaskState(
      rowID: rowID ?? this.rowID,
      internalState: internalState ?? this.internalState,
      etag: etag ?? this.etag,
      jobNo: jobNo ?? this.jobNo,
      jobTaskNo: jobTaskNo ?? this.jobTaskNo,
      description: description ?? this.description,
      jobTaskType: jobTaskType ?? this.jobTaskType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      personResponsible: personResponsible ?? this.personResponsible,
      personResponsibleName: personResponsibleName ?? this.personResponsibleName,
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
    if (description != null) {
      map['Description'] = description;
    }
    if (jobTaskType != null) {
      map['Job_Task_Type'] = jobTaskType;
    }
    if (startDate != null) {
      map['Start_Date'] = startDate?.toUtc()?.toIso8601String();
    }
    if (endDate != null) {
      map['End_Date'] = endDate?.toUtc()?.toIso8601String();
    }
    if (personResponsible != null) {
      map['Person_Responsible'] = personResponsible;
    }
    if (personResponsibleName != null) {
      map['PersonResponsibleName'] = personResponsibleName;
    }
    return map;
  }

  static JobTaskState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    int internalState,
    List<FieldData> detailFields,
    }
  ) => JobTaskState(
        rowID: rowID,
        internalState: internalState,
        etag: map['@odata.etag'] as String,
        jobNo: map['Job_No'] as String,
        jobTaskNo: map['Job_Task_No'] as String,
        description: map['Description'] as String,
        jobTaskType: map['Job_Task_Type'] as String,
        startDate: DateTime.tryParse(map['Start_Date'] as String ?? ''),
        endDate: DateTime.tryParse(map['End_Date'] as String ?? ''),
        personResponsible: map['Person_Responsible'] as String,
        personResponsibleName: map['PersonResponsibleName'] as String,
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

  static JobTaskState decodeDB(Map<String, dynamic> map) {
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
      description.hashCode ^
      jobTaskType.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      personResponsible.hashCode ^
      personResponsibleName.hashCode ^
      detailFields.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobTaskState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          internalState == other.internalState &&
          etag == other.etag &&
          jobNo == other.jobNo &&
          jobTaskNo == other.jobTaskNo &&
          description == other.description &&
          jobTaskType == other.jobTaskType &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          personResponsible == other.personResponsible &&
          personResponsibleName == other.personResponsibleName &&
          detailFields == other.detailFields;

  @override
  String toString() {
    return 'JobTaskState{rowID: $rowID, internalState: $internalState, etag: $etag, jobNo: $jobNo, jobTaskNo: $jobTaskNo, description: $description, jobTaskType: $jobTaskType, startDate: $startDate, endDate: $endDate, personResponsible: $personResponsible, personResponsibleName: $personResponsibleName, detailFields: $detailFields}';
  }
}
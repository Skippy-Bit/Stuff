import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';

@immutable
class JobJournalLineState {
  final int rowID;
  final int internalState;
  final String etag;

  final String journalTemplateName;
  final String journalBatchName;
  final int lineNo;
  final String jobNo;
  final String jobTaskNo;
  final DateTime postingDate;
  final String documentNo;
  final int typeAsInt;
  final String no;
  final String description;
  final num quantity;
  final String unitOfMeasureCode;
  final String locationCode;
  final String workTypeCode;
  final String serialNo;
  final String lotNo;
  final String extendedDescription;
  final DateTime postingDateTime;
  final String userID;
  final String userName;
  final String uuid;
  final List<FieldData> detailFields;

  JobJournalLineState({
    this.rowID,
    this.internalState,
    this.etag,
    this.journalTemplateName,
    this.journalBatchName,
    this.lineNo,
    this.jobNo,
    this.jobTaskNo,
    this.postingDate,
    this.documentNo,
    this.typeAsInt,
    this.no,
    this.description,
    this.quantity,
    this.unitOfMeasureCode,
    this.locationCode,
    this.workTypeCode,
    this.serialNo,
    this.lotNo,
    this.extendedDescription,
    this.postingDateTime,
    this.userID,
    this.userName,
    this.uuid,
    List<FieldData> detailFields,
  }):
      detailFields = detailFields ?? List<FieldData>();


  JobJournalLineState copyWith({
    int rowID,
    int internalState,
    String etag,
    String journalTemplateName,
    String journalBatchName,
    int lineNo,
    String jobNo,
    String jobTaskNo,
    DateTime postingDate,
    String documentNo,
    int typeAsInt,
    String no,
    String description,
    num quantity,
    String unitOfMeasureCode,
    String locationCode,
    String workTypeCode,
    String serialNo,
    String lotNo,
    String extendedDescription,
    DateTime postingDateTime,
    String userID,
    String userName,
    String uuid,
    List<FieldData> detailFields,
  }) {
    return JobJournalLineState(
      rowID: rowID ?? this.rowID,
      internalState: internalState ?? this.internalState,
      etag: etag ?? this.etag,
      journalTemplateName: journalTemplateName ?? this.journalTemplateName,
      journalBatchName: journalBatchName ?? this.journalBatchName,
      lineNo: lineNo ?? this.lineNo,
      jobNo: jobNo ?? this.jobNo,
      jobTaskNo: jobTaskNo ?? this.jobTaskNo,
      postingDate: postingDate ?? this.postingDate,
      documentNo: documentNo ?? this.documentNo,
      typeAsInt: typeAsInt ?? this.typeAsInt,
      no: no ?? this.no,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitOfMeasureCode: unitOfMeasureCode ?? this.unitOfMeasureCode,
      locationCode: locationCode ?? this.locationCode,
      workTypeCode: workTypeCode ?? this.workTypeCode,
      serialNo: serialNo ?? this.serialNo,
      lotNo: lotNo ?? this.lotNo,
      extendedDescription: extendedDescription ?? this.extendedDescription,
      postingDateTime: postingDateTime ?? this.postingDateTime,
      userID: userID ?? this.userID,
      userName: userName ?? this.userName,
      uuid: uuid ?? this.uuid,
      detailFields: detailFields ?? this.detailFields,
    );
  }

  Map<String, dynamic> encodeAPI({bool fromEncodeDB = false}) {
    final map = HashMap<String, dynamic>();
    if (journalTemplateName != null) {
      map['Journal_Template_Name'] = journalTemplateName;
    }
    if (journalBatchName != null) {
      map['Journal_Batch_Name'] = journalBatchName;
    }
    if (lineNo != null) {
      map['Line_No'] = lineNo;
    }
    if (jobNo != null) {
      map['Job_No'] = jobNo;
    }
    if (jobTaskNo != null) {
      map['Job_Task_No'] = jobTaskNo;
    }
    if (postingDate != null) {
      map['Posting_Date'] = postingDate?.toUtc()?.toIso8601String();
    }
    if (documentNo != null) {
      map['Document_No'] = documentNo;
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
    if (serialNo != null) {
      map['Serial_No'] = serialNo;
    }
    if (lotNo != null) {
      map['Lot_No'] = lotNo;
    }
    if (extendedDescription != null) {
      map['Extended_Description'] = extendedDescription;
    }
    if (postingDateTime != null) {
      map['Posting_Date_Time'] = postingDateTime?.toUtc()?.toIso8601String();
    }
    if (userID != null) {
      map['User_ID'] = userID;
    }
    if (userName != null) {
      map['UserName'] = userName;
    }
    if (uuid != null) {
      map['UUID'] = uuid;
    }
    return map;
  }

  static JobJournalLineState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    int internalState,
    List<FieldData> detailFields,
    }
  ) => JobJournalLineState(
        rowID: rowID,
        internalState: internalState,
        etag: map['@odata.etag'] as String,
        journalTemplateName: map['Journal_Template_Name'] as String,
        journalBatchName: map['Journal_Batch_Name'] as String,
        lineNo: map['Line_No'] as int,
        jobNo: map['Job_No'] as String,
        jobTaskNo: map['Job_Task_No'] as String,
        postingDate: DateTime.tryParse(map['Posting_Date'] as String ?? ''),
        documentNo: map['Document_No'] as String,
        typeAsInt: map['TypeAsInt'] as int,
        no: map['No'] as String,
        description: map['Description'] as String,
        quantity: map['Quantity'] as num,
        unitOfMeasureCode: map['Unit_of_Measure_Code'] as String,
        locationCode: map['Location_Code'] as String,
        workTypeCode: map['Work_Type_Code'] as String,
        serialNo: map['Serial_No'] as String,
        lotNo: map['Lot_No'] as String,
        extendedDescription: map['Extended_Description'] as String,
        postingDateTime: DateTime.tryParse(map['Posting_Date_Time'] as String ?? ''),
        userID: map['User_ID'] as String,
        userName: map['UserName'] as String,
        uuid: map['UUID'] as String,
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

  static JobJournalLineState decodeDB(Map<String, dynamic> map) {
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
      journalTemplateName.hashCode ^
      journalBatchName.hashCode ^
      lineNo.hashCode ^
      jobNo.hashCode ^
      jobTaskNo.hashCode ^
      postingDate.hashCode ^
      documentNo.hashCode ^
      typeAsInt.hashCode ^
      no.hashCode ^
      description.hashCode ^
      quantity.hashCode ^
      unitOfMeasureCode.hashCode ^
      locationCode.hashCode ^
      workTypeCode.hashCode ^
      serialNo.hashCode ^
      lotNo.hashCode ^
      extendedDescription.hashCode ^
      postingDateTime.hashCode ^
      userID.hashCode ^
      userName.hashCode ^
      uuid.hashCode ^
      detailFields.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobJournalLineState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          internalState == other.internalState &&
          etag == other.etag &&
          journalTemplateName == other.journalTemplateName &&
          journalBatchName == other.journalBatchName &&
          lineNo == other.lineNo &&
          jobNo == other.jobNo &&
          jobTaskNo == other.jobTaskNo &&
          postingDate == other.postingDate &&
          documentNo == other.documentNo &&
          typeAsInt == other.typeAsInt &&
          no == other.no &&
          description == other.description &&
          quantity == other.quantity &&
          unitOfMeasureCode == other.unitOfMeasureCode &&
          locationCode == other.locationCode &&
          workTypeCode == other.workTypeCode &&
          serialNo == other.serialNo &&
          lotNo == other.lotNo &&
          extendedDescription == other.extendedDescription &&
          postingDateTime == other.postingDateTime &&
          userID == other.userID &&
          userName == other.userName &&
          uuid == other.uuid &&
          detailFields == other.detailFields;

  @override
  String toString() {
    return 'JobJournalLineState{rowID: $rowID, internalState: $internalState, etag: $etag, journalTemplateName: $journalTemplateName, journalBatchName: $journalBatchName, lineNo: $lineNo, jobNo: $jobNo, jobTaskNo: $jobTaskNo, postingDate: $postingDate, documentNo: $documentNo, typeAsInt: $typeAsInt, no: $no, description: $description, quantity: $quantity, unitOfMeasureCode: $unitOfMeasureCode, locationCode: $locationCode, workTypeCode: $workTypeCode, serialNo: $serialNo, lotNo: $lotNo, extendedDescription: $extendedDescription, postingDateTime: $postingDateTime, userID: $userID, userName: $userName, uuid: $uuid, detailFields: $detailFields}';
  }
}
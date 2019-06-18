import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';

@immutable
class JobState {
  final int rowID;
  final int internalState;
  final String etag;

  final String no;
  final String description;
  final DateTime startingDate;
  final DateTime endingDate;
  final String status;
  final String personResponsible;
  final String personResponsibleName;
  final String projectManager;
  final String projectManagerName;
  final String shipToName;
  final String shipToName2;
  final String shipToContact;
  final String shipToAddress;
  final String shipToAddress2;
  final String shipToCity;
  final String shipToPostCode;
  final String billToName;
  final String billToAddress;
  final String billToCity;
  final String billToCounty;
  final String billToPostCode;
  final String billToCountryRegionCode;
  final String billToContact;
  final DateTime lastDateModified;
  final List<FieldData> detailFields;

  JobState({
    this.rowID,
    this.internalState,
    this.etag,
    this.no,
    this.description,
    this.startingDate,
    this.endingDate,
    this.status,
    this.personResponsible,
    this.personResponsibleName,
    this.projectManager,
    this.projectManagerName,
    this.shipToName,
    this.shipToName2,
    this.shipToContact,
    this.shipToAddress,
    this.shipToAddress2,
    this.shipToCity,
    this.shipToPostCode,
    this.billToName,
    this.billToAddress,
    this.billToCity,
    this.billToCounty,
    this.billToPostCode,
    this.billToCountryRegionCode,
    this.billToContact,
    this.lastDateModified,
    List<FieldData> detailFields,
  }):
      detailFields = detailFields ?? List<FieldData>();


  JobState copyWith({
    int rowID,
    int internalState,
    String etag,
    String no,
    String description,
    DateTime startingDate,
    DateTime endingDate,
    String status,
    String personResponsible,
    String personResponsibleName,
    String projectManager,
    String projectManagerName,
    String shipToName,
    String shipToName2,
    String shipToContact,
    String shipToAddress,
    String shipToAddress2,
    String shipToCity,
    String shipToPostCode,
    String billToName,
    String billToAddress,
    String billToCity,
    String billToCounty,
    String billToPostCode,
    String billToCountryRegionCode,
    String billToContact,
    DateTime lastDateModified,
    List<FieldData> detailFields,
  }) {
    return JobState(
      rowID: rowID ?? this.rowID,
      internalState: internalState ?? this.internalState,
      etag: etag ?? this.etag,
      no: no ?? this.no,
      description: description ?? this.description,
      startingDate: startingDate ?? this.startingDate,
      endingDate: endingDate ?? this.endingDate,
      status: status ?? this.status,
      personResponsible: personResponsible ?? this.personResponsible,
      personResponsibleName: personResponsibleName ?? this.personResponsibleName,
      projectManager: projectManager ?? this.projectManager,
      projectManagerName: projectManagerName ?? this.projectManagerName,
      shipToName: shipToName ?? this.shipToName,
      shipToName2: shipToName2 ?? this.shipToName2,
      shipToContact: shipToContact ?? this.shipToContact,
      shipToAddress: shipToAddress ?? this.shipToAddress,
      shipToAddress2: shipToAddress2 ?? this.shipToAddress2,
      shipToCity: shipToCity ?? this.shipToCity,
      shipToPostCode: shipToPostCode ?? this.shipToPostCode,
      billToName: billToName ?? this.billToName,
      billToAddress: billToAddress ?? this.billToAddress,
      billToCity: billToCity ?? this.billToCity,
      billToCounty: billToCounty ?? this.billToCounty,
      billToPostCode: billToPostCode ?? this.billToPostCode,
      billToCountryRegionCode: billToCountryRegionCode ?? this.billToCountryRegionCode,
      billToContact: billToContact ?? this.billToContact,
      lastDateModified: lastDateModified ?? this.lastDateModified,
      detailFields: detailFields ?? this.detailFields,
    );
  }

  Map<String, dynamic> encodeAPI({bool fromEncodeDB = false}) {
    final map = HashMap<String, dynamic>();
    if (no != null) {
      map['No'] = no;
    }
    if (description != null) {
      map['Description'] = description;
    }
    if (startingDate != null) {
      map['Starting_Date'] = startingDate?.toUtc()?.toIso8601String();
    }
    if (endingDate != null) {
      map['Ending_Date'] = endingDate?.toUtc()?.toIso8601String();
    }
    if (status != null) {
      map['Status'] = status;
    }
    if (personResponsible != null) {
      map['Person_Responsible'] = personResponsible;
    }
    if (personResponsibleName != null) {
      map['PersonResponsibleName'] = personResponsibleName;
    }
    if (projectManager != null) {
      map['Project_Manager'] = projectManager;
    }
    if (projectManagerName != null) {
      map['Project_Manager_Name'] = projectManagerName;
    }
    if (shipToName != null) {
      map['Ship_to_Name'] = shipToName;
    }
    if (shipToName2 != null) {
      map['Ship_to_Name_2'] = shipToName2;
    }
    if (shipToContact != null) {
      map['Ship_to_Contact'] = shipToContact;
    }
    if (shipToAddress != null) {
      map['Ship_to_Address'] = shipToAddress;
    }
    if (shipToAddress2 != null) {
      map['Ship_to_Address_2'] = shipToAddress2;
    }
    if (shipToCity != null) {
      map['Ship_to_City'] = shipToCity;
    }
    if (shipToPostCode != null) {
      map['Ship_to_Post_Code'] = shipToPostCode;
    }
    if (billToName != null) {
      map['Bill_to_Name'] = billToName;
    }
    if (billToAddress != null) {
      map['Bill_to_Address'] = billToAddress;
    }
    if (billToCity != null) {
      map['Bill_to_City'] = billToCity;
    }
    if (billToCounty != null) {
      map['Bill_to_County'] = billToCounty;
    }
    if (billToPostCode != null) {
      map['Bill_to_Post_Code'] = billToPostCode;
    }
    if (billToCountryRegionCode != null) {
      map['Bill_to_Country_Region_Code'] = billToCountryRegionCode;
    }
    if (billToContact != null) {
      map['Bill_to_Contact'] = billToContact;
    }
    if (lastDateModified != null) {
      map['Last_Date_Modified'] = lastDateModified?.toUtc()?.toIso8601String();
    }
    return map;
  }

  static JobState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    int internalState,
    List<FieldData> detailFields,
    }
  ) => JobState(
        rowID: rowID,
        internalState: internalState,
        etag: map['@odata.etag'] as String,
        no: map['No'] as String,
        description: map['Description'] as String,
        startingDate: DateTime.tryParse(map['Starting_Date'] as String ?? ''),
        endingDate: DateTime.tryParse(map['Ending_Date'] as String ?? ''),
        status: map['Status'] as String,
        personResponsible: map['Person_Responsible'] as String,
        personResponsibleName: map['PersonResponsibleName'] as String,
        projectManager: map['Project_Manager'] as String,
        projectManagerName: map['Project_Manager_Name'] as String,
        shipToName: map['Ship_to_Name'] as String,
        shipToName2: map['Ship_to_Name_2'] as String,
        shipToContact: map['Ship_to_Contact'] as String,
        shipToAddress: map['Ship_to_Address'] as String,
        shipToAddress2: map['Ship_to_Address_2'] as String,
        shipToCity: map['Ship_to_City'] as String,
        shipToPostCode: map['Ship_to_Post_Code'] as String,
        billToName: map['Bill_to_Name'] as String,
        billToAddress: map['Bill_to_Address'] as String,
        billToCity: map['Bill_to_City'] as String,
        billToCounty: map['Bill_to_County'] as String,
        billToPostCode: map['Bill_to_Post_Code'] as String,
        billToCountryRegionCode: map['Bill_to_Country_Region_Code'] as String,
        billToContact: map['Bill_to_Contact'] as String,
        lastDateModified: DateTime.tryParse(map['Last_Date_Modified'] as String ?? ''),
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

  static JobState decodeDB(Map<String, dynamic> map) {
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
      no.hashCode ^
      description.hashCode ^
      startingDate.hashCode ^
      endingDate.hashCode ^
      status.hashCode ^
      personResponsible.hashCode ^
      personResponsibleName.hashCode ^
      projectManager.hashCode ^
      projectManagerName.hashCode ^
      shipToName.hashCode ^
      shipToName2.hashCode ^
      shipToContact.hashCode ^
      shipToAddress.hashCode ^
      shipToAddress2.hashCode ^
      shipToCity.hashCode ^
      shipToPostCode.hashCode ^
      billToName.hashCode ^
      billToAddress.hashCode ^
      billToCity.hashCode ^
      billToCounty.hashCode ^
      billToPostCode.hashCode ^
      billToCountryRegionCode.hashCode ^
      billToContact.hashCode ^
      lastDateModified.hashCode ^
      detailFields.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          internalState == other.internalState &&
          etag == other.etag &&
          no == other.no &&
          description == other.description &&
          startingDate == other.startingDate &&
          endingDate == other.endingDate &&
          status == other.status &&
          personResponsible == other.personResponsible &&
          personResponsibleName == other.personResponsibleName &&
          projectManager == other.projectManager &&
          projectManagerName == other.projectManagerName &&
          shipToName == other.shipToName &&
          shipToName2 == other.shipToName2 &&
          shipToContact == other.shipToContact &&
          shipToAddress == other.shipToAddress &&
          shipToAddress2 == other.shipToAddress2 &&
          shipToCity == other.shipToCity &&
          shipToPostCode == other.shipToPostCode &&
          billToName == other.billToName &&
          billToAddress == other.billToAddress &&
          billToCity == other.billToCity &&
          billToCounty == other.billToCounty &&
          billToPostCode == other.billToPostCode &&
          billToCountryRegionCode == other.billToCountryRegionCode &&
          billToContact == other.billToContact &&
          lastDateModified == other.lastDateModified &&
          detailFields == other.detailFields;

  @override
  String toString() {
    return 'JobState{rowID: $rowID, internalState: $internalState, etag: $etag, no: $no, description: $description, startingDate: $startingDate, endingDate: $endingDate, status: $status, personResponsible: $personResponsible, personResponsibleName: $personResponsibleName, projectManager: $projectManager, projectManagerName: $projectManagerName, shipToName: $shipToName, shipToName2: $shipToName2, shipToContact: $shipToContact, shipToAddress: $shipToAddress, shipToAddress2: $shipToAddress2, shipToCity: $shipToCity, shipToPostCode: $shipToPostCode, billToName: $billToName, billToAddress: $billToAddress, billToCity: $billToCity, billToCounty: $billToCounty, billToPostCode: $billToPostCode, billToCountryRegionCode: $billToCountryRegionCode, billToContact: $billToContact, lastDateModified: $lastDateModified, detailFields: $detailFields}';
  }
}
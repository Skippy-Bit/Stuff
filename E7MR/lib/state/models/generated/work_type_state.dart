import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';

@immutable
class WorkTypeState {
  final int rowID;
  final int internalState;
  final String etag;

  final String code;
  final String description;
  final String unitOfMeasureCode;

  WorkTypeState({
    this.rowID,
    this.internalState,
    this.etag,
    this.code,
    this.description,
    this.unitOfMeasureCode,
  });


  WorkTypeState copyWith({
    int rowID,
    int internalState,
    String etag,
    String code,
    String description,
    String unitOfMeasureCode,
  }) {
    return WorkTypeState(
      rowID: rowID ?? this.rowID,
      internalState: internalState ?? this.internalState,
      etag: etag ?? this.etag,
      code: code ?? this.code,
      description: description ?? this.description,
      unitOfMeasureCode: unitOfMeasureCode ?? this.unitOfMeasureCode,
    );
  }

  Map<String, dynamic> encodeAPI({bool fromEncodeDB = false}) {
    final map = HashMap<String, dynamic>();
    if (code != null) {
      map['Code'] = code;
    }
    if (description != null) {
      map['Description'] = description;
    }
    if (unitOfMeasureCode != null) {
      map['Unit_of_Measure_Code'] = unitOfMeasureCode;
    }
    return map;
  }

  static WorkTypeState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    int internalState,
    }
  ) => WorkTypeState(
        rowID: rowID,
        internalState: internalState,
        etag: map['@odata.etag'] as String,
        code: map['Code'] as String,
        description: map['Description'] as String,
        unitOfMeasureCode: map['Unit_of_Measure_Code'] as String,
      );

  Map<String, dynamic> encodeDB(String username) {
    final map = encodeAPI(fromEncodeDB: true);
    map['ETag'] = etag ?? '';
    map['_InternalState'] = internalState ?? 0;
    map['User'] = username ?? '';
    return map;
  }

  static WorkTypeState decodeDB(Map<String, dynamic> map) {
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
      code.hashCode ^
      description.hashCode ^
      unitOfMeasureCode.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkTypeState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          internalState == other.internalState &&
          etag == other.etag &&
          code == other.code &&
          description == other.description &&
          unitOfMeasureCode == other.unitOfMeasureCode;

  @override
  String toString() {
    return 'WorkTypeState{rowID: $rowID, internalState: $internalState, etag: $etag, code: $code, description: $description, unitOfMeasureCode: $unitOfMeasureCode}';
  }
}
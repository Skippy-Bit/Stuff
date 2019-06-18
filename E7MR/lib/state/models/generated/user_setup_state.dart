import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';

@immutable
class UserSetupState {
  final int rowID;
  final int internalState;
  final String etag;

  final String userID;
  final String resourceNo;
  final String auxiliaryLocation;
  final String warehouseLocation;

  UserSetupState({
    this.rowID,
    this.internalState,
    this.etag,
    this.userID,
    this.resourceNo,
    this.auxiliaryLocation,
    this.warehouseLocation,
  });


  UserSetupState copyWith({
    int rowID,
    int internalState,
    String etag,
    String userID,
    String resourceNo,
    String auxiliaryLocation,
    String warehouseLocation,
  }) {
    return UserSetupState(
      rowID: rowID ?? this.rowID,
      internalState: internalState ?? this.internalState,
      etag: etag ?? this.etag,
      userID: userID ?? this.userID,
      resourceNo: resourceNo ?? this.resourceNo,
      auxiliaryLocation: auxiliaryLocation ?? this.auxiliaryLocation,
      warehouseLocation: warehouseLocation ?? this.warehouseLocation,
    );
  }

  Map<String, dynamic> encodeAPI({bool fromEncodeDB = false}) {
    final map = HashMap<String, dynamic>();
    if (userID != null) {
      map['User_ID'] = userID;
    }
    if (resourceNo != null) {
      map['Resource_No'] = resourceNo;
    }
    if (auxiliaryLocation != null) {
      map['Auxiliary_Location'] = auxiliaryLocation;
    }
    if (warehouseLocation != null) {
      map['Warehouse_Location'] = warehouseLocation;
    }
    return map;
  }

  static UserSetupState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    int internalState,
    }
  ) => UserSetupState(
        rowID: rowID,
        internalState: internalState,
        etag: map['@odata.etag'] as String,
        userID: map['User_ID'] as String,
        resourceNo: map['Resource_No'] as String,
        auxiliaryLocation: map['Auxiliary_Location'] as String,
        warehouseLocation: map['Warehouse_Location'] as String,
      );

  Map<String, dynamic> encodeDB(String username) {
    final map = encodeAPI(fromEncodeDB: true);
    map['ETag'] = etag ?? '';
    map['_InternalState'] = internalState ?? 0;
    map['User'] = username ?? '';
    return map;
  }

  static UserSetupState decodeDB(Map<String, dynamic> map) {
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
      userID.hashCode ^
      resourceNo.hashCode ^
      auxiliaryLocation.hashCode ^
      warehouseLocation.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSetupState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          internalState == other.internalState &&
          etag == other.etag &&
          userID == other.userID &&
          resourceNo == other.resourceNo &&
          auxiliaryLocation == other.auxiliaryLocation &&
          warehouseLocation == other.warehouseLocation;

  @override
  String toString() {
    return 'UserSetupState{rowID: $rowID, internalState: $internalState, etag: $etag, userID: $userID, resourceNo: $resourceNo, auxiliaryLocation: $auxiliaryLocation, warehouseLocation: $warehouseLocation}';
  }
}
import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';

@immutable
class UserLocationState {
  final int rowID;
  final int internalState;
  final String etag;

  final String userID;
  final String locationCode;

  UserLocationState({
    this.rowID,
    this.internalState,
    this.etag,
    this.userID,
    this.locationCode,
  });


  UserLocationState copyWith({
    int rowID,
    int internalState,
    String etag,
    String userID,
    String locationCode,
  }) {
    return UserLocationState(
      rowID: rowID ?? this.rowID,
      internalState: internalState ?? this.internalState,
      etag: etag ?? this.etag,
      userID: userID ?? this.userID,
      locationCode: locationCode ?? this.locationCode,
    );
  }

  Map<String, dynamic> encodeAPI({bool fromEncodeDB = false}) {
    final map = HashMap<String, dynamic>();
    if (userID != null) {
      map['User_ID'] = userID;
    }
    if (locationCode != null) {
      map['Location_Code'] = locationCode;
    }
    return map;
  }

  static UserLocationState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    int internalState,
    }
  ) => UserLocationState(
        rowID: rowID,
        internalState: internalState,
        etag: map['@odata.etag'] as String,
        userID: map['User_ID'] as String,
        locationCode: map['Location_Code'] as String,
      );

  Map<String, dynamic> encodeDB(String username) {
    final map = encodeAPI(fromEncodeDB: true);
    map['ETag'] = etag ?? '';
    map['_InternalState'] = internalState ?? 0;
    map['User'] = username ?? '';
    return map;
  }

  static UserLocationState decodeDB(Map<String, dynamic> map) {
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
      locationCode.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLocationState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          internalState == other.internalState &&
          etag == other.etag &&
          userID == other.userID &&
          locationCode == other.locationCode;

  @override
  String toString() {
    return 'UserLocationState{rowID: $rowID, internalState: $internalState, etag: $etag, userID: $userID, locationCode: $locationCode}';
  }
}
import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';

@immutable
class SetupState {
  final int rowID;
  final int internalState;
  final String etag;

  final int primaryKey;
  final num maxHoursPerDay;
  final String maxHoursPerDayWorkTypes;
  final bool hourDescriptionRequired;
  final int hourDateOffsetBackward;
  final int hourDateOffsetForward;
  final String hourQuantityShortcuts;
  final num hourQuantityIncrement;
  final num hourQuantityDecrement;

  SetupState({
    this.rowID,
    this.internalState,
    this.etag,
    this.primaryKey,
    this.maxHoursPerDay,
    this.maxHoursPerDayWorkTypes,
    this.hourDescriptionRequired,
    this.hourDateOffsetBackward,
    this.hourDateOffsetForward,
    this.hourQuantityShortcuts,
    this.hourQuantityIncrement,
    this.hourQuantityDecrement,
  });


  SetupState copyWith({
    int rowID,
    int internalState,
    String etag,
    int primaryKey,
    num maxHoursPerDay,
    String maxHoursPerDayWorkTypes,
    bool hourDescriptionRequired,
    int hourDateOffsetBackward,
    int hourDateOffsetForward,
    String hourQuantityShortcuts,
    num hourQuantityIncrement,
    num hourQuantityDecrement,
  }) {
    return SetupState(
      rowID: rowID ?? this.rowID,
      internalState: internalState ?? this.internalState,
      etag: etag ?? this.etag,
      primaryKey: primaryKey ?? this.primaryKey,
      maxHoursPerDay: maxHoursPerDay ?? this.maxHoursPerDay,
      maxHoursPerDayWorkTypes: maxHoursPerDayWorkTypes ?? this.maxHoursPerDayWorkTypes,
      hourDescriptionRequired: hourDescriptionRequired ?? this.hourDescriptionRequired,
      hourDateOffsetBackward: hourDateOffsetBackward ?? this.hourDateOffsetBackward,
      hourDateOffsetForward: hourDateOffsetForward ?? this.hourDateOffsetForward,
      hourQuantityShortcuts: hourQuantityShortcuts ?? this.hourQuantityShortcuts,
      hourQuantityIncrement: hourQuantityIncrement ?? this.hourQuantityIncrement,
      hourQuantityDecrement: hourQuantityDecrement ?? this.hourQuantityDecrement,
    );
  }

  Map<String, dynamic> encodeAPI({bool fromEncodeDB = false}) {
    final map = HashMap<String, dynamic>();
    if (primaryKey != null) {
      map['Primary_Key'] = primaryKey;
    }
    if (maxHoursPerDay != null) {
      map['Max_Hours_per_Day'] = maxHoursPerDay;
    }
    if (maxHoursPerDayWorkTypes != null) {
      map['Max_Hours_per_Day_Work_Types'] = maxHoursPerDayWorkTypes;
    }
    if (hourDescriptionRequired != null) {
      map['Hour_Description_Required'] = hourDescriptionRequired;
    }
    if (hourDateOffsetBackward != null) {
      map['Hour_Date_Offset_Backward'] = hourDateOffsetBackward;
    }
    if (hourDateOffsetForward != null) {
      map['Hour_Date_Offset_Forward'] = hourDateOffsetForward;
    }
    if (hourQuantityShortcuts != null) {
      map['Hour_Quantity_Shortcuts'] = hourQuantityShortcuts;
    }
    if (hourQuantityIncrement != null) {
      map['Hour_Quantity_Increment'] = hourQuantityIncrement;
    }
    if (hourQuantityDecrement != null) {
      map['Hour_Quantity_Decrement'] = hourQuantityDecrement;
    }
    return map;
  }

  static SetupState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    int internalState,
    }
  ) => SetupState(
        rowID: rowID,
        internalState: internalState,
        etag: map['@odata.etag'] as String,
        primaryKey: map['Primary_Key'] as int,
        maxHoursPerDay: map['Max_Hours_per_Day'] as num,
        maxHoursPerDayWorkTypes: map['Max_Hours_per_Day_Work_Types'] as String,
        hourDescriptionRequired: map['Hour_Description_Required'] is bool ? map['Hour_Description_Required'] : map['Hour_Description_Required'] as int == 1,
        hourDateOffsetBackward: map['Hour_Date_Offset_Backward'] as int,
        hourDateOffsetForward: map['Hour_Date_Offset_Forward'] as int,
        hourQuantityShortcuts: map['Hour_Quantity_Shortcuts'] as String,
        hourQuantityIncrement: map['Hour_Quantity_Increment'] as num,
        hourQuantityDecrement: map['Hour_Quantity_Decrement'] as num,
      );

  Map<String, dynamic> encodeDB(String username) {
    final map = encodeAPI(fromEncodeDB: true);
    map['ETag'] = etag ?? '';
    map['_InternalState'] = internalState ?? 0;
    map['User'] = username ?? '';
    return map;
  }

  static SetupState decodeDB(Map<String, dynamic> map) {
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
      primaryKey.hashCode ^
      maxHoursPerDay.hashCode ^
      maxHoursPerDayWorkTypes.hashCode ^
      hourDescriptionRequired.hashCode ^
      hourDateOffsetBackward.hashCode ^
      hourDateOffsetForward.hashCode ^
      hourQuantityShortcuts.hashCode ^
      hourQuantityIncrement.hashCode ^
      hourQuantityDecrement.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetupState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          internalState == other.internalState &&
          etag == other.etag &&
          primaryKey == other.primaryKey &&
          maxHoursPerDay == other.maxHoursPerDay &&
          maxHoursPerDayWorkTypes == other.maxHoursPerDayWorkTypes &&
          hourDescriptionRequired == other.hourDescriptionRequired &&
          hourDateOffsetBackward == other.hourDateOffsetBackward &&
          hourDateOffsetForward == other.hourDateOffsetForward &&
          hourQuantityShortcuts == other.hourQuantityShortcuts &&
          hourQuantityIncrement == other.hourQuantityIncrement &&
          hourQuantityDecrement == other.hourQuantityDecrement;

  @override
  String toString() {
    return 'SetupState{rowID: $rowID, internalState: $internalState, etag: $etag, primaryKey: $primaryKey, maxHoursPerDay: $maxHoursPerDay, maxHoursPerDayWorkTypes: $maxHoursPerDayWorkTypes, hourDescriptionRequired: $hourDescriptionRequired, hourDateOffsetBackward: $hourDateOffsetBackward, hourDateOffsetForward: $hourDateOffsetForward, hourQuantityShortcuts: $hourQuantityShortcuts, hourQuantityIncrement: $hourQuantityIncrement, hourQuantityDecrement: $hourQuantityDecrement}';
  }
}
import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';

@immutable
class ItemQuantityState {
  final int rowID;
  final int internalState;
  final String etag;

  final String no;
  final num quantity;
  final String globalDimension1Filter;
  final String globalDimension2Filter;
  final String locationFilter;
  final String dropShipmentFilter;
  final String variantFilter;
  final String lotNoFilter;
  final String serialNoFilter;

  ItemQuantityState({
    this.rowID,
    this.internalState,
    this.etag,
    this.no,
    this.quantity,
    this.globalDimension1Filter,
    this.globalDimension2Filter,
    this.locationFilter,
    this.dropShipmentFilter,
    this.variantFilter,
    this.lotNoFilter,
    this.serialNoFilter,
  });


  ItemQuantityState copyWith({
    int rowID,
    int internalState,
    String etag,
    String no,
    num quantity,
    String globalDimension1Filter,
    String globalDimension2Filter,
    String locationFilter,
    String dropShipmentFilter,
    String variantFilter,
    String lotNoFilter,
    String serialNoFilter,
  }) {
    return ItemQuantityState(
      rowID: rowID ?? this.rowID,
      internalState: internalState ?? this.internalState,
      etag: etag ?? this.etag,
      no: no ?? this.no,
      quantity: quantity ?? this.quantity,
      globalDimension1Filter: globalDimension1Filter ?? this.globalDimension1Filter,
      globalDimension2Filter: globalDimension2Filter ?? this.globalDimension2Filter,
      locationFilter: locationFilter ?? this.locationFilter,
      dropShipmentFilter: dropShipmentFilter ?? this.dropShipmentFilter,
      variantFilter: variantFilter ?? this.variantFilter,
      lotNoFilter: lotNoFilter ?? this.lotNoFilter,
      serialNoFilter: serialNoFilter ?? this.serialNoFilter,
    );
  }

  Map<String, dynamic> encodeAPI({bool fromEncodeDB = false}) {
    final map = HashMap<String, dynamic>();
    if (no != null) {
      map['No'] = no;
    }
    if (quantity != null) {
      map['Quantity'] = quantity;
    }
    if (globalDimension1Filter != null) {
      map['Global_Dimension_1_Filter'] = globalDimension1Filter;
    }
    if (globalDimension2Filter != null) {
      map['Global_Dimension_2_Filter'] = globalDimension2Filter;
    }
    if (locationFilter != null) {
      map['Location_Filter'] = locationFilter;
    }
    if (dropShipmentFilter != null) {
      map['Drop_Shipment_Filter'] = dropShipmentFilter;
    }
    if (variantFilter != null) {
      map['Variant_Filter'] = variantFilter;
    }
    if (lotNoFilter != null) {
      map['Lot_No_Filter'] = lotNoFilter;
    }
    if (serialNoFilter != null) {
      map['Serial_No_Filter'] = serialNoFilter;
    }
    return map;
  }

  static ItemQuantityState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    int internalState,
    }
  ) => ItemQuantityState(
        rowID: rowID,
        internalState: internalState,
        etag: map['@odata.etag'] as String,
        no: map['No'] as String,
        quantity: map['Quantity'] as num,
        globalDimension1Filter: map['Global_Dimension_1_Filter'] as String,
        globalDimension2Filter: map['Global_Dimension_2_Filter'] as String,
        locationFilter: map['Location_Filter'] as String,
        dropShipmentFilter: map['Drop_Shipment_Filter'] as String,
        variantFilter: map['Variant_Filter'] as String,
        lotNoFilter: map['Lot_No_Filter'] as String,
        serialNoFilter: map['Serial_No_Filter'] as String,
      );

  Map<String, dynamic> encodeDB(String username) {
    final map = encodeAPI(fromEncodeDB: true);
    map['ETag'] = etag ?? '';
    map['_InternalState'] = internalState ?? 0;
    map['User'] = username ?? '';
    return map;
  }

  static ItemQuantityState decodeDB(Map<String, dynamic> map) {
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
      no.hashCode ^
      quantity.hashCode ^
      globalDimension1Filter.hashCode ^
      globalDimension2Filter.hashCode ^
      locationFilter.hashCode ^
      dropShipmentFilter.hashCode ^
      variantFilter.hashCode ^
      lotNoFilter.hashCode ^
      serialNoFilter.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemQuantityState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          internalState == other.internalState &&
          etag == other.etag &&
          no == other.no &&
          quantity == other.quantity &&
          globalDimension1Filter == other.globalDimension1Filter &&
          globalDimension2Filter == other.globalDimension2Filter &&
          locationFilter == other.locationFilter &&
          dropShipmentFilter == other.dropShipmentFilter &&
          variantFilter == other.variantFilter &&
          lotNoFilter == other.lotNoFilter &&
          serialNoFilter == other.serialNoFilter;

  @override
  String toString() {
    return 'ItemQuantityState{rowID: $rowID, internalState: $internalState, etag: $etag, no: $no, quantity: $quantity, globalDimension1Filter: $globalDimension1Filter, globalDimension2Filter: $globalDimension2Filter, locationFilter: $locationFilter, dropShipmentFilter: $dropShipmentFilter, variantFilter: $variantFilter, lotNoFilter: $lotNoFilter, serialNoFilter: $serialNoFilter}';
  }
}
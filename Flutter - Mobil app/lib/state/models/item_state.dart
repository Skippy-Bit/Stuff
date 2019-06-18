import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';

@immutable
class ItemState {
  final int rowID;

  final String no;
  final String description;
  final String description2;
  final String uom;
  final String vendorNo;
  final String vendorItemNo;
  final String gtin;
  final List<FieldData> detailFields;

  ItemState({
    this.rowID,
    this.no,
    this.description,
    this.description2,
    this.uom,
    this.vendorNo,
    this.vendorItemNo,
    this.gtin,
    List<FieldData> detailFields,
  }) : detailFields = detailFields ?? List<FieldData>();

  ItemState copyWith({
    int rowID,
    String no,
    String description,
    String description2,
    String uom,
    String vendorNo,
    String vendorItemNo,
    String gtin,
    List<FieldData> detailFields,
  }) {
    return ItemState(
      rowID: rowID ?? this.rowID,
      no: no ?? this.no,
      description: description ?? this.description,
      description2: description2 ?? this.description2,
      uom: uom ?? this.uom,
      vendorNo: vendorNo ?? this.vendorNo,
      vendorItemNo: vendorItemNo ?? this.vendorItemNo,
      gtin: gtin ?? this.gtin,
      detailFields: detailFields ?? this.detailFields,
    );
  }

  static ItemState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    List<FieldData> detailFields,
  }) =>
      ItemState(
        rowID: rowID,
        no: map['no'] as String,
        description: map['description'] as String,
        description2: map['description2'] as String,
        uom: map['uom'] as String,
        vendorNo: map['vendorNo'] as String,
        vendorItemNo: map['vendorItemNo'] as String,
        gtin: map['gtin'] as String,
        detailFields:
            detailFields ?? FieldData.decodeAPI(map['detailFields'] as List),
      );

  Map<String, dynamic> encodeDB(String username) {
    final map = HashMap<String, dynamic>();
    if (no != null) {
      map['no'] = no;
    }
    if (description != null) {
      map['description'] = description;
    }
    if (description2 != null) {
      map['description2'] = description2;
    }
    if (uom != null) {
      map['uom'] = uom;
    }
    if (vendorNo != null) {
      map['vendorNo'] = vendorNo;
    }
    if (vendorItemNo != null) {
      map['vendorItemNo'] = vendorItemNo;
    }
    if (gtin != null) {
      map['gtin'] = gtin;
    }
    map['detailFields'] =
        json.encode(detailFields.map((f) => f.encodeDB()).toList());
    map['User'] = username ?? '';
    return map;
  }

  static ItemState decodeDB(Map<String, dynamic> map) {
    return decodeAPI(
      map,
      rowID: map['ROWID'] as int,
      detailFields: (json.decode(map['detailFields']) as List)
          .map((f) => FieldData.decodeDB(f))
          .toList(),
    );
  }

  @override
  int get hashCode =>
      rowID.hashCode ^
      no.hashCode ^
      description.hashCode ^
      description2.hashCode ^
      uom.hashCode ^
      vendorNo.hashCode ^
      vendorItemNo.hashCode ^
      gtin.hashCode ^
      detailFields.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          no == other.no &&
          description == other.description &&
          description2 == other.description2 &&
          uom == other.uom &&
          vendorNo == other.vendorNo &&
          vendorItemNo == other.vendorItemNo &&
          gtin == other.gtin &&
          detailFields == other.detailFields;

  @override
  String toString() {
    return 'ItemState{rowID: $rowID, no: $no, description: $description, description2: $description2, uom: $uom, vendorNo: $vendorNo, vendorItemNo: $vendorItemNo, gtin: $gtin, detailFields: $detailFields}';
  }
}

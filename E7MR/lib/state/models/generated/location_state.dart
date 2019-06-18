import 'dart:collection';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:e7mr/state/models/generated/field_data.dart';

@immutable
class LocationState {
  final int rowID;
  final int internalState;
  final String etag;

  final String code;
  final String name;
  final String name2;
  final String address;
  final String address2;
  final String city;
  final String phoneNo;
  final String phoneNo2;
  final String contact;
  final String postCode;
  final String county;
  final String eMail;
  final String countryRegionCode;
  final String homePage;

  LocationState({
    this.rowID,
    this.internalState,
    this.etag,
    this.code,
    this.name,
    this.name2,
    this.address,
    this.address2,
    this.city,
    this.phoneNo,
    this.phoneNo2,
    this.contact,
    this.postCode,
    this.county,
    this.eMail,
    this.countryRegionCode,
    this.homePage,
  });


  LocationState copyWith({
    int rowID,
    int internalState,
    String etag,
    String code,
    String name,
    String name2,
    String address,
    String address2,
    String city,
    String phoneNo,
    String phoneNo2,
    String contact,
    String postCode,
    String county,
    String eMail,
    String countryRegionCode,
    String homePage,
  }) {
    return LocationState(
      rowID: rowID ?? this.rowID,
      internalState: internalState ?? this.internalState,
      etag: etag ?? this.etag,
      code: code ?? this.code,
      name: name ?? this.name,
      name2: name2 ?? this.name2,
      address: address ?? this.address,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      phoneNo: phoneNo ?? this.phoneNo,
      phoneNo2: phoneNo2 ?? this.phoneNo2,
      contact: contact ?? this.contact,
      postCode: postCode ?? this.postCode,
      county: county ?? this.county,
      eMail: eMail ?? this.eMail,
      countryRegionCode: countryRegionCode ?? this.countryRegionCode,
      homePage: homePage ?? this.homePage,
    );
  }

  Map<String, dynamic> encodeAPI({bool fromEncodeDB = false}) {
    final map = HashMap<String, dynamic>();
    if (code != null) {
      map['Code'] = code;
    }
    if (name != null) {
      map['Name'] = name;
    }
    if (name2 != null) {
      map['Name_2'] = name2;
    }
    if (address != null) {
      map['Address'] = address;
    }
    if (address2 != null) {
      map['Address_2'] = address2;
    }
    if (city != null) {
      map['City'] = city;
    }
    if (phoneNo != null) {
      map['Phone_No'] = phoneNo;
    }
    if (phoneNo2 != null) {
      map['Phone_No_2'] = phoneNo2;
    }
    if (contact != null) {
      map['Contact'] = contact;
    }
    if (postCode != null) {
      map['Post_Code'] = postCode;
    }
    if (county != null) {
      map['County'] = county;
    }
    if (eMail != null) {
      map['E_Mail'] = eMail;
    }
    if (countryRegionCode != null) {
      map['Country_Region_Code'] = countryRegionCode;
    }
    if (homePage != null) {
      map['Home_Page'] = homePage;
    }
    return map;
  }

  static LocationState decodeAPI(
    Map<String, dynamic> map, {
    int rowID,
    int internalState,
    }
  ) => LocationState(
        rowID: rowID,
        internalState: internalState,
        etag: map['@odata.etag'] as String,
        code: map['Code'] as String,
        name: map['Name'] as String,
        name2: map['Name_2'] as String,
        address: map['Address'] as String,
        address2: map['Address_2'] as String,
        city: map['City'] as String,
        phoneNo: map['Phone_No'] as String,
        phoneNo2: map['Phone_No_2'] as String,
        contact: map['Contact'] as String,
        postCode: map['Post_Code'] as String,
        county: map['County'] as String,
        eMail: map['E_Mail'] as String,
        countryRegionCode: map['Country_Region_Code'] as String,
        homePage: map['Home_Page'] as String,
      );

  Map<String, dynamic> encodeDB(String username) {
    final map = encodeAPI(fromEncodeDB: true);
    map['ETag'] = etag ?? '';
    map['_InternalState'] = internalState ?? 0;
    map['User'] = username ?? '';
    return map;
  }

  static LocationState decodeDB(Map<String, dynamic> map) {
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
      name.hashCode ^
      name2.hashCode ^
      address.hashCode ^
      address2.hashCode ^
      city.hashCode ^
      phoneNo.hashCode ^
      phoneNo2.hashCode ^
      contact.hashCode ^
      postCode.hashCode ^
      county.hashCode ^
      eMail.hashCode ^
      countryRegionCode.hashCode ^
      homePage.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationState &&
          runtimeType == other.runtimeType &&
          rowID == other.rowID &&
          internalState == other.internalState &&
          etag == other.etag &&
          code == other.code &&
          name == other.name &&
          name2 == other.name2 &&
          address == other.address &&
          address2 == other.address2 &&
          city == other.city &&
          phoneNo == other.phoneNo &&
          phoneNo2 == other.phoneNo2 &&
          contact == other.contact &&
          postCode == other.postCode &&
          county == other.county &&
          eMail == other.eMail &&
          countryRegionCode == other.countryRegionCode &&
          homePage == other.homePage;

  @override
  String toString() {
    return 'LocationState{rowID: $rowID, internalState: $internalState, etag: $etag, code: $code, name: $name, name2: $name2, address: $address, address2: $address2, city: $city, phoneNo: $phoneNo, phoneNo2: $phoneNo2, contact: $contact, postCode: $postCode, county: $county, eMail: $eMail, countryRegionCode: $countryRegionCode, homePage: $homePage}';
  }
}
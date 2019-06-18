import 'dart:collection';
import 'dart:convert';
import 'package:intl/intl.dart';

final dateFormat = DateFormat.yMMMMd();
final timeFormat = DateFormat.Hm();
final dateTimeFormat = DateFormat('dd. MMMM yyyy - HH:mm');

class FieldData {
  FieldData({this.caption, this.value});
  
  final String caption;
  final dynamic value;

  Map<String, dynamic> encodeDB() {
    final map = HashMap<String, dynamic>();
    map['c'] = caption;
    map['v'] = value;
    return map;
  }

  static FieldData decodeDB(Map<String, dynamic> map) => FieldData(
        caption: map['c'] as String,
        value: map['v'],
      );

  static List<FieldData> decodeAPI(List list) => list
      .map<FieldData>((item) {
        if (item is Map<String, dynamic>) {
          final type = item['t'];
          var value = item['v'];
          if (type == 'blob') {
            final blob = base64.decode(value);
            try {
              value = utf8.decode(blob);
            } catch (e) {
              try {
                value = latin1.decode(blob);
              } catch (e) {
                value = null;
              }
            }
          } else if (type == 'date' || type == 'time' || type == 'dateTime') {
            final date = DateTime.tryParse(value);
            if (type == 'date') {
              value = dateFormat.format(date);
            } else if (type == 'time') {
              value = timeFormat.format(date);
            } else {
              value = dateTimeFormat.format(date);
            }
          }
          return FieldData(caption: item['c'], value: value);
        }
        return null;
      })
      .where((field) => field != null)
      .toList();
}
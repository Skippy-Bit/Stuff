import 'dart:convert';

import 'package:e7mr/state/actions/log_commands/log_command.dart';
import 'package:e7mr/state/models/generated/field_data.dart';
import 'package:e7mr/state/models/generated/log_state.dart';
import 'package:e7mr/state/models/item_state.dart';
import 'package:intl/intl.dart';

final DateFormat format = DateFormat.yMMMd();

class JobItemUsage extends LogCommand {
  static const COMMAND = 'register_job_item_usage';

  @override
  String get name => COMMAND;

  @override
  String get hash => buildHash(jobNo, jobTaskNo, itemNo);

  static String buildHash(String jobNo, String jobTaskNo, String itemNo) =>
      '$jobNo#$jobTaskNo#$itemNo';
  static String buildSqlLikeHash(
      {String jobNo, String jobTaskNo, String itemNo}) {
    var result = '';
    result += (jobNo != null ? jobNo : '%') + '#';
    result += (jobTaskNo != null ? jobTaskNo : '%') + '#';
    result += (itemNo != null ? itemNo : '%');
    return result;
  }

  List<FieldData> get fields => [
        FieldData(caption: 'Prosjekt', value: jobNo),
        FieldData(caption: 'Oppgave', value: jobTaskNo),
        FieldData(caption: 'Varenr.', value: itemNo),
        FieldData(caption: 'Beskrivelse', value: description),
        FieldData(caption: 'Forbruk', value: '$quantity $unitOfMeasureCode'),
        FieldData(caption: 'Fra lokasjon', value: fromLocationCode),
        FieldData(caption: 'Registrert', value: format.format(postingDateTime)),
      ];

  final String jobNo;
  final String jobTaskNo;
  final String itemNo;
  final num quantity;
  final String unitOfMeasureCode;
  final String description;
  final String fromLocationCode;
  final DateTime postingDateTime;

  JobItemUsage(
    this.jobNo,
    this.jobTaskNo,
    this.itemNo,
    this.quantity,
    this.unitOfMeasureCode,
    this.description,
    this.fromLocationCode,
    this.postingDateTime,
  );

  factory JobItemUsage.fromItem(
    String jobNo,
    String jobTaskNo,
    ItemState item,
    num quantity,
    String fromLocationCode,
    DateTime postingDateTime,
  ) =>
      JobItemUsage(
        jobNo,
        jobTaskNo,
        item.no,
        quantity,
        item.uom,
        item.description,
        fromLocationCode,
        postingDateTime,
      );

  @override
  Map<String, dynamic> encode() {
    return {
      'jobNo': jobNo ?? '',
      'jobTaskNo': jobTaskNo ?? '',
      'itemNo': itemNo ?? '',
      'quantity': quantity ?? 0,
      'unitOfMeasureCode': unitOfMeasureCode ?? '',
      'description': description ?? '',
      'fromLocationCode': fromLocationCode ?? '',
      'postingDateTime': postingDateTime.toUtc().toIso8601String(),
    };
  }

  @override
  Map<String, dynamic> encodeExtraContent() {
    return null;
  }

  @override
  bool hasExtraContent() {
    return false;
  }

  static JobItemUsage decode(Map<String, dynamic> map) {
    return JobItemUsage(
      map['jobNo'] as String,
      map['jobTaskNo'] as String,
      map['itemNo'] as String,
      map['quantity'] as num,
      map['unitOfMeasureCode'] as String,
      map['description'] as String,
      map['fromLocationCode'] as String,
      DateTime.tryParse(map['postingDateTime'] as String ?? ''),
    );
  }

  static JobItemUsage decodeFromLogState(LogState log) =>
      decode(json.decode(utf8.decode(log.content)));
}

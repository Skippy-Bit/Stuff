import 'dart:convert';

import 'package:e7mr/state/actions/log_commands/log_command.dart';
import 'package:e7mr/state/models/generated/field_data.dart';
import 'package:e7mr/state/models/generated/log_state.dart';
import 'package:intl/intl.dart';

final DateFormat format = DateFormat.yMMMd();

class JobHour extends LogCommand {
  static const COMMAND = 'register_job_hour';

  @override
  String get name => COMMAND;

  @override
  get hash => buildHash(jobNo, jobTaskNo);

  static String buildHash(String jobNo, String jobTaskNo) =>
      '$jobNo#$jobTaskNo';
  static String buildSqlLikeHash(String jobNo) => '$jobNo#%';

  List<FieldData> get fields => [
        FieldData(caption: 'Prosjekt', value: jobNo),
        FieldData(caption: 'Oppgave', value: jobTaskNo),
        FieldData(caption: 'Forbruk', value: '$quantity $unitOfMeasureCode'),
        FieldData(caption: 'Arbeidstype', value: workTypeCode),
        FieldData(caption: 'Registrert', value: format.format(postingDateTime)),
        FieldData(caption: 'Beskrivelse', value: description),
      ];

  final String jobNo;
  final String jobTaskNo;
  final num quantity;
  final String workTypeCode;
  final String unitOfMeasureCode;
  final DateTime postingDateTime;
  final String description;

  JobHour(
    this.jobNo,
    this.jobTaskNo,
    this.quantity,
    this.workTypeCode,
    this.unitOfMeasureCode,
    this.postingDateTime,
    this.description,
  );

  @override
  Map<String, dynamic> encode() {
    return {
      'jobNo': jobNo ?? '',
      'jobTaskNo': jobTaskNo ?? '',
      'quantity': quantity ?? 0,
      'workTypeCode': workTypeCode ?? '',
      'unitOfMeasureCode': unitOfMeasureCode ?? '',
      'postingDateTime': postingDateTime.toUtc().toIso8601String(),
      'description': description ?? '',
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

  static JobHour decode(Map<String, dynamic> map) {
    return JobHour(
      map['jobNo'] as String,
      map['jobTaskNo'] as String,
      map['quantity'] as num,
      map['workTypeCode'] as String,
      map['unitOfMeasureCode'] as String,
      DateTime.tryParse(map['postingDateTime'] as String ?? ''),
      map['description'] as String,
    );
  }

  static JobHour decodeFromLogState(LogState log) =>
      decode(json.decode(utf8.decode(log.content)));
}

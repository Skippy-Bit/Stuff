import 'dart:convert';
import 'dart:typed_data';

import 'package:e7mr/state/actions/log_commands/log_command.dart';

class UploadPicture extends LogCommand {
  static const COMMAND = 'upload_picture';

  @override
  String get name => COMMAND;

  @override
  String get hash =>
      '$jobNo#$jobTaskNo#${postingDateTime?.millisecondsSinceEpoch}';

  static String buildSqlLikeHash(
      {String jobNo, String jobTaskNo, DateTime postingDateTime}) {
    var result = '';
    result += (jobNo != null ? jobNo : '%') + '#';
    result += (jobTaskNo != null ? jobTaskNo : '%') + '#';
    result += (postingDateTime != null
        ? postingDateTime.millisecondsSinceEpoch
        : '%');
    return result;
  }

  UploadPicture(
    this.jobNo,
    this.jobTaskNo,
    this.description,
    this.postingDateTime,
    this.picture,
  );

  final String jobNo;
  final String jobTaskNo;
  final String description;
  final DateTime postingDateTime;
  final Uint8List picture;

  @override
  Map<String, dynamic> encode() {
    return {
      'jobNo': jobNo ?? '',
      'jobTaskNo': jobTaskNo ?? '',
      'description': description ?? '',
      'postingDateTime': postingDateTime.toUtc().toIso8601String(),
    };
  }

  @override
  Map<String, dynamic> encodeExtraContent() {
    return {
      'picture': base64.encode(picture ?? ''),
    };
  }

  @override
  bool hasExtraContent() {
    return true;
  }

  static UploadPicture decode(Map<String, dynamic> map) {
    return UploadPicture(
      map['jobNo'] as String,
      map['jobTaskNo'] as String,
      map['description'] as String,
      DateTime.tryParse(map['postingDateTime'] as String ?? ''),
      base64.decode(map['picture'] as String ?? ''),
    );
  }

  UploadPicture copyWith({
    String jobNo,
    String jobTaskNo,
    String description,
    DateTime postingDateTime,
    Uint8List picture,
  }) =>
      UploadPicture(
        jobNo ?? this.jobNo,
        jobTaskNo ?? this.jobTaskNo,
        description ?? this.description,
        postingDateTime ?? this.postingDateTime,
        picture ?? this.picture,
      );
}

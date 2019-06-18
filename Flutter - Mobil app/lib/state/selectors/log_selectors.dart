import 'dart:convert';

import 'package:e7mr/state/actions/log_commands/job_hour.dart';
import 'package:e7mr/state/actions/log_commands/job_item_usage.dart';
import 'package:e7mr/state/actions/log_commands/log_command.dart';
import 'package:e7mr/state/actions/log_commands/relocate_item.dart';
import 'package:e7mr/state/actions/log_commands/upload_picture.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/log_state.dart';

Iterable<LogState> logsSelector(AppState state) => state.logs;

Iterable<T> logCommandsSelector<T extends LogCommand>(
  AppState state,
  String command,
  LogCommandDecoder<T> decoder,
) =>
    logsSelector(state)
        .where((log) => log.command == command && log.content.isNotEmpty)
        .map((log) => decoder(json.decode(utf8.decode(log.content))));

Iterable<JobHour> jobHoursSelector(AppState state) =>
    logCommandsSelector(state, JobHour.COMMAND, JobHour.decode);

Iterable<JobItemUsage> jobItemUsagesSelector(AppState state) =>
    logCommandsSelector(state, JobItemUsage.COMMAND, JobItemUsage.decode);

Iterable<RelocateItem> relocateItemsSelector(AppState state) =>
    logCommandsSelector(state, RelocateItem.COMMAND, RelocateItem.decode);

Iterable<UploadPicture> uploadPicturesSelector(AppState state) =>
    logCommandsSelector(state, UploadPicture.COMMAND, UploadPicture.decode);

import 'package:e7mr/state/models/credentials.dart';
import 'package:e7mr/state/models/generated/log_state.dart';
import 'package:e7mr/state/services/nav.service.dart';
import 'package:http/http.dart';

class PostLog {
  static const SERVICE_ENDPOINT = 'E7MR_Log';

  PostLog();

  static Future<void> postLogs(
    Iterable<LogState> logs,
    Credentials credentials,
    List<LogState> success,
    List<LogState> failed,
  ) async {
    for (final model in logs) {
      try {
        Response res = await NavService.post(
          credentials,
          SERVICE_ENDPOINT,
          model.encodeAPI(),
        );
        final values = NavService.valuesAPI(res);
        if (res.statusCode == 201) {
          for (final value in values) {
            success
                .add(LogState.decodeAPI(value, rowID: model.rowID));
          }
        } else if (400 <= res.statusCode && res.statusCode <= 499) {
          failed.add(model);
        }
      } catch (e) {
        failed.add(model);
      }
    }
  }
}

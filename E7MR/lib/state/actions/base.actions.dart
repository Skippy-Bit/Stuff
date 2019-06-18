import 'package:http/http.dart';

enum ActionState { QUEUED, SUCCESS, FAILED }

class ActionError {
  final String message;
  final int code;

  ActionError({this.code, this.message});
  factory ActionError.fromHttpResponse(Response response) =>
      ActionError(code: response.statusCode, message: response.reasonPhrase);
}

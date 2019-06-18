import 'package:http/http.dart' as http;

class HttpUtil {
  static DateTime getDateFromResponse(http.Response response) =>
      DateTime.tryParse(response.headers['Date'] ??
          response.headers['date'] ??
          response.headers['DATE'] ??
          '');
}

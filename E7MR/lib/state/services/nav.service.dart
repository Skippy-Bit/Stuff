import 'dart:convert';
import 'dart:async';
import 'package:e7mr/state/models/credentials.dart';
import 'package:e7mr/state/services/filter_args.dart';
import 'package:http_auth/http_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const ODATA_VERSION = '4.0';
const ODATA_MAX_VERSION = '4.0';

class NavService {
  static Future<http.Response> getSingle(
    Credentials credentials,
    String path,
    String primaryKey, {
    String etag,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final uri = Uri.parse('${credentials.baseURL}/$path($primaryKey)');
    final request = http.Request('GET', uri);
    request.headers.addAll(_getHeaders(credentials, etag: etag));
    final baseResponse =
        await _performHttpRequest(credentials, request).timeout(timeout);

    return _responseFromBaseResponse(baseResponse);
  }

  static Future<http.Response> getMultiple(
    Credentials credentials,
    String path, {
    String filter,
    String orderby,
    int top,
    int skip,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final filterArgs = FilterArgs()
      ..appendIfNotNull('filter', filter)
      ..appendIfNotNull('orderby', orderby)
      ..appendIfNotNull('top', top)
      ..appendIfNotNull('skip', skip);

    final uri = Uri.parse('${credentials.baseURL}/$path$filterArgs');
    final request = http.Request('GET', uri);
    request.headers.addAll(_getHeaders(credentials));
    final baseResponse =
        await _performHttpRequest(credentials, request).timeout(timeout);

    return _responseFromBaseResponse(baseResponse);
  }

  static Future<http.Response> getCompanies(
    String username,
    String password,
    String rootURL, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final uri = Uri.parse('$rootURL/Company');
    final request = http.Request('GET', uri);
    final credentials = Credentials(null, username, password);
    request.headers.addAll(_getHeaders(credentials));
    final baseResponse =
        await _performHttpRequest(credentials, request).timeout(timeout);

    return _responseFromBaseResponse(baseResponse);
  }

  static Future<http.Response> post(
    Credentials credentials,
    String path,
    Map<String, dynamic> fields, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final uri = Uri.parse('${credentials.baseURL}/$path');
    final request = http.Request('POST', uri);
    request.headers.addAll(_postHeaders(credentials));
    request.body = json.encode(fields);
    final baseResponse =
        await _performHttpRequest(credentials, request).timeout(timeout);

    return _responseFromBaseResponse(baseResponse);
  }

  static Map<String, String> _getHeaders(Credentials creds, {String etag}) {
    if (creds.username == null || creds.username.isEmpty) {
      throw http.ClientException("Username cannot be empty.");
    }
    final map = {
      'OData-Version': ODATA_VERSION,
      'OData-MaxVersion': ODATA_MAX_VERSION,
      'Accept': 'application/json',
    };
    if (etag != null) {
      map['If-None-Match'] = etag;
    }
    return map;
  }

  static Map<String, String> _postHeaders(Credentials creds) {
    if (creds.username == null || creds.username.isEmpty) {
      throw http.ClientException("Username cannot be empty.");
    }
    return {
      'Content-Type': 'application/json',
    };
  }

  static List<dynamic> valuesAPI(http.Response response) {
    final map = json.decode(response.body);
    if (map != null && map is Map) {
      final value = map['value'];
      if (value != null && value is List) {
        return value;
      } else {
        return [map];
      }
    }
    return null;
  }

  static String etagAPI(http.Response response) {
    final values = valuesAPI(response);
    if (values != null) {
      final value = values[0];
      if (value != null) {
        return value['@odata.etag'];
      }
    }
    return null;
  }

  static http.BaseClient _client;
  static Credentials _prevCreds;

  static Future<http.BaseResponse> _performHttpRequest(
      Credentials creds, http.BaseRequest request) async {
    if (creds == null) {
      return null;
    }

    http.BaseResponse res;
    if (_prevCreds == creds && _client != null) {
      res = await _client.send(request);
      if (res.statusCode != 400 && res.statusCode != 401) {
        return res;
      }
    }

    _prevCreds = creds;

    _client = BasicAuthClient(creds.username, creds.password);
    if (request.finalized) {
      request = _copyRequest(request);
    }
    res = await _client.send(request);
    if (res.statusCode != 401) {
      return res;
    }

    _client = DigestAuthClient(creds.username, creds.password);
    request = _copyRequest(request);
    res = await _client.send(request);
    if (res.statusCode != 401) {
      return res;
    }

    _client = null;
    return null;
  }

  static http.BaseRequest _copyRequest(http.BaseRequest request) {
    http.BaseRequest requestCopy;

    if (request is http.Request) {
      requestCopy = http.Request(request.method, request.url)
        ..encoding = request.encoding
        ..bodyBytes = request.bodyBytes;
    } else if (request is http.MultipartRequest) {
      requestCopy = http.MultipartRequest(request.method, request.url)
        ..fields.addAll(request.fields)
        ..files.addAll(request.files);
    } else if (request is http.StreamedRequest) {
      throw Exception('copying streamed requests is not supported');
    } else {
      throw Exception('request type is unknown, cannot copy');
    }

    requestCopy
      ..persistentConnection = request.persistentConnection
      ..followRedirects = request.followRedirects
      ..maxRedirects = request.maxRedirects
      ..headers.addAll(request.headers);

    return requestCopy;
  }

  static Future<http.Response> _responseFromBaseResponse(
      http.BaseResponse response) async {
    assert(response is http.Response || response is http.StreamedResponse);
    if (response is http.Response) {
      return SynchronousFuture(response);
    }
    if (response is http.StreamedResponse) {
      return await http.Response.fromStream(response);
    }
    return null;
  }
}

import 'package:e7mr/state/models/credentials.dart';

class User {
  final Credentials _creds;

  Credentials get credentials => _creds;
  String get baseURL => _creds.baseURL;
  String get username => _creds.username.toUpperCase();

  User(this._creds);
}

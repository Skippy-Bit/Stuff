class Credentials {
  final String _baseURL;
  final String _username;
  final String _password;

  String get baseURL => _baseURL;
  String get username => _username;
  String get password => _password;

  // This is purely for informational purposes.
  final String company;

  Credentials(this._baseURL, String username, this._password, {this.company})
      : _username = username;

  bool validate() {
    return _baseURL != null &&
        _baseURL.isNotEmpty &&
        _username != null &&
        _username.isNotEmpty &&
        _password != null &&
        _password.isNotEmpty;
  }
}

import 'package:e7mr/state/actions/login.actions.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/auth_state.dart';
import 'package:e7mr/state/models/credentials.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/services/nav.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;

class _LoginData {
  String domain = '';
  String instance = '';
  String company = '';
  String username = '';
  String password = '';

  String get rootURL => '$domain/$instance/ODataV4';
  String get baseURL => '$rootURL/Company(\'$company\')';
  Credentials get credentials =>
      Credentials(baseURL, username, password, company: company);
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey;
  _LoginData _data;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _data = _LoginData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: StoreConnector<AppState, AuthState>(
          converter: (store) => authSelector(store.state),
          builder: (BuildContext context, AuthState auth) {
            final body = auth.isLoggingIn
                ? _buildOverlay(context, auth.message)
                : _buildForm(context, auth.message, false);
            return body;
          },
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context, String message) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        IgnorePointer(
          child: Container(
              foregroundDecoration: BoxDecoration(color: Colors.black54),
              child: _buildForm(context, message, true)),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 32.0, horizontal: 32.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                      // backgroundColor: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        'Logging in',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, String message, bool isLoggingIn) {
    var preset = {
      'URL': 'https://sf-107055.dynamicstocloud.com:1103',
      'Service': 'ST-111359',
      // 'Company': 'Test AS',
    };

    return SafeArea(
      child: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message ?? '',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextFormField(
                    autocorrect: false,
                    autovalidate: true,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      labelText: 'Domene',
                      hintText: 'https://nav01.kunde.no:port',
                    ),
                    initialValue: preset['URL'], // TEST!
                    validator: (value) {
                      // final match = RegExp(r'^http[s]*:\/\/').firstMatch(value);
                      // if (match != null) {
                      //   return 'Må skrives uten ${match.group(0)}';
                      // }
                    },
                    onSaved: (value) {
                      _data.domain = value;
                    },
                  ),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Tjenestenavn',
                      hintText: 'DynamicsNAV110',
                    ),
                    initialValue: preset['Service'], // TEST!
                    onSaved: (value) {
                      _data.instance = value;
                    },
                  ),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Brukernavn',
                      hintText: r'LOGIN\olanor',
                    ),
                    onSaved: (value) {
                      _data.username = value.trim();
                    },
                  ),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Passord',
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Passord må fylles ut'
                        : null,
                    onSaved: (value) {
                      _data.password = value;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _formKey.currentState.save();
                            });
                          }
                        },
                        child: Text('Hent selskaper...'),
                      ),
                    ),
                  ),
                  FutureBuilder<Iterable<String>>(
                    initialData: Iterable.empty(),
                    future: () async {
                      return await getCompanies();
                    }(),
                    builder: (context, snapshot) {
                      final companies = snapshot?.data;
                      final menuItems = companies
                          ?.map(
                            (company) => DropdownMenuItem(
                                  value: company,
                                  child: Text(company),
                                ),
                          )
                          ?.toList();

                      String currentValue;
                      if (companies != null &&
                          companies.contains(_data.company)) {
                        currentValue = _data.company;
                      }

                      return DropdownButton(
                        hint: Text('Velg selskap...'),
                        disabledHint: Text('Fyll inn feltene over...'),
                        items: menuItems,
                        value: currentValue,
                        onChanged: (String company) {
                          setState(() {
                            _data.company = company;
                          });
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: StoreConnector<AppState, CredentialsCallback>(
                        converter: (store) => (Credentials creds) =>
                            store.dispatch(new LoginAction(creds)),
                        builder:
                            (BuildContext context, CredentialsCallback login) {
                          return RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  isLoggingIn = true;
                                });
                                login(_data.credentials);
                              }
                            },
                            child: Text('Logg inn'),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Iterable<String>> getCompanies() async {
    if (_data.username == null ||
        _data.username == '' ||
        _data.password == null ||
        _data.password == '' ||
        _data.domain == null ||
        _data.domain == '' ||
        _data.instance == null ||
        _data.instance == '') {
      return null;
    }

    http.Response res;
    try {
      res = await NavService.getCompanies(
        _data.username,
        _data.password,
        _data.rootURL,
      );
    } catch (e) {
      return null;
    }

    if (res == null || res.statusCode != 200) {
      return null;
    }

    final values = NavService.valuesAPI(res);
    final companies = values.map((value) => value['Name']);
    return companies.isNotEmpty ? companies.cast<String>() : null;
  }
}

typedef void CredentialsCallback(Credentials credentials);

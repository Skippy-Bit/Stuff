import 'dart:async';

import 'package:e7mr/e7mr_theme.dart';
import 'package:e7mr/state/actions/login.actions.dart';
import 'package:e7mr/state/models/credentials.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/state/services/nav.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class _LoginModel {
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

class LoginNewPage extends StatefulWidget {
  LoginNewPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginNewPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeDomainLogin = FocusNode();
  final FocusNode myFocusNodeInstanceLogin = FocusNode();
  final FocusNode myFocusNodeUsernameLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodeCompany = FocusNode();

  TextEditingController loginDomainController = new TextEditingController();
  TextEditingController loginInstanceController = new TextEditingController();
  TextEditingController loginUsernameController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;

  PageController _pageController;

  _LoginModel _model = _LoginModel();

  bool _fetchingCompanies = false;
  Iterable<String> _companies = const Iterable.empty();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: StoreConnector<AppState, bool>(
          converter: (store) => isLoggingInSelector(store.state),
          builder: (context, loggingIn) => IgnorePointer(
                ignoring: _fetchingCompanies || loggingIn,
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height >= 550.0
                        ? MediaQuery.of(context).size.height
                        : 550.0,
                    padding: EdgeInsets.only(top: 128.0),
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            E7MRTheme.loginGradientStart,
                            E7MRTheme.loginGradientEnd,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: PageView(
                            controller: _pageController,
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              new ConstrainedBox(
                                constraints: const BoxConstraints.expand(),
                                child: _buildLogin(context),
                              ),
                              new ConstrainedBox(
                                constraints: const BoxConstraints.expand(),
                                child: _buildChooseCompany(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodeDomainLogin.dispose();
    myFocusNodeUsernameLogin.dispose();
    myFocusNodePasswordLogin.dispose();
    myFocusNodeCompany.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();

    loginDomainController.text = 'https://sf-107055.dynamicstocloud.com:1103';
    loginInstanceController.text = 'ST-111359';
    loginUsernameController.text = 'sindre.tellevik@eseven.no';
    loginPasswordController.text = 'Test1234!';
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  Widget _buildLogin(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 345.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeDomainLogin,
                          controller: loginDomainController,
                          keyboardType: TextInputType.url,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.at,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Domene",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeInstanceLogin,
                          controller: loginInstanceController,
                          keyboardType: TextInputType.url,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.server,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Tjeneste",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeUsernameLogin,
                          controller: loginUsernameController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Brukernavn",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: "Passord",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleObscureTextLogin,
                              child: Icon(
                                FontAwesomeIcons.eye,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 325.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: E7MRTheme.primary.shade500,
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0),
                    child: Text(
                      "LOGG INN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                  onPressed: () => _onLoginPress(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChooseCompany(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      alignment: Alignment.topCenter,
      child: Card(
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _onBackButtonPress,
              ),
              Container(
                width: 300.0,
                height: 345.0,
                child: Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: _companies.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              title: Text(_companies.elementAt(i)),
                              onTap: () => _onCompanyPress(
                                  context, _companies.elementAt(i)),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onBackButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleObscureTextLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  Future<void> _onLoginPress(BuildContext context) async {
    _model.domain = loginDomainController.text;
    _model.instance = loginInstanceController.text;
    _model.username = loginUsernameController.text;
    _model.password = loginPasswordController.text;

    final creds = _model.credentials;
    if (creds.validate()) {
      setState(() {
        _fetchingCompanies = true;
      });

      final companies = await getCompanies();

      setState(() {
        _companies = companies;
        _fetchingCompanies = false;
      });

      if (_companies.isNotEmpty) {
        _pageController?.animateToPage(1,
            duration: Duration(milliseconds: 500), curve: Curves.decelerate);
      } else {
        showInSnackBar("Fant ingen selskaper.");
      }
    } else {
      showInSnackBar("Ugyldige inndata.");
    }
  }

  void _onCompanyPress(BuildContext context, String company) {
    final store = StoreProvider.of<AppState>(context);
    _model.company = company;
    store.dispatch(LoginAction(_model.credentials));
  }

  Future<Iterable<String>> getCompanies() async {
    if (_model.username == null ||
        _model.username == '' ||
        _model.password == null ||
        _model.password == '' ||
        _model.domain == null ||
        _model.domain == '' ||
        _model.instance == null ||
        _model.instance == '') {
      return null;
    }

    http.Response res;
    try {
      res = await NavService.getCompanies(
        _model.username,
        _model.password,
        _model.rootURL,
      );
    } catch (e) {
      return Iterable.empty();
    }

    if (res == null || res.statusCode != 200) {
      return Iterable.empty();
    }

    final values = NavService.valuesAPI(res);
    final companies = values.map((value) => value['Name']);
    return companies.isNotEmpty ? companies.cast<String>() : Iterable.empty();
  }
}

typedef void CredentialsCallback(Credentials credentials);

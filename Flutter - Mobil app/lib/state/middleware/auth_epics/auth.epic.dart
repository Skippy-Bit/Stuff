import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:e7mr/state/actions/login.actions.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/credentials.dart';
import 'package:e7mr/state/models/user.dart';
import 'package:e7mr/state/services/nav.service.dart';
import 'package:flutter/widgets.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SHARED_PREFS_PREFIX = 'auth:';
const SHARED_PREFS_USERNAME_KEY = SHARED_PREFS_PREFIX + 'username';
const SHARED_PREFS_PASSWORD_KEY = SHARED_PREFS_PREFIX + 'password';
const SHARED_PREFS_BASE_URL_KEY = SHARED_PREFS_PREFIX + 'base_url';
const SHARED_PREFS_COMPANY_KEY = SHARED_PREFS_PREFIX + 'company';

class LoginResult {
  final bool success;
  final User user;
  final String message;

  LoginResult(this.success, {this.user, this.message});
}

class AuthEpic implements EpicClass<AppState> {
  final GlobalKey<NavigatorState> navigatorKey;

  AuthEpic(this.navigatorKey);

  @override
  Stream call(Stream actions, EpicStore<AppState> store) {
    return new Observable(actions)
        .where((action) =>
            action is CheckStoredCredentialsAction ||
            action is LoginAction ||
            action is LogoutAction)
        .asyncMap((action) async {
      if (action is CheckStoredCredentialsAction) {
        final result = await checkStoredCredentials();
        if (result.success) {
          assert(result.user != null);
          navigatorKey.currentState.pushReplacementNamed('/home');
          return LoginSuccessAction(result.user);
        }
        navigatorKey.currentState.pushReplacementNamed('/login');
        return LoginFailedAction();
      } else if (action is LoginAction) {
        final result = await login(action.credentials);
        if (result.success) {
          assert(result.user != null);
          navigatorKey.currentState.pushReplacementNamed('/home');
          return LoginSuccessAction(result.user);
        }
        navigatorKey.currentState.pushReplacementNamed('/login');
        if (result.message != null && result.message.isNotEmpty) {
          return LoginFailedAction(message: result.message);
        } else {
          return LoginFailedAction.incorrectCredentials();
        }
      } else if (action is LogoutAction) {
        await login(null); // Logout
        navigatorKey.currentState.pushReplacementNamed('/login');
      }
      return null;
    });
  }

  static Future<LoginResult> login(Credentials creds) async {
    LoginResult result;

    if (creds != null) {
      var response;
      try {
        response = await NavService.getMultiple(creds, '',
            timeout: const Duration(
                seconds: 3)); // Cheeky "hack" to check authentication
      } catch (e) {
        print(e);
        return LoginResult(false, message: "The request timed out.");
      }
      if (response.statusCode == 200) {
        result = LoginResult(true, user: User(creds));
      } else {
        result = LoginResult(false, message: 'Login failed, try again.');
      }
      await _updateStoredCredentials(creds,
          successfulAttempt: response.statusCode == 200);
    } else {
      // If credentials is null, we logout.
      result = LoginResult(false);
      await _updateStoredCredentials(null);
    }
    return result;
  }

  // Returns true if logged in and false if not.
  static Future<LoginResult> checkStoredCredentials() async {
    LoginResult result;
    final creds = await _getStoredCredentials();
    if (!creds.validate()) {
      // Credentials are empty.
      result = LoginResult(false);
    } else {
      final conn = Connectivity();
      if (await conn.checkConnectivity() == ConnectivityResult.none) {
        // We're offline.
        result = LoginResult(true, user: User(creds));
      } else {
        // We're online, try to login.
        result = await login(creds);
      }
    }
    return result;
  }

  static Future<Credentials> _getStoredCredentials() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final baseURL = sharedPrefs.getString(SHARED_PREFS_BASE_URL_KEY) ?? '';
    final company = sharedPrefs.getString(SHARED_PREFS_COMPANY_KEY) ?? '';
    final username = sharedPrefs.getString(SHARED_PREFS_USERNAME_KEY) ?? '';
    final password = sharedPrefs.getString(SHARED_PREFS_PASSWORD_KEY) ?? '';
    return Credentials(baseURL, username, password, company: company);
  }

  static Future<void> _updateStoredCredentials(Credentials creds,
      {bool successfulAttempt = false}) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (creds != null) {
      sharedPrefs.setString(SHARED_PREFS_COMPANY_KEY, creds.company);
      sharedPrefs.setString(SHARED_PREFS_BASE_URL_KEY, creds.baseURL);
      sharedPrefs.setString(SHARED_PREFS_USERNAME_KEY, creds.username);
      sharedPrefs.setString(
          SHARED_PREFS_PASSWORD_KEY, successfulAttempt ? creds.password : '');
    } else {
      sharedPrefs.remove(SHARED_PREFS_COMPANY_KEY);
      sharedPrefs.remove(SHARED_PREFS_BASE_URL_KEY);
      sharedPrefs.remove(SHARED_PREFS_USERNAME_KEY);
      sharedPrefs.remove(SHARED_PREFS_PASSWORD_KEY);
    }
  }
}

import 'package:e7mr/state/actions/login.actions.dart';
import 'package:e7mr/state/models/auth_state.dart';
import 'package:redux/redux.dart';

final authReducer = combineReducers<AuthState>([
  TypedReducer<AuthState, CheckStoredCredentialsAction>(
      _setCheckingStoredCredentialsAction),
  TypedReducer<AuthState, LoginAction>(_setLoggingIn),
  TypedReducer<AuthState, LoginFailedAction>(_setLoginFailed),
  TypedReducer<AuthState, LoginSuccessAction>(_setLoggedIn),
  TypedReducer<AuthState, LogoutAction>(_setLoggedOut),
]);

AuthState _setCheckingStoredCredentialsAction(
    AuthState state, CheckStoredCredentialsAction action) {
  return AuthState.loggingIn();
}

AuthState _setLoggingIn(AuthState state, LoginAction action) {
  return AuthState.loggingIn();
}

AuthState _setLoginFailed(AuthState state, LoginFailedAction action) {
  return AuthState.loginFailed(message: action.message);
}

AuthState _setLoggedIn(AuthState state, LoginSuccessAction action) {
  return AuthState.authorized(action.user);
}

AuthState _setLoggedOut(AuthState state, LogoutAction action) {
  return AuthState.loggedOut();
}

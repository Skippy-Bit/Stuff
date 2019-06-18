import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/auth_state.dart';
import 'package:e7mr/state/models/credentials.dart';
import 'package:e7mr/state/models/user.dart';

AuthState authSelector(AppState state) => state.auth;
User userSelector(AppState state) => authSelector(state).user;
Credentials credentialsSelector(AppState state) =>
    userSelector(state)?.credentials;
bool isLoggingInSelector(AppState state) =>
    authSelector(state)?.isLoggingIn ?? false;

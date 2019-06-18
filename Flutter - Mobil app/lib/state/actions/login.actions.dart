import 'package:e7mr/state/models/credentials.dart';
import 'package:e7mr/state/models/user.dart';

class LoginSuccessAction {
  final User user;
  LoginSuccessAction(this.user);
}

class LoginFailedAction {
  final String message;
  LoginFailedAction({this.message});
  factory LoginFailedAction.incorrectCredentials() =>
      LoginFailedAction(message: "Ugyldig brukernavn eller passord.");
}

class CheckStoredCredentialsAction {}

class LoginAction {
  final Credentials credentials;
  LoginAction(this.credentials);
}

class LogoutAction {}

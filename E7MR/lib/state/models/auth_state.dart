import 'package:e7mr/state/models/user.dart';
import 'package:meta/meta.dart';

@immutable
class AuthState {
  final User user;
  final bool isLoggingIn;
  final String message;
  bool get isLoggedIn => user != null;

  AuthState({
    this.user,
    this.isLoggingIn = false,
    this.message,
  });

  factory AuthState.loggedOut() => AuthState();
  factory AuthState.loggingIn() => AuthState(isLoggingIn: true);
  factory AuthState.authorized(User user) => AuthState(user: user);
  factory AuthState.loginFailed({String message}) =>
      AuthState(message: message);

  AuthState copyWith({
    User user,
    bool isLoggingIn,
    String message,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoggingIn: isLoggingIn ?? this.isLoggingIn,
      message: message ?? this.message,
    );
  }

  @override
  int get hashCode => user.hashCode ^ isLoggingIn.hashCode ^ message.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          isLoggingIn == other.isLoggingIn &&
          message == other.message;

  @override
  String toString() {
    return 'AuthState{user: $user, isLoggingIn: $isLoggingIn, message: $message}';
  }
}

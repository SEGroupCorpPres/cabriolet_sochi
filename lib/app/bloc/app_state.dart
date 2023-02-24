part of 'app_bloc.dart';

abstract class AppState extends Equatable {}

class UnInitialized extends AppState {
  @override
  List<Object?> get props => [];
}

class UnAuthenticated extends AppState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AppState {
  final UserModel user;

  Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class VerifyingAuth extends AppState {
  @override
  List<Object?> get props => [];
}

class SignOutState extends AppState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
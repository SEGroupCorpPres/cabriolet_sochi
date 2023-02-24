part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialState extends AccountState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserDataError extends AccountState {
  UserDataError(this.error);

  final String error;

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class UserDataLoading extends AccountState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserDataLoaded extends AccountState {
  Map<String, dynamic> userData;

  UserDataLoaded(this.userData);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


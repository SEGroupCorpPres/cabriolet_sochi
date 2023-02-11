import 'dart:async';

import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
import 'package:cabriolet_sochi/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._authenticationRepository) : super(UnInitialized()) {
    on<IsAuthenticated>(_handleVerifyUserAuth);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _handleVerifyUserAuth(
    IsAuthenticated event,
    Emitter<AppState> emit,
  ) async {
    emit(VerifyingAuth());
    final isAuthenticated = await _authenticationRepository.isLoggedIn();
    // const isAuthenticated = true;
    if (isAuthenticated) {
      emit(Authenticated(UserModel()));
    } else {
      emit(UnAuthenticated());
    }
  }
}

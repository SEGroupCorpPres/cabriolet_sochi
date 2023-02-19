import 'package:cabriolet_sochi/src/features/account/domain/repositories/account_repository.dart';
import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository accountRepository;

  AccountBloc({required this.accountRepository}) : super(InitialState()) {
    on<GetData>((event, emit) async {
      emit(UserDataLoading());
      await Future.delayed(const Duration(seconds: 1));
      try {
        final data = await accountRepository.getUserData();
        print('data $data');
        emit(UserDataLoaded(data));
      } catch (e) {
        emit(UserDataError(e.toString()));
      }
    });
    on<UserSignOutEvent>((event, emit) async {
      emit(UserSignOutState());
      await accountRepository.signOut();
    });
  }
}

// import 'dart:async';
//
// import 'package:cabriolet_sochi/src/features/authentication/data/datasources/remote/database_repository_impl.dart';
// import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// part 'database_event.dart';
//
// part 'database_state.dart';
//
// class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
//   DatabaseBloc(this._databaseRepository) : super(DatabaseInitial()) {
//     on<DatabaseFetched>(_fetchUserData);
//   }
//
//   final DatabaseRepository _databaseRepository;
//
//   _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
//     List<UserModel> listOfUserData = await _databaseRepository.retrieveUserData();
//     emit(DatabaseSuccess(listOfUserData, event.phoneNumber!));
//   }
// }

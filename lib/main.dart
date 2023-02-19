import 'package:cabriolet_sochi/app/app.dart';
import 'package:cabriolet_sochi/app/bloc/app_bloc.dart';
import 'package:cabriolet_sochi/app/bloc_observer.dart';
import 'package:cabriolet_sochi/firebase_options.dart';
import 'package:cabriolet_sochi/src/features/account/bloc/account_bloc.dart';
import 'package:cabriolet_sochi/src/features/account/domain/repositories/account_repository.dart';
import 'package:cabriolet_sochi/src/features/authentication/bloc/authentication_cubit.dart';
import 'package:cabriolet_sochi/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('uid');
  final authenticationRepository = AuthenticationRepository();
  final accountRepository = AccountRepository();
  BlocOverrides.runZoned(
    () => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (context) => AppBloc(authenticationRepository)..add(IsAuthenticated()),
          ),
          BlocProvider<AuthenticationCubit>(
            create: (context) => AuthenticationCubit(),
          ),
          BlocProvider<AccountBloc>(
            create: (context) => AccountBloc(accountRepository: accountRepository),
          )
        ],
        child: App(
          uid: uid,
        ),
      ),
    ),
    blocObserver: AppBlocObserver(),
  );
}

import 'package:cabriolet_sochi/app/app.dart';
import 'package:cabriolet_sochi/app/bloc/app_bloc.dart';
import 'package:cabriolet_sochi/app/bloc_observer.dart';
import 'package:cabriolet_sochi/firebase_options.dart';
import 'package:cabriolet_sochi/src/features/account/bloc/account_bloc.dart';
import 'package:cabriolet_sochi/src/features/account/domain/repositories/account_repository.dart';
import 'package:cabriolet_sochi/src/features/authentication/bloc/authentication_cubit.dart';
import 'package:cabriolet_sochi/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:cabriolet_sochi/src/features/cart/bloc/cart_bloc.dart';
import 'package:cabriolet_sochi/src/features/cart/domain/repositories/cart_repository.dart';
import 'package:cabriolet_sochi/src/features/home/bloc/home_bloc.dart';
import 'package:cabriolet_sochi/src/features/home/domain/repositories/car_repository.dart';
import 'package:cabriolet_sochi/src/features/orders/cubit/orders_cubit.dart';
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
  final isFirstTimeEntry = prefs.getBool('isFirstTimeEntry') ?? true;
  final authenticationRepository = AuthenticationRepository();
  final carRepository = CarRepository();
  final accountRepository = AccountRepository();
  final cartRepository = CartRepository();
  BlocOverrides.runZoned(
    () => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (context) => AppBloc(authenticationRepository)
              ..add(
                IsAuthenticated(),
              ),
          ),
          BlocProvider<AuthenticationCubit>(
            create: (context) => AuthenticationCubit(),
          ),
          BlocProvider<AccountBloc>(
            create: (context) => AccountBloc(
              accountRepository: accountRepository,
            ),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(
              carRepository: carRepository,
            ),
          ),
          BlocProvider<OrdersCubit>(
            create: (context) => OrdersCubit(),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(
              cartRepository: cartRepository,
            ),
          ),
        ],
        child: App(
          uid: uid,
          isFirstTimeEntry: isFirstTimeEntry,
        ),
      ),
    ),
    blocObserver: AppBlocObserver(),
  );
}

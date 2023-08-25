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
import 'package:cabriolet_sochi/src/features/home/bloc/car_list/car_list_bloc.dart';
import 'package:cabriolet_sochi/src/features/home/bloc/filter/filter_bloc.dart';
import 'package:cabriolet_sochi/src/features/home/domain/repositories/car_repository.dart';
import 'package:cabriolet_sochi/src/features/orders/cubit/orders_cubit.dart';
import 'package:cabriolet_sochi/src/utils/services/order_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = AppBlocObserver();

  await OrderNotificationService().init();
  final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('uid') ?? '';
  final authenticationRepository = AuthenticationRepository();
  final carRepository = CarRepository();
  final accountRepository = AccountRepository();
  final cartRepository = CartRepository();
  final userImgUrl = prefs.getString('userImgUrl') ?? '';
  final carImgUrl = prefs.getString('carImgUrl') ?? '';
  final orderId = prefs.getInt('orderId');
  final dateList = prefs.getStringList('date2') ?? [''];
  final carName = prefs.getString('carName') ?? '';
  final isNotify = prefs.getBool('isNotify') ?? false;
  // if (isNotify) {
  //   if (orderId != null && carName.isNotEmpty && dateList.isNotEmpty && dateList.length > 2 && userImgUrl.isNotEmpty && carImgUrl.isNotEmpty) {
  //     await OrderNotificationService().showScheduleNotification(
  //       id: orderId,
  //       title: 'Внимание!!!',
  //       body: 'Аренда вашего автомобиля $carName до ${dateList[0]}.${dateList[1]}.${dateList[2]} ${dateList[3]}:${dateList[4]} заканчивается через 1 час',
  //       dateTime: DateTime(
  //         int.tryParse(dateList[0])!,
  //         int.tryParse(dateList[1])!,
  //         int.tryParse(dateList[2])!,
  //         (int.tryParse(dateList[3]))! - 1,
  //         int.tryParse(dateList[4])!,
  //       ),
  //       seconds: 3,
  //       userImgUrl: userImgUrl,
  //       carImgUrl: carImgUrl,
  //     );
  //   }
  // }
  runApp(
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
        BlocProvider<CarListBloc>(
          create: (context) => CarListBloc(
            carRepository: carRepository,
          ),
        ),
        BlocProvider(
          create: (context) => FilterBloc(
            carRepository: carRepository,
          )..add(LoadFilter()),
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
      ),
    ),
  );
}

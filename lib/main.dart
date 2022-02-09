import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/cache/cache_helper.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/bloc_observe.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/screens/add_career_screen.dart';
import 'package:wazzaf/screens/auth/login_screen.dart';
import 'package:wazzaf/screens/auth/register_screen.dart';
import 'package:wazzaf/screens/auth/verification_screen.dart';
import 'package:wazzaf/screens/detail_screen.dart';
import 'package:wazzaf/screens/location.dart';
import 'package:wazzaf/screens/main_screen.dart';
import 'package:wazzaf/screens/search_career_screen.dart';
import 'package:wazzaf/screens/search_worker_screen.dart';
import 'package:wazzaf/screens/update_worker_data_screen.dart';
import 'package:wazzaf/screens/workers_screen.dart';
import 'package:wazzaf/styles/themes/themes.dart';

main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // var token = await FirebaseMessaging.instance.getToken();
  // print('token: $token');

  await CacheHelper.init();
  Widget? widget;
  uId = CacheHelper.getData(key: 'uId');

  if (uId != null) {
    widget = MainScreen();
  } else {
    widget = LoginScreen();
  }
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;
  const MyApp({Key? key, required this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => CareerCubit()
              ..getCareers()
              ..getWorkersData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        initialRoute: homeRoute,
        routes: {
          homeRoute: (context) => startWidget!,
          loginRoute: (context) => LoginScreen(),
          registerRoute: (context) => RegisterScreen(),
          verificationRoute: (context) => VerificationScreen(),
          addCareerRoute: (context) => AddCareerScreen(),
          detailRoute: (context) => DetailScreen(),
          locationRoute: (context) => Location(),
          mainRoute: (context) => MainScreen(),
          searchCareerRoute: (context) => SearchCareerScreen(),
          searchWorkerRoute: (context) => SearchWorkerScreen(),
          workersRoute: (context) => WorkersScreen(),
          updateDataRoute: (context) => UpdateDataScreen(),
        },
      ),
    );
  }
}

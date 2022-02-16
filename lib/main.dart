import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/cache/cache_helper.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/bloc_observe.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/login/login_cubit.dart';
import 'package:wazzaf/cubit/register/register_cubit.dart';
import 'package:wazzaf/models/user_model.dart';
import 'package:wazzaf/screens/add_career_screen.dart';
import 'package:wazzaf/screens/auth/login_screen.dart';
import 'package:wazzaf/screens/auth/phone_auth.dart';
import 'package:wazzaf/screens/auth/register_screen.dart';
import 'package:wazzaf/screens/auth/verification_screen.dart';
import 'package:wazzaf/screens/chat_details.dart';
import 'package:wazzaf/screens/chats_screen.dart';
import 'package:wazzaf/screens/detail_screen.dart';
import 'package:wazzaf/screens/location.dart';
import 'package:wazzaf/screens/main_screen.dart';
import 'package:wazzaf/screens/picker_screen.dart';
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
    widget = const MainScreen();
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
  MyApp({Key? key, required this.startWidget}) : super(key: key);
  UserModel? userModel;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => CareerCubit()
              ..getUserData()
              ..getCareers()
              ..getWorkersData()),
        BlocProvider(
          create: (context) => LoginCubit()
            // ..getUsers()
            ..getWorkers()
            ..getCareers(),
        ),
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
          detailRoute: (context) => const DetailScreen(),
          locationRoute: (context) => Location(),
          mainRoute: (context) => const MainScreen(),
          searchCareerRoute: (context) => SearchCareerScreen(),
          searchWorkerRoute: (context) => SearchWorkerScreen(),
          workersRoute: (context) => const WorkersScreen(),
          updateDataRoute: (context) => UpdateDataScreen(),
          phoneRoute: (context) => PhoneAuth(),
          chatsRoute: (context) => const ChatsScreen(),
          chatDetailsRoute: (context) =>
              ChatDetails(userModel: CareerCubit.get(context).userModel!),
          pickerRoute: (context) => const PickerScreen()
        },
      ),
    );
  }
}

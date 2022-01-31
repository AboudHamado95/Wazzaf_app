import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wazzaf/styles/colors/colors.dart';

ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.amber,
    scaffoldBackgroundColor: Colors.yellow[50],
    appBarTheme: AppBarTheme(
        titleSpacing: 20.0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.amber[50]),
        backgroundColor: Colors.yellow[50],
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            fontFamily: 'Oswald',
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold)),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: defaultColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor,
      unselectedItemColor: Colors.grey,
      elevation: 20.0,
      backgroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black),
      subtitle1: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.3),
    ),
    fontFamily: 'Oswald');

ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: HexColor('333739'),
    appBarTheme: AppBarTheme(
        titleSpacing: 20.0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: HexColor('333739'),
        ),
        backgroundColor: Colors.amber,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            fontFamily: 'Oswald',
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold)),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.deepOrange),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey,
      elevation: 20.0,
      backgroundColor: HexColor('333739'),
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
      subtitle1: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.3),
    ),
    fontFamily: 'Oswald');

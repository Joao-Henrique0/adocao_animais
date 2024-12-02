import 'package:flutter/material.dart';

const Color corP = Color.fromRGBO(13, 71, 161, 1);

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
        seedColor: corP,
        primary: corP,
        secondary: Colors.amber[600],
        tertiary: Colors.black),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Color.fromRGBO(13, 71, 161, 1),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: corP,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: corP,
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(corP), // Cor de fundo
        foregroundColor:
            WidgetStatePropertyAll<Color>(Colors.white), // Cor do texto
      ),
    ));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        primary: Color.fromRGBO(69, 39, 160, 1),
        secondary: Colors.green,
        tertiary: Colors.white),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Color.fromRGBO(69, 39, 160, 1),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.deepPurple,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple[700],
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(
          Colors.deepPurple,
        ), // Cor de fundo
        foregroundColor:
            WidgetStatePropertyAll<Color>(Colors.white), // Cor do texto
      ),
    ));

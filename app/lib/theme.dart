import 'package:flutter/material.dart';

lightTheme() => ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff82adbe),
      ),
      useMaterial3: true,
    );

darkTheme() => ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff82adbe),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

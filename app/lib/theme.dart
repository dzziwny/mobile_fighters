import 'package:flutter/material.dart';

lightTheme() => ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.amber,
      ),
      useMaterial3: true,
    );

darkTheme() => ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.amber,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

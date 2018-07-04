import 'package:flutter/material.dart';
import 'pages/HomePage.dart';

void main() => runApp(
  new MaterialApp(
     theme: new ThemeData(
        primaryColor: const Color(0xFF8BC34A),
        primaryColorDark: const Color(0xFF689F38),
        accentColor: const Color(0xFFFF5252),
      ),
    home: new HomePage(),
  )
);
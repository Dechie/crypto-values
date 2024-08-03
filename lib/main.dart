import 'package:flutter/material.dart';

import 'constants.dart';
import 'price_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        //primaryColor:
        primaryColor: Colors.lightBlue,
        scaffoldBackgroundColor: commonDarkBlue,
        appBarTheme: const AppBarTheme().copyWith(),
      ),
      home: const PriceScreen(),
    );
  }
}

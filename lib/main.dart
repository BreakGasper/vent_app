import 'package:flutter/material.dart';
import 'package:vent_app/src/views/design_main.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home_screen',
      routes: {'home_screen': (BuildContext context) => MainInitScreen()},
    );
  }
}

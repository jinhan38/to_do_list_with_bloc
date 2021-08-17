import 'package:flutter/material.dart';
import 'package:to_do_list_with_bloc/screen/home_screen.dart';
import 'package:to_do_list_with_bloc/screen/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'to_do_list_with_bloc',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}


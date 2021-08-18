import 'dart:async';

import 'package:flutter/material.dart';
import 'package:to_do_list_with_bloc/Person.dart';
import 'package:to_do_list_with_bloc/screen/home_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text("mainScreen")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text("페이지 이동"),
            ),
          ],
        ),
      ),
    );
  }


}

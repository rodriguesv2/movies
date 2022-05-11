import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie2you/app/pages/details_page.dart';
import 'package:movie2you/app/pages/home_page.dart';
import 'package:movie2you/app/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie2You',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color.fromRGBO(28, 26, 41, 1),
        textTheme: const TextTheme(
            headline5: TextStyle(
              color: Colors.white,
            ),
            headline6: TextStyle(color: Colors.white)),
      ),
      routes: {
        Routes.HOME: (ctx) => const HomePage(),
        Routes.DETAILS: (ctx) => const DetailsPage(),
      },
    );
  }
}

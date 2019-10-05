import 'package:flutter/material.dart';

import 'screens/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Play FM',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF2B159E),
        scaffoldBackgroundColor: Color(0xFF2B159E),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

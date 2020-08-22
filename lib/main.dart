import 'package:flutter/material.dart';
import 'package:watched_it/pages/home_screen_with_bottom_nav.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watched It',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFC00FF),
        accentColor: Color(0xFF00DBDE),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreenWithBottomNav(),
    );
  }
}

// ignore_for_file: prefer_const_constructors


import 'package:flutter/material.dart';
import 'pages/map_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Google Maps App",
      home: MapSample(),
    );
  }
}


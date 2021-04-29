import 'package:flutter/material.dart';
import 'flip_clock.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FlipClock(),
        backgroundColor: Colors.black,
      ),
    );
  }
}

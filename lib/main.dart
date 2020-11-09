import 'package:flutter/material.dart';

void main() {
  runApp(RorschachApp());
}

class RorschachApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rorschach',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Rorschach(),
    );
  }
}

// Algorithm:
// Make blob class that has set of points and a set of mirror points.Randomly
// generate these blobs at app start.
//
// At each animation tick, draw filled path enclosing points and shift them
// slightly by random amounts. Make sure mirror points also shift by same amount.
// The shifting will generate the animated ink effect.
//
// Have a button to restart the whole operation with new set of
// randomly generated blobs.
class Rorschach extends StatefulWidget {
  @override
  _RorschachState createState() => _RorschachState();
}

class _RorschachState extends State<Rorschach> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Rorschach pattern generator"),
      ),
    );
  }
}

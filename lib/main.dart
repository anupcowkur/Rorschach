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
// Idea 1:
// Make blob class that has set of points and a set of mirror points.Randomly
// generate these blobs at app start.
//
// At each animation tick, draw filled path enclosing points and shift them
// slightly by random amounts. Make sure mirror points also shift by same amount.
// The shifting will generate the animated ink effect.
//
// Have a button to restart the whole operation with new set of
// randomly generated blobs.
//
// Idea 2:
// Starting at center of widget, traverse from point to edge of circle one pixel
// at time. Randomly decide whether to draw a random sized disk at each pixel.
// If yes, draw disk and draw a mirror disk. Mirror point can be found using
// the formula to find third vertex of an isosceles triangle since current point,
// center of widget and mirror point form an isosceles triangle.
// Once end is reach, rotate by 5 degrees and walk again from center to end
// repeating the same. To animate, shift points by some positive and negative
// value.
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

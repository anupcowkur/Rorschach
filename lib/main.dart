import 'dart:math';

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
      body: SizedBox.expand(child: CustomPaint(painter: RorschachPainter())),
    );
  }
}

class RorschachPainter extends CustomPainter {
  final Paint _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2 - 24;
    canvas.drawCircle(center, radius, _paint);

    for (int i = 0; i <= 18; i++) {
      double angle = 10.0 * i;
      angle = angle * (pi / 180); // Convert from Degrees to Radians
      double x = center.dx + radius * sin(angle);
      double y = center.dy + radius * cos(angle);
      canvas.drawLine(center, Offset(x, y), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

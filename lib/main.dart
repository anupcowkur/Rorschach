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
//
// Idea 3: https://codegolf.stackexchange.com/a/24196
// Randomly walk from a starting point, putting points and then somehow mirror it.

class Rorschach extends StatefulWidget {
  @override
  _RorschachState createState() => _RorschachState();
}

class _RorschachState extends State<Rorschach> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomPaint(painter: RorschachPainter()),
      )),
    );
  }
}

class RorschachPainter extends CustomPainter {
  final Paint _paint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;

  final Random rng = Random();

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: randomize start point
    Offset point = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 50000; i++) {
      List<Offset> directions = List<Offset>();
      if (point.dx + 1 <= size.width) {
        directions.add(Offset(point.dx + 1, point.dy));
      }
      if (point.dx - 1 >= 0.0) {
        directions.add(Offset(point.dx - 1, point.dy));
      }
      if (point.dy + 1 <= size.height) {
        directions.add(Offset(point.dx, point.dy + 1));
      }
      if (point.dy - 1 >= 0.0) {
        directions.add(Offset(point.dx, point.dy - 1));
      }

      int nextIndex = rng.nextInt(directions.length);

      point = directions[nextIndex];
      canvas.drawCircle(point, rng.nextDouble(), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

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

// TODO: animate point shifts by random amounts
// TODO: animate transition of points from one pattern to another
class Rorschach extends StatefulWidget {
  @override
  _RorschachState createState() => _RorschachState();
}

class _RorschachState extends State<Rorschach> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
          child: Padding(
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

  final Random _rng = Random();

  List<Offset> _points = List<Offset>();

  void _generatePoints(Size size) {
    Offset point = Offset(size.width / 4, size.height / 2);

    for (int i = 0; i < 50000; i++) {
      List<Offset> directions = List<Offset>();
      if (point.dx + 1 <= size.width / 2) {
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

      int nextIndex = _rng.nextInt(directions.length);

      point = directions[nextIndex];
      _points.add(point);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_points.isEmpty) {
      _generatePoints(size);
    }

    _points.forEach((point) {
      double radius = _rng.nextDouble() * 1.4;
      canvas.drawCircle(point, radius, _paint);
      Offset mirrorPoint = Offset(size.width - point.dx, point.dy);
      canvas.drawCircle(mirrorPoint, radius, _paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

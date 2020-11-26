import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const maxPoints = 5000;
const maxRadius = 3.5;
const maxOffset = 3;
const stepSize = 4;
const animationInterval = 90;

void main() {
  runApp(RorschachApp());
}

class RorschachApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rorschach',
      home: Rorschach(),
    );
  }
}

class Point {
  final Offset offset;
  final double radius;

  Point(this.offset, this.radius);
}

// TODO: smoothly animate point change from one offset position to another. Each point should move indepentendly of others though.
// TODO: animate transition of points from one pattern to another
class Rorschach extends StatefulWidget {
  @override
  _RorschachState createState() => _RorschachState();
}

class _RorschachState extends State<Rorschach> {
  Timer _timer;

  List<Point> _points = List<Point>();
  List<Point> _pointsWithRandomOffset = List<Point>();
  Random _rng = Random();

  @override
  void initState() {
    super.initState();

    _timer =
        Timer.periodic(Duration(milliseconds: animationInterval), (Timer t) {
      setState(() {
        _clearAndGenerateRandomOffsetsForPoints();
      });
    });
  }

  void _generatePoints(Size size) {
    Offset point = Offset(size.width / 4, size.height / 2);

    for (int i = 0; i < maxPoints; i++) {
      List<Offset> directions = List<Offset>();
      if (point.dx + stepSize <= size.width / 2) {
        directions.add(Offset(point.dx + stepSize, point.dy));
      }
      if (point.dx - stepSize >= 0.0) {
        directions.add(Offset(point.dx - stepSize, point.dy));
      }
      if (point.dy + stepSize <= size.height) {
        directions.add(Offset(point.dx, point.dy + stepSize));
      }
      if (point.dy - stepSize >= 0.0) {
        directions.add(Offset(point.dx, point.dy - stepSize));
      }

      int nextIndex = _rng.nextInt(directions.length);

      point = directions[nextIndex];
      _points.add(Point(point, _rng.nextDouble() * maxRadius));
    }
  }

  void _clearAndGenerateRandomOffsetsForPoints() {
    _pointsWithRandomOffset.clear();
    _points.forEach((point) {
      Offset offsetPoint = Offset(point.offset.dx + _generateRandomOffset(),
          point.offset.dy + _generateRandomOffset());
      _pointsWithRandomOffset.add(Point(offsetPoint, point.radius));
    });
  }

  double _generateRandomOffset() {
    if (_rng.nextDouble() > 0.5) {
      return _rng.nextDouble() * maxOffset;
    } else {
      return _rng.nextDouble() * -maxOffset;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox.expand(
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      if (_points.isEmpty) {
                        _generatePoints(constraints.biggest);
                      }
                      return CustomPaint(
                          painter: RorschachPainter(_pointsWithRandomOffset));
                    },
                  ),
                ),
                SizedBox(height: 80),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () => this.setState(() {
                          _points.clear();
                          _pointsWithRandomOffset.clear();
                        }),
                    child: Text("REGENERATE"))
              ],
            ),
          )),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}

class RorschachPainter extends CustomPainter {
  final Paint _paint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;

  final List<Point> _points;

  RorschachPainter(this._points);

  @override
  void paint(Canvas canvas, Size size) {
    _points.forEach((point) {
      canvas.drawCircle(point.offset, point.radius, _paint);
      Offset mirrorPoint =
          Offset(size.width - point.offset.dx, point.offset.dy);
      canvas.drawCircle(mirrorPoint, point.radius, _paint);
    });
  }

  @override
  bool shouldRepaint(RorschachPainter oldDelegate) {
    return !listEquals(_points, oldDelegate._points);
  }
}

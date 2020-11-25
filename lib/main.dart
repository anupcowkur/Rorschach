import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const maxPoints = 5000;
const maxRadius = 3.5;
const maxOffset = 3;
const stepSize = 4;
const animationDuration = 500;

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

class Point {
  final Offset offset;
  final double radius;

  Point(this.offset, this.radius);
}

// TODO: Points are animating on every build, not controlled by anim duration. Need to fix that.
// TODO: animate transition of points from one pattern to another
class Rorschach extends StatefulWidget {
  @override
  _RorschachState createState() => _RorschachState();
}

class _RorschachState extends State<Rorschach>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  List<Point> _points;
  Random _rng;

  @override
  void initState() {
    super.initState();

    _rng = Random();
    _points = List<Point>();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationDuration),
    )..addListener(() {
        setState(() {});
      });

    _animationController.repeat();
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
                      return CustomPaint(painter: RorschachPainter(_points));
                    },
                  ),
                ),
                SizedBox(height: 80),
                ElevatedButton(
                    onPressed: () => this.setState(() {
                          _points.clear();
                        }),
                    child: Text("REGENERATE"))
              ],
            ),
          )),
    ));
  }
}

class RorschachPainter extends CustomPainter {
  final Paint _paint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;

  final Random _rng = Random();

  final List<Point> _points;

  RorschachPainter(this._points);

  @override
  void paint(Canvas canvas, Size size) {
    _points.forEach((point) {
      Offset offsetPoint = Offset(point.offset.dx + _generateRandomOffset(),
          point.offset.dy + _generateRandomOffset());
      canvas.drawCircle(offsetPoint, point.radius, _paint);
      Offset mirrorPoint = Offset(size.width - offsetPoint.dx, offsetPoint.dy);
      canvas.drawCircle(mirrorPoint, point.radius, _paint);
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
  bool shouldRepaint(RorschachPainter oldDelegate) {
    return !listEquals(_points, oldDelegate._points);
  }
}

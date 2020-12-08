import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const int maxPoints = 4000;
const double maxRadius = 3.5;
const double maxOffset = 1.5;
const double maxDistance = 2;
const double pointMoveCloserStepFactor = 0.7;
const int randomWalkStepSize = 4;
const int animationInterval = 60;

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
  Offset baseOffset;
  Offset renderOffset;
  double radius;
  final Random _rng = Random();

  void _updatePosition() {
    if ((baseOffset - renderOffset).distance > maxDistance) {
      _updatePositionToMoveCloserToNewOffset();
    } else {
      _updatePositionRandomly();
    }
  }

  void _updatePositionRandomly() {
    renderOffset = Offset(baseOffset.dx + _generateRandomOffset(),
        baseOffset.dy + _generateRandomOffset());
  }

  void _updatePositionToMoveCloserToNewOffset() {
    Offset newOffset =
        baseOffset + (renderOffset - baseOffset) * pointMoveCloserStepFactor;

    renderOffset = Offset(newOffset.dx + _generateRandomOffset(),
        newOffset.dy + _generateRandomOffset());
  }

  double _generateRandomOffset() {
    if (_rng.nextDouble() > 0.5) {
      return _rng.nextDouble() * maxOffset;
    } else {
      return _rng.nextDouble() * -maxOffset;
    }
  }
}

class Rorschach extends StatefulWidget {
  @override
  _RorschachState createState() => _RorschachState();
}

class _RorschachState extends State<Rorschach> {
  Timer _timer;
  List<Point> _points = List<Point>();
  Random _rng = Random();
  bool _isPatternGenerationRequired = true;

  @override
  void initState() {
    super.initState();

    // Initialize points list with empty points
    for (int i = 0; i < maxPoints; i++) {
      _points.add(Point());
    }

    // Initialize timer
    _timer =
        Timer.periodic(Duration(milliseconds: animationInterval), (Timer t) {
      setState(() {
        _updatePointPositions();
      });
    });
  }

  void _generatePattern(Size size) {
    Offset offset = Offset(size.width / 4, size.height / 2);

    for (int i = 0; i < maxPoints; i++) {
      List<Offset> directions = List<Offset>();
      if (offset.dx + randomWalkStepSize <= size.width / 2) {
        directions.add(Offset(offset.dx + randomWalkStepSize, offset.dy));
      }
      if (offset.dx - randomWalkStepSize >= 0.0) {
        directions.add(Offset(offset.dx - randomWalkStepSize, offset.dy));
      }
      if (offset.dy + randomWalkStepSize <= size.height) {
        directions.add(Offset(offset.dx, offset.dy + randomWalkStepSize));
      }
      if (offset.dy - randomWalkStepSize >= 0.0) {
        directions.add(Offset(offset.dx, offset.dy - randomWalkStepSize));
      }

      int nextIndex = _rng.nextInt(directions.length);

      offset = directions[nextIndex];
      Point point = _points[i];
      point.baseOffset = offset;
      // When generating the first pattern, there will be no render offset since
      // the point will be empty. In this case, we just set render offset to
      // base offset.
      if (point.renderOffset == null) {
        point.renderOffset = offset;
      }
      point.radius = _rng.nextDouble() * maxRadius;
    }

    _isPatternGenerationRequired = false;
  }

  //TODO: Jank can still be improved.Try something.
  void _updatePointPositions() {
    _points.forEach((point) {
      point._updatePosition();
    });
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
                      if (_isPatternGenerationRequired) {
                        _generatePattern(constraints.biggest);
                      }
                      return CustomPaint(painter: RorschachPainter(_points));
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
                          setState(() {
                            _isPatternGenerationRequired = true;
                          });
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
      canvas.drawCircle(point.renderOffset, point.radius, _paint);
      Offset mirrorPoint =
          Offset(size.width - point.renderOffset.dx, point.renderOffset.dy);
      canvas.drawCircle(mirrorPoint, point.radius, _paint);
    });
  }

  @override
  bool shouldRepaint(RorschachPainter oldDelegate) {
    return !listEquals(_points, oldDelegate._points);
  }
}

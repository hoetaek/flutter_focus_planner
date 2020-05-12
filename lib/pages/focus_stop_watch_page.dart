import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:focusplanner/models/goal.dart';

class FocusStopWatchPage extends StatefulWidget {
  final List<Goal> focusWorkOnProgress;

  const FocusStopWatchPage({Key key, this.focusWorkOnProgress})
      : super(key: key);
  @override
  _FocusStopWatchPageState createState() => _FocusStopWatchPageState();
}

class _FocusStopWatchPageState extends State<FocusStopWatchPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  String get timerString {
    Duration duration = _controller.duration * _controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          buildGoalTile(),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: FractionalOffset.center,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                            child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, widget) {
                            return CustomPaint(
                              painter: TimerPainter(
                                animation: _controller,
                                backgroundColor: Colors.white,
                                color: Colors.pink,
                              ),
                            );
                          },
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ListView buildGoalTile() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.focusWorkOnProgress.length,
        itemBuilder: (context, index) {
          Goal goal = widget.focusWorkOnProgress[index];
          return CheckboxListTile(
            secondary: Icon(
              Goal.getIconData(goal.difficulty),
              color: Goal.getDifficultyColor(goal.difficulty),
            ),
            title: Text(goal.name),
            value: goal.checked,
            onChanged: (bool checked) {
              setState(() {
                goal.check(checked);
              });
            },
          );
        });
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);
  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

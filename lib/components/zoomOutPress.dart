import 'dart:async';

import 'package:flutter/widgets.dart';

class ZoomOutPress extends StatefulWidget {
  Widget child;
  Function onPress;
  Duration duration;
  double toScale;
  late Duration longPressDuration;
  ZoomOutPress({
    Key? key,
    required this.child,
    required this.onPress,
    this.duration = const Duration(milliseconds: 200),
    this.toScale = 0.98,
  }) {
    longPressDuration = Duration(milliseconds: duration.inMilliseconds + 100);
  }

  @override
  _ZoomOutPressState createState() => _ZoomOutPressState();
}

class _ZoomOutPressState extends State<ZoomOutPress> {
  double scale = 1;
  String pressType = 'normal';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedScale(
        scale: scale,
        duration:
            pressType == 'normal' ? widget.duration : widget.longPressDuration,
        curve: Curves.easeInOut,
        child: widget.child,
      ),
      onTap: () {
        setState(() {
          pressType = 'normal';
          scale = widget.toScale;
        });
        Timer(widget.duration, () {
          setState(() {
            scale = 1;
          });
          widget.onPress();
        });
      },
      onTapDown: (detail) {
        setState(() {
          pressType = 'longPress';
          scale = widget.toScale - 0.02;
        });
      },
      onTapCancel: () {
        setState(() {
          scale = 1;
        });
      },
      onLongPressCancel: () {
        setState(() {
          scale = 1;
        });
      },
      onLongPressUp: () {
        setState(() {
          scale = 1;
        });
        widget.onPress();
      },
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

import '../../../ui/app_theme.dart';
import '../../../ui/build_context_util.dart';
import '../page_view.dart';

/// Paints a timeline segment with a single 'dot'
class TimelinePainter extends CustomPainter {
  TimelinePainter({this.dotRadius = 4});
  final double dotRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = AppColors.primary
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    const double dotLocation = 10.0;

    const Offset topLineStart = Offset.zero;
    final Offset topLineEnd = Offset(0, dotLocation - dotRadius);
    const Offset dotOffset = Offset(0, dotLocation);
    final Offset bottomLineStart = Offset(0, dotLocation + dotRadius);
    final Offset bottomLineEnd = Offset(0, size.height);
    canvas
      ..drawLine(topLineStart, topLineEnd, paint)
      ..drawCircle(dotOffset, dotRadius, paint)
      ..drawLine(bottomLineStart, bottomLineEnd, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum CapPosition { top, bottom }

class TimelineCap extends StatelessWidget {
  const TimelineCap({super.key, this.position = CapPosition.top, this.height});

  final CapPosition position;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final double capHeight = height ?? context.breakpoint.spacing;
    return SizedBox(
      height: capHeight,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            bottom: 0,
            left: sidebarWidth / 2,
            width: sidebarWidth,
            child: CustomPaint(
              painter: TimelineCapPainter(
                height: capHeight,
                capPosition: position,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineCapPainter extends CustomPainter {
  TimelineCapPainter({this.height = 8, this.capPosition = CapPosition.top});

  final double height;
  final CapPosition capPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = AppColors.primary
          ..strokeWidth = capPosition == CapPosition.top ? 0.0 : 2.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    int i = 0;
    while (i < height) {
      paint.strokeWidth =
          capPosition == CapPosition.top
              ? min(2, paint.strokeWidth + (2 / height))
              : paint.strokeWidth - (2 / height);
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(0, (i + 1).toDouble()),
        paint,
      );
      i++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

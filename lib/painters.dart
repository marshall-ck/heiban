import 'dart:ui';

import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final List<Path> paths;
  final List<Offset> offsets;

  LinePainter(this.paths, this.offsets): super();

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: refactor this for performance
    final paint = Paint()
      ..color = Colors.deepPurple
      ..isAntiAlias = true
      ..strokeWidth = 3;

    // TODO include all other paints too
    for (var i = 0; i < offsets.length-1; i++) {
      if (offsets[i] != null && offsets[i + 1] != null) {
        canvas.drawLine(offsets[i], offsets[i+1], paint);
      } else if(offsets[i] != null && offsets[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [offsets[i]], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// TODO: add an action to delete sticky
class StickyNotePainter extends CustomPainter {
  final List<Offset> offsets;
  final List<Path> paths;

  final Offset offset;

  StickyNotePainter(this.paths, this.offsets, this.offset): super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..isAntiAlias = true;

    if (offset != null) {
      final height = 100.0, width = 100.0; // sticky note size

      Path path = new Path();
      path.moveTo(offset.dx, offset.dy);
      path.lineTo(offset.dx + width, offset.dy);
      path.lineTo(offset.dx + width, offset.dy + height);
      double foldAmount = 0.12;
      path.lineTo(offset.dx + width * 3 / 4, offset.dy + height);
      path.quadraticBezierTo(
          offset.dx + width * foldAmount * 2, offset.dy + height,
          offset.dx + width * foldAmount,
          offset.dy + height - (height * foldAmount)
      );
      path.quadraticBezierTo(
          offset.dx, offset.dy + height - (height * foldAmount * 1.5),
          offset.dx, offset.dy + height / 4
      );
      path.lineTo(offset.dx, offset.dy);
      paths.add(path);
    }

    // TODO include all other paints too
    for(var i = 0; i < paths.length-1; i++) { canvas.drawPath(paths[i], paint);}
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
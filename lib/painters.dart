import 'dart:ui';

import 'package:flutter/material.dart';

class CanvasPainter extends CustomPainter {
  final List<Offset> stickyNoteOffsets;
  final List<Offset> lineOffsets;

  CanvasPainter(this.stickyNoteOffsets, this.lineOffsets): super();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
        ..color = Colors.deepPurpleAccent
        ..isAntiAlias = true
        ..strokeWidth = 3;

    final stickyNotePaint = Paint()
        ..color = Colors.amber
        ..isAntiAlias = true
        ..strokeWidth = 3;

    paintLines(canvas, linePaint);
    for (var stickyOffset in stickyNoteOffsets) {
      paintStickyNotes(stickyOffset, canvas, stickyNotePaint);
    }
  }

  void paintLines(Canvas canvas, Paint paint) {
    for (var i = 0; i < lineOffsets.length-1; i++) {
      if (lineOffsets[i] != null && lineOffsets[i + 1] != null) {
        canvas.drawLine(lineOffsets[i], lineOffsets[i+1], paint);
      } else if(lineOffsets[i] != null && lineOffsets[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [lineOffsets[i]], paint);
      }
    }
  }
  
  void paintStickyNotes(Offset offset, Canvas canvas, Paint paint) {
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
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
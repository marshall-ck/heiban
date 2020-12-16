import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:heiban/main.dart';
import 'package:heiban/sticky_note.dart';

class CanvasPainter extends CustomPainter {
  final List<LineElement> lineElements;
  final LineElement currentLine;

  CanvasPainter(this.lineElements, this.currentLine): super();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
        ..color = Colors.deepPurpleAccent
        ..isAntiAlias = true
        ..strokeWidth = 3;

    paintLines(canvas, linePaint, currentLine.lineOffsets);
    for (var i = 0; i < lineElements.length-1; i++) {
      paintLines(canvas, linePaint, lineElements[i].lineOffsets);
    }
  }

  void paintLines(Canvas canvas, Paint paint, List<Offset> lineOffsets) {
    for (var i = 0; i < lineOffsets.length-1; i++) {
      if (lineOffsets[i] != null && lineOffsets[i + 1] != null) {
        canvas.drawLine(lineOffsets[i], lineOffsets[i+1], paint);
      } else if(lineOffsets[i] != null && lineOffsets[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [lineOffsets[i]], paint);
      }
    }
  }
  
  void paintStickyNotes(StickyNote stickyNote, Canvas canvas, Paint paint) {
    final height = 150.0, width = 150.0; // sticky note size

    Offset offset = stickyNote.stickyNoteOffset;
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
import 'dart:ui';
import 'package:flutter/material.dart';

class StickyNote {
  final height = 150.0, width = 150.0; // sticky note size
  final deleteButtonHeight = 10.0, deleteButtonWidth = 15.0; // delete button size
  Offset stickyNoteOffset;
  Offset deleteButtonOffset;
  String text;
  Positioned textInputField;

  StickyNote(Offset stickyNoteOffset) {
    this.stickyNoteOffset = stickyNoteOffset;
    this.deleteButtonOffset = stickyNoteOffset.translate(
        width - deleteButtonWidth, deleteButtonHeight
    );
    this.text = null;
  }

  void updatePosition(Offset localPosition) {
    this.stickyNoteOffset = localPosition;
    this.deleteButtonOffset = localPosition.translate(
        width - deleteButtonWidth, deleteButtonHeight
    );
  }

  bool insideDeleteButton(offset) {
    return (deleteButtonOffset - offset).distance <= 10.0;
  }

  bool insideElement(offset) {
    return (
        offset.dx >= stickyNoteOffset.dx &&
            offset.dx <= stickyNoteOffset.dx + width &&
            offset.dy >= stickyNoteOffset.dy &&
            offset.dy <= stickyNoteOffset.dy + height
    );
  }

  void paint(Canvas canvas, Size size) {
    final height = 150.0, width = 150.0; // sticky note size

    final paint = Paint()
      ..color = Colors.amber
      ..isAntiAlias = true
      ..strokeWidth = 3;

    Offset offset = stickyNoteOffset;
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

    // draw delete icon
    Offset deleteButtonOffset = this.deleteButtonOffset;
    final crossLinePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5;
    canvas.drawLine(deleteButtonOffset, deleteButtonOffset.translate(10.0, 10.0), crossLinePaint);
    canvas.drawLine(deleteButtonOffset.translate(10.0, 0), deleteButtonOffset.translate(0, 10.0), crossLinePaint);

    // draw text
    if (this.text != null && this.textInputField == null) {
      TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black), text: this.text);
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, stickyNoteOffset.translate(15.0, 15.0));
    }
  }
}
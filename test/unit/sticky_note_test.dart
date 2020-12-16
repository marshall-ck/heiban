import 'package:flutter_test/flutter_test.dart';
import 'package:heiban/sticky_note.dart';

void main() {
  StickyNote stickyNote;

  test('init model', () {
    stickyNote = new StickyNote(new Offset(0, 0));
    expect(stickyNote.textInputField, null);
    expect(stickyNote.stickyNoteOffset.dx, 0);
    expect(stickyNote.stickyNoteOffset.dy, 0);
    expect(stickyNote.deleteButtonOffset.dx, 135.0);
    expect(stickyNote.deleteButtonOffset.dy, 10.0);
    expect(stickyNote.text, null);
  });
}
import 'dart:ui';

import 'package:flutter/material.dart';
import 'painters.dart';

void main() {
  runApp(MyApp());
}

enum ToolType {
  pencil,
  eraser,
  stickyNote
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heiban - just another online whiteboard',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: CanvasPage(title: 'Heiban'),
    );
  }
}

class CanvasPage extends StatefulWidget {
  CanvasPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  final _lineOffsets = <Offset>[]; // used for line drawing
  final _stickyOffsets = <Offset>[]; // used for sticky notes
  var _currentTool = ToolType.pencil;

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
                backgroundColor: _currentTool == ToolType.pencil ? Colors.red : Colors.grey,
                onPressed: () {
                  setState(() {
                    _currentTool = ToolType.pencil;
                  });
                },
                child: Icon(Icons.edit)
              ),
            FloatingActionButton(
                backgroundColor: _currentTool == ToolType.eraser ? Colors.red : Colors.grey,
                onPressed: () {
                  setState(() {
                    _currentTool = ToolType.eraser;
                  });
                },
                child: Icon(Icons.backspace_sharp)
            ),
            FloatingActionButton(
                backgroundColor: _currentTool == ToolType.stickyNote ? Colors.red : Colors.grey,
                onPressed: () {
                  setState(() {
                    _currentTool = ToolType.stickyNote;
                  });
                  },
                child: Icon(Icons.note)
            ),
          ],
        ),
      body: GestureDetector(
        onPanDown: (details) {
          final renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          setState(() {
            updateCanvas(localPosition);
          });
        },
        onPanUpdate: (details) {
          final renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          setState(() {
            updateCanvas(localPosition);
          });
        },
        onPanEnd: (details) {
          setState(() {
            _lineOffsets.add(null);
          });
        },
        child: Center(
            child: CustomPaint(
                painter: CanvasPainter(_stickyOffsets, _lineOffsets),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                )
            )
        ),
      ),
    );
  }

  void updateCanvas(Offset localPosition) {
    if (_currentTool == ToolType.pencil) {
      _lineOffsets.add(localPosition);
    } else if (_currentTool == ToolType.stickyNote) {
      _stickyOffsets.add(localPosition);
    } else if (_currentTool == ToolType.eraser) {
      // TODO: eraser is buggy
      var offsetsToRemove = _lineOffsets.where((element) =>
      element != null &&
          (element.dx >= localPosition.dx - 10 && element.dx <= localPosition.dx + 10) &&
          (element.dy >= localPosition.dy - 10 && element.dy <= localPosition.dy + 10)
      );
      offsetsToRemove.forEach((e) => _lineOffsets.remove(e));
    }
  }
}
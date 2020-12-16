import 'dart:ui';

import 'package:flutter/material.dart';
import 'painters.dart';

void main() {
  runApp(MyApp());
}

enum ToolType {
  pencil,
  eraser,
  selector,
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

class LineElement {
  final List<Offset> lineOffsets;
  LineElement(this.lineOffsets);
}

class _CanvasPageState extends State<CanvasPage> {
  var _currentTool = ToolType.pencil;
  int _selectedIndex = 0;

  final _lineElements = <LineElement>[];
  var _currentLine = new LineElement(<Offset>[]);
  var canvasElements = <Widget>[]; // TODO: all types of drawings should have a common baseType: <CanvasElement>

  void _onItemTapped(int index) {
    setState(() { _selectedIndex = index; });

    switch (index) {
      case 0: { setState(() { _currentTool = ToolType.pencil; }); }
      break;

      case 1: { setState(() { _currentTool = ToolType.eraser; }); }
      break;

      case 2: { setState(() { _currentTool = ToolType.selector; }); }
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'pencil'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.undo),
            label: 'undo'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.zoom_out_map),
              label: 'selector'
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: GestureDetector(
        onPanDown: (details) {
          print("onPanDown");
          print("currentLine count: ${_currentLine.lineOffsets.length}");
          print("lineElements count: ${_lineElements.length}");

          final renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          setState(() {
            if (_currentTool == ToolType.pencil) {
              _currentLine.lineOffsets.add(localPosition);
            }
            if (_currentTool == ToolType.eraser) { handleEraserEvent(localPosition); }
          });
        },
        onPanUpdate: (details) {
          final renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          setState(() {
            if (_currentTool == ToolType.pencil) { _currentLine.lineOffsets.add(localPosition); }
            if (_currentTool == ToolType.eraser) { handleEraserEvent(localPosition); }
          });
        },
        onPanEnd: (details) {
          if (_currentTool == ToolType.pencil) {
            // NOTE: _currentLine is a cache for all lines, divided by null
            var _newLine = new LineElement(List.from(_currentLine.lineOffsets));
            setState(() {
              _lineElements.add(_newLine);
              _currentLine.lineOffsets.add(null);
            });
          }
        },
        child: Center(
            child: CustomPaint(
                painter: CanvasPainter(_lineElements, _currentLine),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(children: canvasElements)
                )
            )
        ),
      ),
    );
  }

  void handlePencilEvent(Offset localPosition) {
    _currentLine.lineOffsets.add(localPosition);
  }

  void handleEraserEvent(Offset localPosition) {
    // TODO: weird bug on not fully removing last line element
    if (_lineElements.isNotEmpty) {
      final delta = 10;

      // TODO: refactor this to lineElement model
      var lineElement = _lineElements.firstWhere((lineElement) {
        var offsets = lineElement.lineOffsets
            .where((offset) => offset != null).where((offset) =>
        localPosition.dx <= offset.dx + delta &&
            localPosition.dx >= offset.dx - delta &&
            localPosition.dy <= offset.dy + delta &&
            localPosition.dy >= offset.dy - delta
        );
        return offsets.isNotEmpty;
      }, orElse: null);

      if (lineElement != null) { _lineElements.remove(lineElement); }
    }

    if (_currentLine.lineOffsets.isNotEmpty) {
      _currentLine.lineOffsets.clear();
    }
  }

  void handleSelectorEvent(Offset localPosition) {
    // TODO: add selector event for drag
  }
}
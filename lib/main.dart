import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
      home: MyHomePage(title: 'Heiban'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _offsets = <Offset>[];
  String _currentTool = "pencil";

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
                backgroundColor: _currentTool == "pencil" ? Colors.red : Colors.grey,
                onPressed: () {
                  setState(() => _currentTool = "pencil");
                },
                child: Icon(Icons.edit)
              ),
            FloatingActionButton(
                backgroundColor: _currentTool == "eraser" ? Colors.red : Colors.grey,
                onPressed: () {
                  setState(() => _currentTool = "eraser");
                },
                child: Icon(Icons.backspace_sharp)
            ),
          ],
        ),
      body: GestureDetector(
        onPanDown: (details) {
          final renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          setState(() {
            updateOffsets(localPosition);
          });
        },
        onPanUpdate: (details) {
          final renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          setState(() {
            updateOffsets(localPosition);
          });
        },
        onPanEnd: (details) {
          setState(() => _offsets.add(null));
        },
        child: Center(
          child: CustomPaint(
            painter: HeibanPainter(_offsets),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            )
          )
        ),
      ),
    );
  }

  void updateOffsets(Offset localPosition) {
    if (_currentTool == "pencil") {
      _offsets.add(localPosition);
    } else if (_currentTool == "eraser") {
      var offsetsToRemove = _offsets.where((element) =>
      element != null &&
          (element.dx >= localPosition.dx - 10 && element.dx <= localPosition.dx + 10) &&
          (element.dy >= localPosition.dy - 10 && element.dy <= localPosition.dy + 10)
      );
      offsetsToRemove.forEach((e) => _offsets.remove(e));
    }
  }
}

class Tool {
  String name;
  Tool(this.name) {
    name = this.name;
  }
}

class HeibanPainter extends CustomPainter {
  final List<Offset> offsets;

  HeibanPainter(this.offsets): super();

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: refactor this for performance
    final paint = Paint()
    ..color = Colors.deepPurple
    ..isAntiAlias = true
    ..strokeWidth = 3;

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

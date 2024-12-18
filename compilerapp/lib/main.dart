import 'package:flutter/material.dart';
import 'compiler.dart'; // Import the compiler interface

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CompilerScreen(),
    );
  }
}

class CompilerScreen extends StatefulWidget {
  const CompilerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CompilerScreenState createState() => _CompilerScreenState();
}

class _CompilerScreenState extends State<CompilerScreen> {
  final TextEditingController _controller = TextEditingController();
  String _output = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offline C Compiler')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter C Code Here',
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _compileCCode,
                  child: Text('Compile'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _clearOutput,
                  child: Text('Clear'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Output:'),
            SizedBox(height: 10),
            Expanded(child: SingleChildScrollView(child: Text(_output))),
          ],
        ),
      ),
    );
  }

  void _compileCCode() async {
    String result = await compileCCode(_controller.text);
    setState(() {
      _output = result;
    });
  }

  void _clearOutput() {
    setState(() {
      _output = '';
      _controller.clear();
    });
  }
}

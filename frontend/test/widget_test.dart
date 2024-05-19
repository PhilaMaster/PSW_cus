import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Spring Boot Example')),
        body: Center(child: MyWidget()),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String _response = 'No response yet';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/hello'));
    if (response.statusCode == 200) {
      setState(() {
        _response = response.body;
      });
    } else {
      setState(() {
        _response = 'Failed to load data';
      });
    }
  }

  Future<void> _sendData() async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/data'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'key': 'value'}),
    );
    if (response.statusCode == 200) {
      setState(() {
        _response = response.body;
      });
    } else {
      setState(() {
        _response = 'Failed to send data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_response),
        ElevatedButton(
          onPressed: _sendData,
          child: Text('Send Data'),
        ),
      ],
    );
  }
}

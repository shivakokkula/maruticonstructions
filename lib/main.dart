import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'post.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> dataList = [];
  static const String id = "AKfycbysFGZWj9wi05Wkpi5zoT8ZSrEMcvLRgSX9_NwpBaPzFd3g-w9M2FksXmVdEiP4TYMV";
  static const String URL = "https://script.google.com/macros/s/$id/exec";
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(URL));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        dataList = List<Map<String, dynamic>>.from(jsonData);
      });
      print(dataList);
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maruti Constructions'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Post()),
                );
              },
              child: const Text('Post'))
          ],
        ),
        body: dataList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data = dataList[index];
            return DataEntryWidget(data: data);
          },
        ),
      ),
    );
  }
}
class DataEntryWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  DataEntryWidget({required this.data});
  @override
  Widget build(BuildContext context) {
    var textStyle = const TextStyle(color: Colors.white);
    return Card(
      elevation: 3,
      color: Colors.lightBlueAccent, // Adjust the color as needed
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataLabel(label: 'Date', value: data['date']),
            DataLabel(label: 'Name', value: data['name']),
            DataLabel(label: 'Amount', value: data['amount']),
            DataLabel(label: 'Reason', value: data['reason']),
            DataLabel(label: 'Mobile', value: data['mobile']),
            DataLabel(label: 'Month', value: data['month']),
          ],
        ),
      ),
    );
  }
}

class DataLabel extends StatelessWidget {
  final String label;
  final dynamic value;
  final Color labelColor=Colors.black;
  final Color valueColor=Colors.black;

  DataLabel({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('$label:', style: TextStyle(color: labelColor, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8.0),
        Text('$value', style: TextStyle(color: valueColor)),
      ],
    );
  }
}
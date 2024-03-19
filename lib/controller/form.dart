import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/form.dart';

class FormController {
  static const String id = "AKfycbxMDvbLUpRRqkkgxhkjX-Nxfp5L1_E-qo7P4EZp3_D4Z5YUEzYFnUEQJHtACoh44V5h";
  static const String URL = "https://script.google.com/macros/s/$id/exec";
  static const STATUS_SUCCESS = "SUCCESS";

  Future<void> fetchData() async {
    final response = await http.get(URL as Uri);

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> jsonData = json.decode(response.body);
      print(jsonData);
      // setState(() {
      //   data = "Name: ${jsonData['name']}\nAge: ${jsonData['age']}\nCity: ${jsonData['city']}";
      // });
    } else {
      // setState(() {
      //   data = "Error fetching data";
      // });
    }
  }

  void submitForm(
      Work work, void Function(String) callback) async {
    // callback(STATUS_SUCCESS);
    try {
      print(work.toJson());
      await http.post(Uri.parse(URL), body: work.toJson()).then((response) async {
        print(response.body);
        print(response.statusCode);
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(Uri.parse(url!)).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }
}
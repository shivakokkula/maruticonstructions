import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'controller/form.dart';
import 'model/form.dart';

class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maruti Constructions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Maruti Constructions'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final list = <String>['Mallesh Bava', 'Ashok', 'Materials', 'Others'];
  final formatter = DateFormat('dd.MM.yyyy');
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const style = TextStyle(fontSize: 20.0);
  static const link = "https://g.page/r/CUQABPo-5LuDEBI/review";
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  late String type;
  String month= "January";
  void _onDropDownItemSelected(String selectedmonth) {
    setState(() {
      month = selectedmonth;
    });
  }
  String capitalize(s) {
    return s != "" ? s[0].toUpperCase() + s.substring(1) : "";
  }
  void setvalues(String? value) {
    nameController.text=value!;
    if(value==list[0]){
      reasonController.text="Salary";
      amountController.text="30000";
      monthController.text=month;
      mobileController.text="9769625927";
    }
  }
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) =>
          const Center(child: CircularProgressIndicator()));
      String today = formatter.format(DateTime.now());
      Work work = Work(
          amountController.text,
          capitalize(nameController.text),
          capitalize(reasonController.text),
          monthController.text,
          mobileController.text,
          today,
          today.substring(6));
      FormController formController = FormController();
      formController.submitForm(work, (String response) async {
        if (response == FormController.STATUS_SUCCESS) {
          launchUrlString("https://wa.me/+91${work.mobile}?text=$link");
        } else {
          String result = "Error! Try Again";
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(result),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'))
                ],
              ));
        }
        _formKey.currentState!.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    type = list[0];
    setvalues(list[0]);
    return KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
        ],
        child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(widget.title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20)),
                      child: const Text('Submit'),
                    ),
                    ElevatedButton(
                      onPressed: () => _formKey.currentState!.reset(),
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20)),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      children: <Widget>[
                        DropdownButton<String>(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: "verdana_regular",
                          ),
                          hint: const Text(
                            "Select Bank",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: "verdana_regular",
                            ),
                          ),
                          items: list.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setvalues(value);
                            setState(() {
                              type = value!;
                            });
                          },
                          value: type,
                        ),
                        buildTextFormField(
                            nameController, TextInputType.text, 'Name'),
                        buildTextFormField(
                            reasonController, TextInputType.multiline, 'Reason'),
                        buildTextFormField(
                            amountController, TextInputType.number, 'Amount'),
                        buildTextFormField2(
                            monthController, TextInputType.text, 'Month'),
                        buildTextFormField2(
                            mobileController, TextInputType.number, 'Mobile'),
                        const SizedBox(height: 400)
                      ],
                    ),
                  ),
                ),
              ],
            ))
    );
  }

  TextFormField buildTextFormField2(controller, type, text) {
    return TextFormField(
      controller: controller,
      style: style,
      keyboardType: type,
      decoration: InputDecoration(labelText: text),
    );
  }

  TextFormField buildTextFormField(controller, type, text) {
    return TextFormField(
      controller: controller,
      style: style,
      keyboardType: type, maxLines: null,
      decoration: InputDecoration(labelText: text),
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter $text";
        }
        return null;
      },
    );
  }
}

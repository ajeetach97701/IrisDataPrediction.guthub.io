awimport 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Flower Class Prediction',
          ),
        ),
        body: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String prediction = "";
  TextEditingController sepalLength = TextEditingController();
  TextEditingController sepalWidth = TextEditingController();
  TextEditingController petalLength = TextEditingController();
  TextEditingController petalWidth = TextEditingController();

  Future<void> insert() async {
    if (sepalLength.text.isNotEmpty && sepalWidth.text.isNotEmpty ||
        petalLength.text.isNotEmpty ||
        petalWidth.text.isNotEmpty) {
      try {
        var res = await http.post(
            Uri.parse("http://127.0.0.1:5000/predict"),
            headers: {
              'Content-Type': 'application/json'
            },
            body: jsonEncode({
              "SepalLength": sepalLength.text.toString(),
              "SepalWidth": sepalWidth.text.toString(),
              "PetalLength": petalLength.text.toString(),
              "PetalWidth": petalWidth.text.toString()
            }));
        var data = jsonDecode(res.body);
        if (res.statusCode == 200) {

          // Data was successfully sent and processed
         prediction = data['prediction'];
         print(prediction);
        } else {
          // There was an error sending the data
          print('Error: ${res.statusCode}');
        }
        print(res.body);
      } catch (e) {
        debugPrint("Error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FlowerDetails(
              label: "Enter Sepal Length",
              controller: sepalLength,
            ),
            SizedBox(
              height: 10,
            ),
            FlowerDetails(
              label: "Enter Sepal Width",
              controller: sepalWidth,
            ),
            SizedBox(
              height: 10,
            ),
            FlowerDetails(
              label: "Enter Petal Length",
              controller: petalLength,
            ),
            SizedBox(
              height: 10,
            ),
            FlowerDetails(
              label: "Enter Petal Width",
              controller: petalWidth,
            ),
            TextButton(
              onPressed: () {
                debugPrint("${sepalLength.text}");
                insert();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                height: 50,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  "Predict",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(prediction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlowerDetails extends StatelessWidget {
  const FlowerDetails({super.key, required this.label, this.controller});

  final TextEditingController? controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
    );
  }
}

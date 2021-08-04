import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
Timer timer;
class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => readData());


  }

  String dropdownValue;
  bool isLoading = true;
  List<String> list = [];
  Future<void> readData() async {
    // Please replace the Database URL
    // which we will get in “Add Realtime Database”
    // step with DatabaseURL
    print("list= $list");
    list.clear();
    print("list after clear = $list");
    var url =
        "https://dropdownlist-e7fc6-default-rtdb.firebaseio.com/" + "days.json";
    // Do not remove “data.json”,keep it as it is
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print("extractedData= $extractedData");
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((id, data) {
        print("data=    $data");
        list.add(data);
      });
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RealTime Database',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Onwords Firebase dropdown"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? CircularProgressIndicator()
                  : DropdownButton(
                      // dropdownColor: Colors.purple,
                      hint: Text("Select any one devices"),
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      onChanged: (String newValue) {
                        setState(() {
                          print("dropdown value = $dropdownValue");
                          dropdownValue = newValue;
                          print("=============");
                          // print("dropdown value = $anwser");
                        });
                      },
                      items: list.map((value1) {
                        return DropdownMenuItem<String>(
                          value: value1,
                          child: Text(value1),
                        );
                      }).toList(),
                    ),
              SizedBox(
                height: 22.0,
              ),
              Text(" the Selected text value is ----- $dropdownValue"),
              SizedBox(height: 30,),
              Text(list.toString()),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

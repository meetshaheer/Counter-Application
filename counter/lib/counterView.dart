import 'package:flutter/material.dart';

class counterview extends StatefulWidget {
  const counterview({super.key});

  @override
  State<counterview> createState() => _counterviewState();
}

class _counterviewState extends State<counterview> {
  int counter = 0;

  changeval() {
    if (counter == 0) {
      counter = 1;
    } else {
      counter = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Center(
            child: Text(
              "Value is $counter",
              style: TextStyle(fontSize: 25),
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text("Add Values"))
        ],
      )),
    );
  }
}

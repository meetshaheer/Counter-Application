import 'package:flutter/material.dart';

class counterview extends StatefulWidget {
  const counterview({super.key});

  @override
  State<counterview> createState() => _counterviewState();
}

class _counterviewState extends State<counterview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Center(
            child: Text(
              "Value is 0",
              style: TextStyle(fontSize: 25),
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text("Add Values"))
        ],
      )),
    );
  }
}

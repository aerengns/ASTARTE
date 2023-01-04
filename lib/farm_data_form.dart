import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';

class FarmDataForm extends StatelessWidget {
  const FarmDataForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Farm Data'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text('Farm Data Form', style: TextStyle(fontSize: 20)),
      ),
      drawer: sideBar(context),
    );
  }
}
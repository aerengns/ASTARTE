import 'package:flutter/material.dart';
import 'package:my_app/sidebar.dart';

class Workers extends StatelessWidget {
  const Workers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workers'),
      ),
      body: Container(),
      drawer: sideBar(context),
    );
  }
}
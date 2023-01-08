import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';

class Workers extends StatelessWidget {
  const Workers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Workers'),
      body: Container(),
      drawer: NavBar(context),
    );
  }
}
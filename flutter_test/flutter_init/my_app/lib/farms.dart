import 'package:flutter/material.dart';
import 'package:my_app/sidebar.dart';

class Farms extends StatefulWidget {
  const Farms({Key? key}) : super(key: key);

  @override
  State<Farms> createState() => _FarmsState();
}

class _FarmsState extends State<Farms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farms'),
      ),
      body: Container(),
      drawer: sideBar(context),
    );
  }
}
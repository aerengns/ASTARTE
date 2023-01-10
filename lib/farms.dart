import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';

class Farms extends StatefulWidget {
  const Farms({Key? key}) : super(key: key);

  @override
  State<Farms> createState() => _FarmsState();
}

class _FarmsState extends State<Farms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Farms'),
      body: Container(),
      drawer: NavBar(context),
    );
  }
}
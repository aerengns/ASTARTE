import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/astarte.jpg',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Table(
              border: TableBorder.all(),
              children: const<TableRow>[
                TableRow(children: [
                  TableCell(child: Text("LOREM IPSUM")),
                  TableCell(child: Text("LOREM IPSUM")),
                  TableCell(child: Text("LOREM IPSUM")),
                  TableCell(child: Text("LOREM IPSUM"))
                ]),
                TableRow(children: [
                  Text("LOREM IPSUM"),
                  Text("LOREM IPSUM"),
                  Text("LOREM IPSUM"),
                  Text("LOREM IPSUM"),
                ]),
                TableRow(children: [
                  Text("LOREM IPSUM"),
                  Text("LOREM IPSUM"),
                  Text("LOREM IPSUM"),
                  Text("LOREM IPSUM")
                ]),
              ],
            ),
          ),
        ],
      ),
      drawer: NavBar(context),
    );
  }
}
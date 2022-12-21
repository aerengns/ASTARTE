import 'package:flutter/material.dart';

Widget sideBar(BuildContext context) {
  return Drawer(
    width: MediaQuery.of(context).size.width * 0.5,
    child: ListView(
      padding: const EdgeInsets.only(left: 8),
      children: <Widget>[
        // Add items to the sidebar here
        Container(
          height: 200,
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
              onPressed: () {},
              color: Colors.grey,
              icon: const Icon(Icons.account_circle_rounded, size: 50)),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        RawMaterialButton(
          textStyle: const TextStyle(color: Colors.grey),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.home_filled),
              Text("Home"),
              Icon(Icons.arrow_forward_ios_rounded)
            ],
          ),
        ),
        RawMaterialButton(
          textStyle: const TextStyle(color: Colors.grey),
          onPressed: () {
            Navigator.pushNamed(context, '/reports');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.add_chart),
              Text("Reports"),
              Icon(Icons.arrow_forward_ios_rounded)
            ],
          ),
        ),
        RawMaterialButton(
          textStyle: const TextStyle(color: Colors.grey),
          onPressed: () {
            Navigator.pushNamed(context, '/workers');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.people_alt_rounded),
              Text("Workers"),
              Icon(Icons.arrow_forward_ios_rounded)
            ],
          ),
        ),
        RawMaterialButton(
          textStyle: const TextStyle(color: Colors.grey),
          onPressed: () {
            Navigator.pushNamed(context, '/farms');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.warehouse_rounded),
              Text("Farms"),
              Icon(Icons.arrow_forward_ios_rounded)
            ],
          ),
        ),
        const SizedBox(height: 420,),
        RawMaterialButton(
          textStyle: const TextStyle(color: Colors.grey),
          onPressed: () {
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.settings),
              Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text("Settings")),
            ],
          ),
        ),
      ],
    ),
  );
}
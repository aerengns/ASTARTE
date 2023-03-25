import 'package:astarte/network_manager/models/sensor_data.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:provider/provider.dart';

import 'network_manager/services/sensor_data_service.dart';

class FarmData extends StatelessWidget {
  const FarmData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Farm Data'),
      body: const FarmDataForm(),
      drawer: NavBar(context),
    );
  }
}

class FarmDataForm extends StatefulWidget {
  const FarmDataForm({Key? key}) : super(key: key);

  @override
  State<FarmDataForm> createState() => _FarmDataFormState();
}

class _FarmDataFormState extends State<FarmDataForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Farm Name',
                    hintText: 'Enter Farm Name',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Date',
                    hintText: 'Enter Date',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Moisture',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Phosphorus',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Potassium',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Nitrogen',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: const BorderSide(color: Colors.red)
                          )
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(12.0)
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: () async {
                      final response = await Provider.of<SensorDataService>(context, listen: false).saveSensorData(
                        // TODO: replace with data written in form text fields
                        SensorData(
                                (b) => b
                          ..farmName = 'Farm 1'
                          ..formDate = '2021-09-01'
                          ..moisture = 0.5
                          ..phosphorus = 0.5
                          ..potassium = 0.5
                          ..nitrogen = 0.5
                      ));
                      print(response.body);
                    },
                    child: const Text('Submit Data', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
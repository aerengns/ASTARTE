import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';

class FarmDetail extends StatefulWidget {
  const FarmDetail({Key? key}) : super(key: key);

  @override
  _FarmDetailState createState() => _FarmDetailState();
}

class _FarmDetailState extends State<FarmDetail> {
  // Define variables for temperature, weather, and current values.
  double airTemperature = 0.0;
  double soilTemperature = 0.0;
  String weatherSituation = '';
  double humidityValue = 0.0;
  double nitrogenValue = 0.0;
  double phosphorusValue = 0.0;
  double potassiumValue = 0.0;

  // Define a list of tasks.
  List<String> tasks = [    'Water the plants',    'Fertilize the soil',    'Check for pests',  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Farm Detail Page'),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              // Display temperature of air and soil.
              Card(
                child: Column(
                  children: [
                      Text('Air Temperature: $airTemperature'),
                  Text('Soil Temperature: $soilTemperature'),
                  ],
              ),
            ),

            // Display weather situation of farm.
            Card(
                child: Column(
                  children: [
                   Text('Weather Situation: $weatherSituation'),
                  ],
                ),
              ),

            // Create links to reports and photos pages.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                  // Navigate to reports page.
                  },
                  child: const Text('Reports'),
                ),
                ElevatedButton(
                  onPressed: () {
                  // Navigate to photos page.
                  },
                  child: const Text('Photos'),
                ),
              ],
            ),

    // Display current values.
            Card(
              child: Column(
                children: [
                Text('Humidity: $humidityValue'),
                Text('Nitrogen: $nitrogenValue'),
                Text('Phosphorus: $phosphorusValue'),
                Text('Potassium: $potassiumValue'),
                ],
              ),
            ),

            // Display brief information about status of farm.
            Card(
              child: Column(
                children: const [
                  Text('Farm Status: Doing well'),
                ],
              ),
            ),

            // Display list of tasks.
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(tasks[index]),
                      leading: Checkbox(
                        value: false,
                        onChanged: (bool? value) {
                          // Mark task as completed.
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
      ),
      drawer: NavBar(context),
    );
  }
}
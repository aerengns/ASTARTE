import 'package:astarte/network_manager/services/farm_data_service.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:provider/provider.dart';

import 'network_manager/models/farm_data.dart';

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
    return FutureBuilder<List<FarmData>>(
      future: Provider.of<FarmDataService>(context, listen: false).getFarmDataDetail().then((response) => response.body!.toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final data = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                  child:ListTile(
                    leading: const Icon(Icons.home),
                    title: Text(data[index].name),
                    onTap: () {
                      Navigator.pushNamed(context, '/farm_detail', arguments: data[index].id);
                    },
                  )
              );
            },
          );
        }
      },
    );
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
                  onPressed: () async {
                  // Navigate to photos page.
                    final response = await Provider.of<FarmDataService>(context, listen: false).getFarmDataDetail();

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
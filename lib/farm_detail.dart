import 'package:astarte/network_manager/services/farm_data_service.dart';
import 'package:astarte/sidebar.dart';
import 'package:astarte/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'network_manager/models/farm_data.dart';

class FarmDetail extends StatefulWidget {
  FarmDetail({Key? key, required this.farmId}) : super(key: key);

  int farmId;

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FarmData>(
      future: Provider.of<FarmDataService>(context, listen: false)
          .getFarm(widget.farmId)
          .then((response) => response.body!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final data = snapshot.data!;
          print(data);
          return Scaffold(
            appBar: AstarteAppBar(title: data.name.toString()),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Create links to reports and photos pages.
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to reports page.
                            Navigator.pushNamed(context, '/humidity_report');
                          },
                          child: const Text('Reports'),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to reports page.
                          },
                          child: const Text('HeatMap'),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Navigate to photos page.
                          },
                          child: const Text('Photos'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Display temperature of air and soil.
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: CustomColors.astarteGrey,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          children: const [
                            Icon(
                              Icons.wb_cloudy_rounded,
                              size: 20,
                              color: CustomColors.astarteRed,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Weather',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: CustomColors.astarteRed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Air Temperature: $airTemperature',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Soil Temperature: $soilTemperature',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Weather Situation: $weatherSituation',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Display current values.
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: CustomColors.astarteGrey,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          children: const [
                            Icon(
                              Icons.account_tree_rounded,
                              size: 20,
                              color: CustomColors.astarteRed,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Soil',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: CustomColors.astarteRed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Humidity: ${data.latest_farm_report?.moisture}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nitrogen: ${data.latest_farm_report?.nitrogen}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Phosphorus: ${data.latest_farm_report?.phosphorus}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Potassium: ${data.latest_farm_report?.potassium}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'PH: ${data.latest_farm_report?.ph}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Display brief information about status of farm.
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: CustomColors.astarteGrey,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          children: const [
                            Icon(
                              Icons.house_rounded,
                              size: 20,
                              color: CustomColors.astarteRed,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Farm Status',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: CustomColors.astarteRed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text('Doing well',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: CustomColors.astarteGreen,
                          ),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

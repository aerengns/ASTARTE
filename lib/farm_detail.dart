import 'dart:convert';

import 'package:astarte/dynamic_heatmap.dart';
import 'package:astarte/network_manager/services/farm_data_service.dart';
import 'package:astarte/sidebar.dart';
import 'package:astarte/theme/colors.dart';
import 'package:astarte/utils/parameters.dart' as parameters;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'calendar.dart';
import 'farm_data_form.dart';
import 'mappings/farm_status_mapping.dart';
import 'mappings/weather_mapping.dart';
import 'network_manager/models/farm_data.dart' as FarmDataModel;

class FarmDetail extends StatefulWidget {
  FarmDetail({Key? key, required this.farmId}) : super(key: key);

  int farmId;

  @override
  _FarmDetailState createState() => _FarmDetailState();
}

class _FarmDetailState extends State<FarmDetail> {
  // Define variables for temperature, weather, and current values.

  late Future<WeatherData>? weatherData;
  double humidityValue = 0.0;
  double nitrogenValue = 0.0;
  double phosphorusValue = 0.0;
  double potassiumValue = 0.0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _deleteItem() async {
    // Perform the deletion logic here
    int responseCode = await deleteFarm(widget.farmId);

    void showSnackBar(String message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    switch (responseCode) {
      case 204:
        showSnackBar('Farm has been deleted.');
        Navigator.pushNamed(context, '/farms');
        break;
      case 404:
        showSnackBar('Farm could not have been found.');
        break;
      case 500:
        showSnackBar('Farm could not have been deleted. Try again later.');
        break;
      default:
        showSnackBar('Unknown error. Farm could not have been deleted.');
        break;
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          onDeleteConfirmed: _deleteItem,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FarmDataModel.FarmData>(
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
          String status =
              getStatus(snapshot.data?.latest_farm_report?.date_collected);
          return Scaffold(
            appBar: AstarteAppBar(title: data.name.toString()),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Create links to reports and photos pages.
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HeatmapPage(farmId: widget.farmId)),
                                );
                              },
                              child: const Text('HeatMap'),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Calendar(farmId: widget.farmId)),
                                );
                              },
                              child: const Text('Calendar'),
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
                        child: FutureBuilder<WeatherData>(
                            future: getWeather(
                                snapshot.data!.farm_corner.latitude,
                                snapshot.data!.farm_corner.longitude),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                WeatherData currentWeatherData = snapshot.data!;
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Wrap(
                                      children: [
                                        Icon(
                                          weatherCodeMapping[currentWeatherData
                                              .weatherCode]!["icon"],
                                          size: 28,
                                          color: CustomColors
                                              .astarteRed, // Customize the icon color as needed
                                        ),
                                        SizedBox(width: 5),
                                        const Text(
                                          'Weather',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: CustomColors.astarteRed,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      '${weatherCodeMapping[currentWeatherData.weatherCode]!["description"]}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Air Temperature: ${currentWeatherData.temperature} °C',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Wind Speed: ${currentWeatherData.windSpeed} km/h',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Relative Humidity: ${currentWeatherData.relativeHumidity} %',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Soil Moisture: ${currentWeatherData.soilMoisture}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return const CircularProgressIndicator();
                            }),
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
                            const Wrap(
                              children: [
                                Icon(
                                  Icons.account_tree_rounded,
                                  size: 28,
                                  color: CustomColors.astarteRed,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Soil',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
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
                            const SizedBox(height: 4),
                            Text(
                              'Collected at: ${data.latest_farm_report?.date_collected?.substring(0, 10)}',
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
                            const Wrap(
                              children: [
                                Icon(
                                  Icons.house_rounded,
                                  size: 28,
                                  color: CustomColors.astarteRed,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Farm Status',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: CustomColors.astarteRed,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              '${farmStatusMapping[status]}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: farmStatusColorMapping[status],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to reports page.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FarmData(farmId: widget.farmId)),
                                );
                              },
                              child: const Text('Add new report data'),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Button action
                          _showDeleteConfirmationDialog(context);
                        },
                        child: const Text('Delete Farm'),
                      ),
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

  String getStatus(String? date_collected) {
    if (date_collected == null) {
      return "no-data";
    }
    DateTime dateTime = DateTime.parse(date_collected);
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(dateTime);

    if (difference.inDays < 3) {
      return "up-to-date";
    } else if (difference.inDays >= 3 && difference.inDays <= 14) {
      return "new-data-soon";
    } else {
      return "immediate-reporting";
    }
  }
}

Future<int> deleteFarm(int farmId) async {
  try {
    var headers = {
      'Authorization': parameters.TOKEN,
    };
    // your endpoint and request method
    var request = http.MultipartRequest(
        'DELETE', Uri.parse('${parameters.GENERAL_URL}api/v1/farms/$farmId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response.statusCode;
  } catch (e) {
    print(e);
  }

  return 500;
}

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onDeleteConfirmed;

  const DeleteConfirmationDialog({super.key, required this.onDeleteConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Confirmation',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: CustomColors.astarteRed),
      ),
      content: const Text('Are you sure you want to delete this farm?'),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: CustomColors.astarteBlack),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Delete',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: CustomColors.astarteRed),
          ),
          onPressed: () {
            onDeleteConfirmed();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class WeatherData {
  double? temperature;
  double? windSpeed;
  int? weatherCode;
  double? soilMoisture;
  int? relativeHumidity;

  WeatherData(
      {this.temperature,
      this.windSpeed,
      this.weatherCode,
      this.soilMoisture,
      this.relativeHumidity});
}

Future<WeatherData> getWeather(double latitude, double longitude) async {
  try {
    var request = http.MultipartRequest(
        'GET',
        Uri.parse(
            '${parameters.WEATHER_API_URL}?latitude=$latitude&longitude=$longitude&current_weather=true&hourly=soil_moisture_1_3cm,relativehumidity_2m'));

    http.StreamedResponse response = await request.send();
    String jsonAsString = await response.stream.bytesToString();
    var data = jsonDecode(jsonAsString);

    return WeatherData(
        temperature: data['current_weather']['temperature'],
        windSpeed: data['current_weather']['windspeed'],
        weatherCode: data['current_weather']['weathercode'],
        soilMoisture: data['hourly']['soil_moisture_1_3cm'][0],
        relativeHumidity: data['hourly']['relativehumidity_2m'][0]);
  } catch (e) {
    print(e);
  }
  return WeatherData();
}

import 'package:astarte/network_manager/services/sensor_data_service.dart';
import 'package:astarte/theme/colors.dart';
import 'package:astarte/utils/parameters.dart';
import 'package:astarte/utils/reports_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class HumidityReport extends StatefulWidget {
  HumidityReport({Key? key}) : super(key: key);
  @override
  State<HumidityReport> createState() => _ReportsState();
}

class _ReportsState extends State<HumidityReport> {
  List<double> data_y = [];
  String data_x = "";
  List<Farm> farms = [];
  String selectedFarm = "";

  @override
  void initState() {
    super.initState();
    fillFarms().whenComplete(() => _addDropdown());
  }

  final List<Widget> _widgets = [
    Image.asset(
      'assets/images/astarte.jpg',
      width: 100,
      height: 100,
      fit: BoxFit.contain,
    ),
    const Text("Select a Farm"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(
        title: 'Reports',
      ),
      body: Column(
        children: _widgets,
      ),
      drawer: NavBar(context),
    );
  }

  void _addDropdown() {
    setState(() {
      _widgets.add(
        Center(
          child: DropdownButton<String>(
            value: selectedFarm,
            icon: const Icon(
              Icons.arrow_drop_down_circle,
              color: CustomColors.astarteRed,
            ),
            onChanged: (value) {
              setState(() {
                selectedFarm = value!;
              });
              getHumidityData(selectedFarm)
                  .whenComplete(() => _addHumidityContainer());
            },
            items: farms.map((farm) {
              return DropdownMenuItem<String>(
                value: farm.id,
                child: Text(farm.name),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  void _addHumidityContainer() {
    setState(() {
      // Remove the old report container if it exists
      _widgets.removeWhere((widget) =>
          widget is SizedBox && widget.width == 450 && widget.height == 300);
      _widgets.add(
        SizedBox(
          width: 450,
          height: 300,
          child: Echarts(
            option: '''
              {
                height: 200,
                width: 300,
                title: {
                  text: 'Past Soil Humidity Percentages',
                  left: 'left',
                  top: 'top'
                },
                xAxis: {
                  type: 'category',
                  data: ${data_x},
                },
                yAxis: {
                  type: 'value',
                },
                tooltip: {
                  trigger: 'axis', // Show tooltip when the user touches data points
                  formatter: '{b}: {c}', // Display the name and value of the data point
                },
                series: [{
                  data:  ${data_y},
                  type: 'line'
                }]
              }
            ''',
          ),
        ),
      );
    });
  }

  Future<void> getHumidityData(String selectedFarm) async {
    final response =
        await Provider.of<SensorDataService>(context, listen: false)
            .getHumidityReport(selectedFarm);

    if (response.isSuccessful) {
      String new_message = await response.bodyString;
      dynamic data = jsonDecode(new_message);

      data_x = jsonEncode(data['days']);
      data_y.clear();
      for (dynamic humidity_level in data['humidity_levels']) {
        data_y.add(humidity_level as double);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Humidity report failed to load. Please try again.'),
        ),
      );
    }
  }

  Future<void> fillFarms() async {
    final response =
        await Provider.of<SensorDataService>(context, listen: false)
            .getFarmList();

    if (response.isSuccessful) {
      String new_message = await response.bodyString;
      dynamic data = jsonDecode(new_message);
      for (dynamic n in data) {
        farms.add(Farm(name: n[0], id: n[1].toString()));
      }
      selectedFarm = farms[0].id;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Temperature report failed to load. Please try again.'),
        ),
      );
    }
  }
}

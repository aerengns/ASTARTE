import 'package:astarte/network_manager/services/sensor_data_service.dart';
import 'package:astarte/utils/parameters.dart';
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

  @override
  void initState() {
    super.initState();
    getHumidityData().whenComplete(() => _addHumidityContainer());
  }

  final List<Widget> _widgets = [
    Image.asset(
      'assets/images/astarte.jpg',
      width: 100,
      height: 100,
      fit: BoxFit.contain,
    ),
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

  void _addHumidityContainer() {
    setState(() {
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

  Future<void> getHumidityData() async {
    final response =
        await Provider.of<SensorDataService>(context, listen: false)
            .getHumidityReport();

    if (response.isSuccessful) {
      String new_message = await response.bodyString;
      dynamic data = jsonDecode(new_message);

      data_x = jsonEncode(data['days']);
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
}

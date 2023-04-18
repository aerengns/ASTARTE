import 'package:astarte/network_manager/services/reports_service.dart';
import 'package:astarte/utils/parameters.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

import 'network_manager/services/sensor_data_service.dart';

class TemperatureReport extends StatefulWidget {
  TemperatureReport({Key? key}) : super(key: key);
  @override
  State<TemperatureReport> createState() => _TemperatureReportsState();
}

class _TemperatureReportsState extends State<TemperatureReport> {
  List<int> data_y = [];
  String data_x = "";

  @override
  void initState() {
    super.initState();
    getTemperatureData().whenComplete(() => _addTemperatureValueContainer());
  }

  List<Widget> _widgets = [
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

  void _addTemperatureValueContainer() {
    setState(() {
      _widgets.add(
        Container(
          child: Echarts(
            option: '''
              {
                height: 200,
                width: 300,
                title: {
                  text: 'Temperature values for 7 Days',
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
                series: [{
                  data:  ${data_y},
                  type: 'line'
                }]
              }
            ''',
          ),
          width: 450,
          height: 300,
        ),
      );
    });
  }

  Future<void> getTemperatureData() async {
    final response = await Provider.of<SensorDataService>(
        context, listen: false).getTemperatureReport();

    if (response.isSuccessful) {
      data_x = response.body!.days.toString();
      response.body?.temperatures.forEach((element) {
        data_y.add(element);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Temperature report failed to load. Please try again.'),
        ),
      );
    }
  }
}

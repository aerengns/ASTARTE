import 'package:astarte/network_manager/services/sensor_data_service.dart';
import 'package:astarte/utils/parameters.dart';
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
  List<int> data_y = [];
  String data_x = "";

  @override
  void initState() {
    super.initState();
    getHumidityData().whenComplete(() => _addHumidityContainer());
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

  void _addHumidityContainer() {
    setState(() {
      _widgets.add(
        Container(
          child: Echarts(
            option: '''
              {
                height: 200,
                width: 300,
                title: {
                  text: 'Soil Humidity Percentage for 7 Days',
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

  Future<void> getHumidityData() async {
    final response = await Provider.of<SensorDataService>(
        context, listen: false).getHumidityReport();

    if (response.isSuccessful) {
      data_x = response.body!.days.toString();
      response.body?.humidity_levels.forEach((element) {
        data_y.add(element);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Humidity report failed to load. Please try again.'),
        ),
      );
    }
  }
}

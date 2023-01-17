import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    // your token if needed
    try {
      var headers = {
        'Authorization': 'Bearer ' + "token",
      };
      // your endpoint and request method
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://127.0.0.1:8000/app/temperature_report'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String new_message = await response.stream.bytesToString();
        dynamic data = jsonDecode(new_message);

        data_x = jsonEncode(data['days']);
        for (dynamic n in data['temperatures']) {
          data_y.add(n as int);
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }
}

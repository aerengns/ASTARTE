import 'package:astarte/utils/parameters.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    // your token if needed
    final user = await FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    try {
      var headers = {
        'AUTHORIZATION': 'Bearer ' + idToken.toString(),
      };
      // your endpoint and request method
      var request = http.MultipartRequest(
          'POST', Uri.parse('${GENERAL_URL}app/humidity_report'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String new_message = await response.stream.bytesToString();
        dynamic data = jsonDecode(new_message);

        data_x = jsonEncode(data['days']);
        for (dynamic humidity_level in data['humidity_levels']) {
          data_y.add(humidity_level as double);
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }
}

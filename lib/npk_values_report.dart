import 'package:astarte/network_manager/services/sensor_data_service.dart';
import 'package:astarte/utils/parameters.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class NPKReport extends StatefulWidget {
  NPKReport({Key? key}) : super(key: key);
  @override
  State<NPKReport> createState() => _NPKReportsState();
}

class _NPKReportsState extends State<NPKReport> {
  List<int> data_n = [];
  List<int> data_p = [];
  List<int> data_k = [];
  String data_x = "";

  @override
  void initState() {
    super.initState();
    getNData().whenComplete(() => _addNValueContainer());
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

  void _addNValueContainer() {
    setState(() {
      _widgets.add(
        Container(
          child: Echarts(
            option: '''
              {
                height: 200,
                width: 300,
                title: {
                  text: 'N values for 7 Days',
                },
                xAxis: {
                  type: 'category',
                  data: ${data_x},
                },
                yAxis: [{
                  name: 'n',
                  type: 'value',
                },
                {
                  name: 'p',
                  type: 'value',
                },
                {
                  name: 'k',
                  type: 'value',
                }],
                legend: {
                  show: true,
                  padding: 30,
                },
                series: [						
                  {
                    name: 'n',
                    type:'line',
                    itemStyle: {
                      normal: {
                        color: 'rgb(125, 10, 10)'
                      }
                    },
                    data: ${data_n},
                  },	
                  {
                    name: 'p',
                    type:'line',
                    itemStyle: {
                      normal: {
                        color: 'rgb(125, 125, 10)'
                      }
                    },
                    data: ${data_p},
                  },
                  {
                    name: 'k',
                    type:'line',
                    itemStyle: {
                      normal: {
                        color: 'rgb(125, 125, 125)'
                      }
                    },
                    data: ${data_k},
                  },	
                ],
              }
            ''',
          ),
        ),
      );
    });
  }

  Future<void> getNData() async {
    final response = await Provider.of<SensorDataService>(
        context, listen: false).getNpkReport();

    if (response.isSuccessful) {
      data_x = response.body!.days.toString();
      response.body?.n_values.forEach((element) {
        data_n.add(element);
      });
      response.body?.p_values.forEach((element) {
        data_p.add(element);
      });
      response.body?.k_values.forEach((element) {
        data_k.add(element);
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

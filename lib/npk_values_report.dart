import 'package:astarte/network_manager/services/sensor_data_service.dart';
import 'package:astarte/theme/colors.dart';
import 'package:astarte/utils/parameters.dart';
import 'package:built_value/built_value.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:astarte/utils/reports_util.dart';

import 'package:provider/provider.dart';

class NPKReport extends StatefulWidget {
  NPKReport({Key? key}) : super(key: key);
  @override
  State<NPKReport> createState() => _NPKReportsState();
}

class _NPKReportsState extends State<NPKReport> {
  List<double> data_n = [];
  List<double> data_p = [];
  List<double> data_k = [];
  String data_x = "";
  List<Farm> farms = [];
  Farm selectedFarm = Farm(name: "Select a Farm", id: "0");

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
          child: DropdownButton<Farm>(
            value: selectedFarm,
            icon: const Icon(
              Icons.arrow_drop_down_circle,
              color: CustomColors.astarteRed,
            ),
            onChanged: (value) {
              setState(() {
                selectedFarm = value!;
                getNData(selectedFarm.id)
                    .whenComplete(() => _addNValueContainer());
              });
              print(selectedFarm.name);
            },
            items: farms.map((farm) {
              return DropdownMenuItem<Farm>(
                value: farm,
                child: Text(farm.name),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  void _addNValueContainer() {
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
                  text: 'Past NPK Values',
                },
                xAxis: {
                  type: 'category',
                  data: $data_x,
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
                tooltip: {
                  trigger: 'axis',
                  formatter: function(params) {
                    var tooltip = '';
                    for (var i = 0; i < params.length; i++) {
                      var param = params[i];
                      tooltip += param.seriesName + ': ' + param.value + '<br>';
                    }
                    return tooltip;
                  }
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
                    data: $data_n,
                  },	
                  {
                    name: 'p',
                    type:'line',
                    itemStyle: {
                      normal: {
                        color: 'rgb(125, 125, 10)'
                      }
                    },
                    data: $data_p,
                  },
                  {
                    name: 'k',
                    type:'line',
                    itemStyle: {
                      normal: {
                        color: 'rgb(125, 125, 125)'
                      }
                    },
                    data: $data_k,
                  },	
                ],
              }
            ''',
          ),
        ),
      );
    });
  }

  Future<void> getNData(String selectedFarm) async {
    final response =
        await Provider.of<SensorDataService>(context, listen: false)
            .getNpkReport(selectedFarm);

    if (response.isSuccessful) {
      String new_message = await response.bodyString;
      dynamic data = jsonDecode(new_message);
      data_n.clear();
      data_p.clear();
      data_k.clear();
      data_x = jsonEncode(data['days']);
      for (dynamic n in data['n_values']) {
        data_n.add(n as double);
      }
      for (dynamic n in data['p_values']) {
        data_p.add(n as double);
      }
      for (dynamic n in data['k_values']) {
        data_k.add(n as double);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Temperature report failed to load. Please try again.'),
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
      selectedFarm = farms[0];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Temperature report failed to load. Please try again.'),
        ),
      );
    }
  }
}

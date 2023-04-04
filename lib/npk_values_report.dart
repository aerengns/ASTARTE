import 'package:astarte/utils/parameters.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
          width: 450,
          height: 300,
        ),
      );
    });
  }

  Future<void> getNData() async {
    // your token if needed
    try {
      var headers = {
        'Authorization': 'Bearer ' + "token",
      };
      // your endpoint and request method
      var request = http.MultipartRequest(
          'POST', Uri.parse('${GENERAL_URL}app/npk_report'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String new_message = await response.stream.bytesToString();
        dynamic data = jsonDecode(new_message);

        data_x = jsonEncode(data['days']);
        for (dynamic n in data['n_values']) {
          data_n.add(n as int);
        }
        for (dynamic n in data['p_values']) {
          data_p.add(n as int);
        }
        for (dynamic n in data['k_values']) {
          data_k.add(n as int);
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }
}

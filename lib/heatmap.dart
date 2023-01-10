import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

import 'package:astarte/sidebar.dart';

class Heatmap extends StatefulWidget {
  const Heatmap({Key? key}) : super(key: key);

  @override
  State<Heatmap> createState() => _HeatmapState();
}

class _HeatmapState extends State<Heatmap> {
  final data = '''
  [
    [0,0,5], [0,1,1], [0,2,0], [0,3,0], [0,4,0],
    [1,0,7], [1,1,0], [1,2,0], [1,3,0], [1,4,0],
    [2,0,1], [2,1,1], [2,2,0], [2,3,0], [2,4,0],
    [3,0,7], [3,1,3], [3,2,0], [3,3,0], [3,4,0],
  ]
  ''';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Heatmap'),
      body: Center(
        child: Echarts(
          option: '''
          {
          tooltip: {
            position: 'top'
          },
          grid: {
            height: '50%',
            top: '10%'
          },
          xAxis: {
            type: 'category',
            data: [
                '0-10m', '0-20m'
            ],
            splitArea: {
              show: true
            }
          },
          yAxis: {
            type: 'category',
            data: [
                '0-10m', '0-20m'
            ],
            splitArea: {
              show: true
            }
          },
          visualMap: {
            min: 0,
            max: 250,
            calculable: true,
            orient: 'horizontal',
            left: 'center',
            bottom: '15%'
          },
          series: [
            {
              name: 'Punch Card',
              type: 'heatmap',
              data: [
                [0,0,30], [0,1,45] , [1,0,200] , [1,1,250]
              ],
              label: {
                show: true
              },
              emphasis: {
                itemStyle: {
                  shadowBlur: 10,
                  shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
              }
            }
          ]
        }
          '''
        ),
      ),
      drawer: NavBar(context),
    );
  }

}
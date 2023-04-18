import 'dart:math';

import 'package:fl_heatmap/fl_heatmap.dart';
import 'package:flutter/material.dart';

class HeatmapPage extends StatefulWidget {
  const HeatmapPage({Key? key}) : super(key: key);

  @override
  State<HeatmapPage> createState() => _ExampleState();
}

class _ExampleState extends State<HeatmapPage> {
  HeatmapItem? selectedItem;

  late HeatmapData heatmapDataPower;

  @override
  void initState() {
    _initExampleData();
    super.initState();
  }

  void _initExampleData() {
    const rows = [
      '2022',
      '2021',
      '2020',
      '2019',
    ];
    const columns = [
      'Jan',
      'Feb',
      'Mär',
      'Apr',
      'Mai',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Okt',
      'Nov',
      'Dez',
    ];
    final r = Random();
    const String unit = 'kWh';
    final items = [
      for (int row = 0; row < rows.length; row++)
        for (int col = 0; col < columns.length; col++)
          if (!(row == 3 &&
              col <
                  2)) // Do not add the very first item (incomplete data edge case)
            HeatmapItem(
                value: r.nextDouble() * 6,
                style: row == 0 && col > 1
                    ? HeatmapItemStyle.hatched
                    : HeatmapItemStyle.filled,
                unit: unit,
                xAxisLabel: columns[col],
                yAxisLabel: rows[row]),
    ];
    heatmapDataPower = HeatmapData(
      rows: rows,
      columns: columns,
      radius: 6.0,
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = selectedItem != null
        ? '${selectedItem!.value.toStringAsFixed(2)} ${selectedItem!.unit}'
        : '--- ${heatmapDataPower.items.first.unit}';
    final subtitle = selectedItem != null
        ? '${selectedItem!.xAxisLabel} ${selectedItem!.yAxisLabel}'
        : '---';
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Heatmap plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(title, textScaleFactor: 1.4),
              Text(subtitle),
              const SizedBox(height: 8),
              Heatmap(
                  onItemSelectedListener: (HeatmapItem? selectedItem) {
                    debugPrint(
                        'Item ${selectedItem?.yAxisLabel}/${selectedItem?.xAxisLabel} with value ${selectedItem?.value} selected');
                    setState(() {
                      this.selectedItem = selectedItem;
                    });
                  },
                  heatmapData: heatmapDataPower)
            ],
          ),
        ),
      ),
    );
  }
}

// class _ExampleState extends State<HeatmapPage> {
//   HeatmapItem? selectedItem;

//   late HeatmapData heatmapData;

//   @override
//   void initState() {
//     _initExampleData();
//     super.initState();
//   }

//   void _initExampleData() {
//     const rows = ['2022', '2021', '2020', '2019', '2018'];
//     const columns = [
//       'Jan',
//       'Feb',
//       'Mär',
//       'Apr',
//       'Mai',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Okt',
//       'Nov',
//       'Dez',
//     ];
//     final r = Random();
//     const String unit = 'kWh';
//     heatmapData = HeatmapData(rows: rows, columns: columns, items: [
//       for (int row = 0; row < rows.length; row++)
//         for (int col = 0; col < columns.length; col++)
//           HeatmapItem(
//               value: r.nextDouble() * 6,
//               unit: unit,
//               xAxisLabel: columns[col],
//               yAxisLabel: rows[row]),
//     ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final title = selectedItem != null
//         ? '${selectedItem!.value.toStringAsFixed(2)} ${selectedItem!.unit}'
//         : '--- ${heatmapData.items.first.unit}';
//     final subtitle = selectedItem != null
//         ? '${selectedItem!.xAxisLabel} ${selectedItem!.yAxisLabel}'
//         : '---';
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Heatmap plugin example app'),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 16),
//               Text(title, textScaleFactor: 1.4),
//               Text(subtitle),
//               const SizedBox(height: 8),
//               Heatmap(
//                   onItemSelectedListener: (HeatmapItem? selectedItem) {
//                     debugPrint(
//                         'Item ${selectedItem?.yAxisLabel}/${selectedItem?.xAxisLabel} with value ${selectedItem?.value} selected');
//                     setState(() {
//                       this.selectedItem = selectedItem;
//                     });
//                   },
//                   heatmapData: heatmapData)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CustomHeatmapItem extends HeatmapItem {
//   CustomHeatmapItem(
//       {required this.costs,
//       required double value,
//       required String unit,
//       required String xAxisLabel,
//       required String yAxisLabel})
//       : super(
//             value: value,
//             unit: unit,
//             xAxisLabel: xAxisLabel,
//             yAxisLabel: yAxisLabel);

//   final double costs;
// }

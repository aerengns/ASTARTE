import 'dart:math';

import 'package:fl_heatmap/fl_heatmap.dart';
import 'package:flutter/material.dart';
import 'package:astarte/utils/dynamic_heatmap_utils.dart';

import 'package:astarte/sidebar.dart';

class HeatmapPage extends StatefulWidget {
  const HeatmapPage({Key? key}) : super(key: key);

  @override
  State<HeatmapPage> createState() => _DynamicHeatmapState();
}

class _DynamicHeatmapState extends State<HeatmapPage> {
  HeatmapItem? selectedItem;

  @override
  void initState() {
    _initExampleData();
    super.initState();
  }

  Widget _initExampleData() {
    HeatmapData heatmapDataPower;
    return FutureBuilder<DynamicHeatmap>(
      future: getHeatmapData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DynamicHeatmap? hmap = snapshot.data;
          List<String> rows = hmap!.rows;
          List<String> columns = hmap.columns;

          const String unit = 'moisture';
          final items = [
            for (int row = 0; row < rows.length; row++)
              for (int col = 0; col < columns.length; col++)
                if (!(row == 3 &&
                    col <
                        2)) // Do not add the very first item (incomplete data edge case)
                  HeatmapItem(
                      value: hmap.items[row],
                      style: row == 3 && col == 2 ||
                              row == 1 && col == 3 ||
                              row == 2 && col == 6 ||
                              row == 1 && col == 9
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
        } else {
          heatmapDataPower = const HeatmapData(
            rows: ['deneme'],
            columns: ['deneme'],
            radius: 6.0,
            items: [
              HeatmapItem(
                  value: -1,
                  style: HeatmapItemStyle.filled,
                  unit: 'deneme',
                  xAxisLabel: 'deneme',
                  yAxisLabel: 'deneme')
            ],
          );
        }
        return Heatmap(
            onItemSelectedListener: (HeatmapItem? selectedItem) {
              debugPrint(
                  'Item ${selectedItem?.yAxisLabel}/${selectedItem?.xAxisLabel} with value ${selectedItem?.value} selected');
              setState(() {
                this.selectedItem = selectedItem;
              });
            },
            heatmapData: heatmapDataPower);
        ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = selectedItem != null
        ? '${selectedItem!.value.toStringAsFixed(2)} ${selectedItem!.unit}'
        : '--- deneme';
    final subtitle = selectedItem != null
        ? '${selectedItem!.xAxisLabel} ${selectedItem!.yAxisLabel}'
        : '---';
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Dynamic Heatmap'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(title, textScaleFactor: 1.4),
            Text(subtitle),
            const SizedBox(height: 8),
            _initExampleData()
          ],
        ),
      ),
      drawer: NavBar(context),
    );
  }
}

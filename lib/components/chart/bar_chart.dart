import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:financial_data_analyst/components/chart/base.dart';

class BarChartWidget extends BaseChartWidget {
  const BarChartWidget({super.key, required super.data});
  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends BaseChartState<BarChartWidget> {
  @override
  Widget buildChart(BuildContext context) {
    final String dataKey = widget.data.chartConfig.keys.first;

    final List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < widget.data.data.length; i++) {
      final item = widget.data.data[i];
      final yValue =
          (item[dataKey] is num) ? (item[dataKey] as num).toDouble() : 0.0;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: yValue,
              color: getColor(widget.data.chartConfig[dataKey]?.color),
              width: 16,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        maxY: _calculateMaxY(widget.data.data, dataKey),
        barGroups: barGroups,
        titlesData: titlesData,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _calculateInterval(widget.data.data, dataKey),
          getDrawingHorizontalLine:
              (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  double _calculateMaxY(List<Map<String, dynamic>> data, String key) {
    double maxY = 0.0;
    for (final item in data) {
      final value = item[key];
      if (value is num) {
        if (value.toDouble() > maxY) maxY = value.toDouble();
      }
    }
    return maxY * 1.2;
  }

  double _calculateInterval(List<Map<String, dynamic>> data, String key) {
    final maxY = _calculateMaxY(data, key);
    return maxY / 5;
  }
}

import 'package:financial_data_analyst/components/chart/base.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MultiBarChartWidget extends BaseChartWidget {
  const MultiBarChartWidget({super.key, required super.data});
  @override
  State<StatefulWidget> createState() => MultiBarChartWidgetState();
}

class MultiBarChartWidgetState extends BaseChartState<MultiBarChartWidget> {
  @override
  Widget buildChart(BuildContext context) {
    final List<String> seriesKeys = widget.data.chartConfig.keys.toList();

    final List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < widget.data.data.length; i++) {
      final item = widget.data.data[i];
      List<BarChartRodData> rods = [];
      for (int j = 0; j < seriesKeys.length; j++) {
        final key = seriesKeys[j];
        final value = item[key];
        double yValue = 0.0;
        if (value is num) {
          yValue = value.toDouble();
        }
        rods.add(
          BarChartRodData(
            toY: yValue,
            color: getColor(widget.data.chartConfig[key]?.color),
            width: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }
      barGroups.add(BarChartGroupData(x: i, barRods: rods, barsSpace: 4));
    }

    double maxY = 0;
    for (final item in widget.data.data) {
      for (final key in seriesKeys) {
        final value = item[key];
        if (value is num && value.toDouble() > maxY) {
          maxY = value.toDouble();
        }
      }
    }
    maxY = maxY * 1.2;

    return BarChart(
      BarChartData(
        maxY: maxY,
        barGroups: barGroups,
        titlesData: titlesData,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine:
              (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final seriesKey = seriesKeys[rodIndex];
              final xValue =
                  widget.data.data[group.x.toInt()][widget
                      .data
                      .config
                      .xAxisKey];
              return BarTooltipItem(
                '$xValue\n$seriesKey: ${rod.toY.toStringAsFixed(2)}',
                const TextStyle(color: Colors.black),
              );
            },
          ),
        ),
      ),
    );
  }
}

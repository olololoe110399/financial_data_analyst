import 'package:financial_data_analyst/components/chart/base.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends BaseChartWidget {
  const LineChartWidget({super.key, required super.data});
  @override
  State<StatefulWidget> createState() => LineChartWidgetState();
}

class LineChartWidgetState extends BaseChartState<LineChartWidget> {
  @override
  Widget buildChart(BuildContext context) {
    final keys = widget.data.chartConfig.keys.toList();
    final lineBars = <LineChartBarData>[];
    for (final key in keys) {
      final spots = <FlSpot>[];
      for (int i = 0; i < widget.data.data.length; i++) {
        final value = (widget.data.data[i][key] as num).toDouble();
        spots.add(FlSpot(i.toDouble(), value));
      }
      lineBars.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: getColor(widget.data.chartConfig[key]?.color),
          dotData: FlDotData(show: true),
          barWidth: 2,
        ),
      );
    }

    return LineChart(
      LineChartData(
        lineBarsData: lineBars,
        titlesData: titlesData,
        gridData: FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final seriesLabel = keys[spot.barIndex];
                return LineTooltipItem(
                  '$seriesLabel: ${spot.y.toStringAsFixed(2)}',
                  const TextStyle(color: Colors.black),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

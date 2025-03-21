import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:financial_data_analyst/components/chart/base.dart';

class AreaChartWidget extends BaseChartWidget {
  final bool stacked;

  const AreaChartWidget({super.key, required super.data, this.stacked = false});
  @override
  State<StatefulWidget> createState() => AreaChartWidgetState();
}

class AreaChartWidgetState extends BaseChartState<AreaChartWidget> {
  @override
  Widget buildChart(BuildContext context) {
    final keys = widget.data.chartConfig.keys.toList();
    final lines = <LineChartBarData>[];

    for (int seriesIndex = 0; seriesIndex < keys.length; seriesIndex++) {
      final key = keys[seriesIndex];
      final spots = <FlSpot>[];
      for (int i = 0; i < widget.data.data.length; i++) {
        double value = 0;
        if (widget.stacked) {
          for (int j = 0; j <= seriesIndex; j++) {
            final currentKey = keys[j];
            value += (widget.data.data[i][currentKey] as num).toDouble();
          }
        } else {
          value = (widget.data.data[i][key] as num).toDouble();
        }
        spots.add(FlSpot(i.toDouble(), value));
      }
      lines.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: getColor(widget.data.chartConfig[key]?.color),
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: getColor(
              widget.data.chartConfig[key]?.color,
            ).withValues(alpha: 0.4),
          ),
          barWidth: 2,
        ),
      );
    }

    return LineChart(
      LineChartData(
        lineBarsData: lines,
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

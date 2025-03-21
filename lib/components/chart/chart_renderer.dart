import 'package:flutter/material.dart';

import 'package:financial_data_analyst/components/chart/area_chart.dart';
import 'package:financial_data_analyst/components/chart/bar_chart.dart';
import 'package:financial_data_analyst/components/chart/line_chart.dart';
import 'package:financial_data_analyst/components/chart/multi_bar_chart.dart';
import 'package:financial_data_analyst/components/chart/pie_chart.dart';
import 'package:financial_data_analyst/types/chart_data.dart';

class ChartRenderer extends StatelessWidget {
  final ChartData? data;
  const ChartRenderer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final chartData = data;

    if (chartData == null) return const SizedBox();
    switch (chartData.chartType) {
      case "bar":
        return BarChartWidget(data: chartData);
      case "multiBar":
        return MultiBarChartWidget(data: chartData);
      case "line":
        return LineChartWidget(data: chartData);
      case "pie":
        return PieChartWidget(data: chartData);
      case "area":
        return AreaChartWidget(data: chartData);
      case "stackedArea":
        return AreaChartWidget(data: chartData, stacked: true);
      default:
        return const SizedBox();
    }
  }
}

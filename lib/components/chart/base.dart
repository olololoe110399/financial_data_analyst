import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:financial_data_analyst/components/chart/footer.dart';
import 'package:financial_data_analyst/components/chart/header.dart';
import 'package:financial_data_analyst/types/chart_data.dart';
import 'package:financial_data_analyst/utils/color.dart';

abstract class BaseChartWidget extends StatefulWidget {
  final ChartData data;
  const BaseChartWidget({super.key, required this.data});
}

abstract class BaseChartState<T extends BaseChartWidget> extends State<T> {
  String formatXAxisLabel(String value) {
    return value.length > 20 ? '${value.substring(0, 17)}...' : value;
  }

  Color getColor(String? color) {
    if (color == null) {
      return Colors.blue;
    }
    return HexColor.fromHex(color);
  }

  Widget getTitlesWidget(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= widget.data.data.length) {
      return const SizedBox();
    }
    final label = formatXAxisLabel(
      widget.data.data[index][widget.data.config.xAxisKey]?.toString() ?? '',
    );
    return SideTitleWidget(
      meta: meta,
      angle: 0.5,
      child: Text(label, style: const TextStyle(fontSize: 10)),
    );
  }

  FlTitlesData get titlesData {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          getTitlesWidget: getTitlesWidget,
          interval: 1,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true, reservedSize: 50),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderChart(
            title: widget.data.config.title,
            description: widget.data.config.description,
          ),
          Container(
            padding: EdgeInsets.all(50),
            height: 300,
            child: buildChart(context),
          ),
          FooterChart(
            trend: widget.data.config.trend,
            footer: widget.data.config.footer,
          ),
        ],
      ),
    );
  }

  Widget buildChart(BuildContext context);
}

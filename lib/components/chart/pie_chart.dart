import 'package:financial_data_analyst/components/chart/base.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';

class PieChartWidget extends BaseChartWidget {
  const PieChartWidget({super.key, required super.data});
  @override
  State<StatefulWidget> createState() => PieChartWidgetState();
}

class PieChartWidgetState extends BaseChartState<PieChartWidget> {
  final touchedIndex = Signal(-1);

  double get totalValue => widget.data.data.fold<double>(
    0,
    (prev, element) => prev + (element['value'] as num).toDouble(),
  );
  late final computedSections = Computed(() {
    final chartConfig = widget.data.chartConfig;
    final newSections = widget.data.data.indexed.map((v) {
      final (index, item) = v;
      final isTouched = index == touchedIndex.value;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 90.0 : 80.0;
      final value = (item['value'] as num).toDouble();
      final percentage = totalValue == 0 ? 0 : (value / totalValue * 100);
      final defaultColor = Colors.primaries[index % Colors.primaries.length];
      final color =
          chartConfig.containsKey(index.toString())
              ? chartConfig[index.toString()]?.color != null
                  ? getColor(chartConfig[index.toString()]!.color!)
                  : defaultColor
              : defaultColor;
      return PieChartSectionData(
        value: value,
        title: '${percentage.toStringAsFixed(1)}%',
        color: color,
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, color: Colors.white),
      );
    });
    return newSections.toList();
  });

  @override
  void dispose() {
    computedSections.dispose();
    super.dispose();
  }

  @override
  Widget buildChart(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SignalBuilder(
          signal: computedSections,
          builder: (context, sections, _) {
            return PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 50,
                borderData: FlBorderData(show: false),
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex.value = -1;
                      return;
                    }
                    touchedIndex.value =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  },
                ),
              ),
            );
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              totalValue.toStringAsFixed(0),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (widget.data.config.totalLabel != null)
              Text(
                widget.data.config.totalLabel!,
                style: TextStyle(color: Colors.grey[600]),
              ),
          ],
        ),
      ],
    );
  }
}

class ChartConfigData {
  final String title;
  final String description;
  final String xAxisKey;
  final Trend? trend;
  final String? footer;
  final String? totalLabel;

  ChartConfigData({
    required this.title,
    required this.description,
    required this.xAxisKey,
    this.trend,
    this.footer,
    this.totalLabel,
  });

  factory ChartConfigData.fromJson(Map<String, dynamic>? json) {
    final trend = json?['trend'] as Map<String, dynamic>?;
    return ChartConfigData(
      title: json?['title'],
      description: json?['description'],
      xAxisKey: json?['xAxisKey'],
      trend: Trend.fromJson(trend),
      footer: json?['footer'],
      totalLabel: json?['totalLabel'],
    );
  }
}

class Trend {
  final String direction;
  final double percentage;

  Trend({required this.direction, required this.percentage});

  factory Trend.fromJson(Map<String, dynamic>? json) {
    return Trend(
      direction: json?['direction'],
      percentage: json?['percentage'],
    );
  }
}

class ChartConfigItem {
  final String label;
  final String? color;
  final bool? stacked;

  ChartConfigItem({required this.label, this.color, this.stacked});

  factory ChartConfigItem.fromJson(Map<String, dynamic>? json) {
    return ChartConfigItem(
      label: json?['direction'] ?? '',
      color: json?['direction'],
      stacked: json?['direction'],
    );
  }
}

class ChartData {
  final String chartType;
  final ChartConfigData config;
  final Map<String, ChartConfigItem> chartConfig;
  final List<Map<String, dynamic>> data;

  ChartData({
    required this.chartType,
    required this.config,
    required this.chartConfig,
    required this.data,
  });

  factory ChartData.fromJson(Map<String, dynamic>? json) {
    final chartConfig = json?["chartConfig"] as Map<String, dynamic>?;
    final config = json?["config"] as Map<String, dynamic>?;
    return ChartData(
      chartType: json?['chartType'],
      config: ChartConfigData.fromJson(config),
      chartConfig:
          chartConfig?.map(
            (key, value) => MapEntry(key, ChartConfigItem.fromJson(value)),
          ) ??
          Map<String, ChartConfigItem>.from({}),
      data: json?['data'],
    );
  }
}

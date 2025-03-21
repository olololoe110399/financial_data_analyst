import 'package:financial_data_analyst/types/chart_data.dart';
import 'package:financial_data_analyst/types/file_upload.dart';

class MyMessage {
  final String id;
  final String role;
  final String content;
  final bool hasToolUse;
  final FileUpload? file;
  final ChartData? chartData;

  MyMessage({
    required this.id,
    required this.role,
    required this.content,
    this.hasToolUse = false,
    this.file,
    this.chartData,
  });

  factory MyMessage.fromJson(String id, Map<String, dynamic> json) {
    final chartData = ChartData.fromJson(
      json["chartData"] as Map<String, dynamic>?,
    );
    return MyMessage(
      id: id,
      role: "assistant",
      content: json["content"] as String,
      hasToolUse: json["hasToolUse"] == true,
      chartData: chartData,
    );
  }

  bool get isChartNotNull => chartData != null;
}

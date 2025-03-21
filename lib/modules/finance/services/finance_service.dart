import 'dart:async';

import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';
import 'package:financial_data_analyst/configs/constants.dart';
import 'package:financial_data_analyst/modules/finance/services/graph_data_tool.dart';
import 'package:financial_data_analyst/utils/color.dart';
import 'package:flutter/material.dart';

class FinanceService {
  final AnthropicClient client;

  FinanceService({required this.client});

  Future<Map<String, dynamic>> sendRequest({
    required List<Message> messages,
    required Models model,
  }) async {
    try {
      debugPrint("🔍 Dữ liệu yêu cầu ban đầu:");
      debugPrint(" - Số lượng tin nhắn: ${messages.length}");
      debugPrint(" - Model: $model");

      List<Message> anthropicMessages = List.from(messages);

      debugPrint("🚀 Yêu cầu gửi tới Anthropic API:");
      debugPrint(
        {
          "model": model,
          "max_tokens": 4096,
          "temperature": 0.7,
          "messageCount": anthropicMessages.length,
          "tools": [generateGraphDataTool.name],
        }.toString(),
      );

      final request = CreateMessageRequest(
        model: Model.model(model),
        maxTokens: 4096,
        temperature: 0.7,
        tools: [generateGraphDataTool],
        toolChoice: ToolChoice(type: ToolChoiceType.auto),
        messages: [
          ...anthropicMessages,
          Message(
            role: MessageRole.user,
            content: MessageContent.text(systemPrompt),
          ),
        ],
      );

      final response = await client.createMessage(request: request);

      debugPrint("✅ Phản hồi từ Anthropic API:");
      debugPrint("Stop Reason: ${response.stopReason}");

      final toolUseContent = response.content.blocks.firstWhere(
        (c) => c.type == "tool_use",
        orElse: () => Block.toolUse(id: "", name: "", input: {}),
      );
      final textContent = response.content.blocks.firstWhere(
        (c) => c.type == "text",
        orElse: () => Block.text(text: ""),
      );

      Map<String, dynamic>? processedChartData;
      if (toolUseContent.toolUse?.id != '') {
        processedChartData = processToolResponse(toolUseContent.toolUse!.input);
      }

      return {
        "content": textContent.text != '' ? textContent.text : "",
        "hasToolUse": response.content.blocks.any((c) => c.type == "tool_use"),
        "toolUse": toolUseContent,
        "chartData": processedChartData,
      };
    } catch (error, stackTrace) {
      debugPrint("❌ Finance API Error: $error");
      debugPrint(stackTrace.toString());
      rethrow;
    }
  }

  Map<String, dynamic> processToolResponse(Map<String, dynamic> toolInput) {
    if (!toolInput.containsKey("chartType") ||
        !toolInput.containsKey("data") ||
        toolInput["data"] is! List) {
      throw Exception("Invalid chart data structure");
    }

    final chartData = Map<String, dynamic>.from(toolInput);

    if (chartData["chartType"] == "pie") {
      List<dynamic> dataList = chartData["data"];
      dataList =
          dataList.map((item) {
            final Map<String, dynamic> itemMap = Map<String, dynamic>.from(
              item,
            );
            final chartConfig =
                chartData["chartConfig"] as Map<String, dynamic>;
            final valueKey = chartConfig.keys.first;
            final segmentKey = chartData["config"]["xAxisKey"] ?? "segment";
            return {
              "segment":
                  itemMap[segmentKey] ??
                  itemMap["segment"] ??
                  itemMap["category"] ??
                  itemMap["name"],
              "value": itemMap[valueKey] ?? itemMap["value"],
            };
          }).toList();
      chartData["data"] = dataList;
      chartData["config"]["xAxisKey"] = "segment";
    }

    final chartConfig = chartData["chartConfig"] as Map<String, dynamic>;
    final Map<String, dynamic> processedChartConfig = {};
    int index = 0;
    chartConfig.forEach((key, config) {
      processedChartConfig[key] = {
        ...Map<String, dynamic>.from(config),
        "color": Colors.primaries[index % Colors.primaries.length].toHex(),
      };
      index++;
    });
    chartData["chartConfig"] = processedChartConfig;

    return chartData;
  }
}

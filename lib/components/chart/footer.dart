import 'package:financial_data_analyst/types/chart_data.dart';
import 'package:flutter/material.dart';

class FooterChart extends StatelessWidget {
  const FooterChart({super.key, this.trend, this.footer});

  final Trend? trend;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (trend != null)
            Row(
              children: [
                Text(
                  'Trending ${trend!.direction} by ${trend!.percentage}%',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                Icon(
                  trend!.direction == "up"
                      ? Icons.trending_up
                      : Icons.trending_down,
                  size: 20,
                  color: trend!.direction == "up" ? Colors.green : Colors.red,
                ),
              ],
            ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                footer!,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

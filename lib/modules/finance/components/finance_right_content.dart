import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:financial_data_analyst/components/chart/chart_renderer.dart';
import 'package:financial_data_analyst/modules/finance/composables/chat_composable.dart';
import 'package:financial_data_analyst/types/chart_data.dart';
import 'package:financial_data_analyst/utils/context.dart';

class FinanceRightContent extends StatelessWidget {
  const FinanceRightContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final chatComposable = context.get<ChatComposable>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SignalBuilder(
        signal: chatComposable.hasChartDataComputed,
        builder: (context, hasChartData, _) {
          final isShowHeader = hasChartData && !context.isMobile;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isShowHeader)
                Text(
                  'Analysis & Visualizations',
                  style: theme.textTheme.h4,
                  textAlign: TextAlign.start,
                ),
              hasChartData ? ChartPagination() : FinanceRightContentTutorial(),
            ],
          );
        },
      ),
    );
  }
}

class FinanceRightContentTutorial extends StatelessWidget {
  const FinanceRightContentTutorial({super.key});

  List<Widget> _buildChartBadges() {
    return [
      'Bar Charts',
      'Area Charts',
      'Linear Charts',
      'Linear Charts',
    ].map((label) => ShadBadge.outline(child: Text(label))).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Expanded(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Analysis & Visualizations', style: theme.textTheme.h4),
            const SizedBox(height: 8),
            Text(
              'Charts and detailed analysis will appear here as you chat',
              style: theme.textTheme.muted.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Wrap(spacing: 8, runSpacing: 8, children: _buildChartBadges()),
          ],
        ),
      ),
    );
  }
}

class ChartPagination extends StatefulWidget {
  const ChartPagination({super.key});

  @override
  State<ChartPagination> createState() => _ChartPaginationState();
}

class _ChartPaginationState extends State<ChartPagination> {
  final PageController _controller = PageController();

  ChatComposable get chatComposable => context.get<ChatComposable>();

  Computed<List<ChartData>> get chartDataListComputed => Computed(
    () =>
        chatComposable.messages.value
            .where((msg) => msg.isChartNotNull)
            .map((msg) => msg.chartData!)
            .toList(),
  );

  @override
  void dispose() {
    _controller.dispose();
    chartDataListComputed.dispose();
    super.dispose();
  }

  void _scrollToChart(index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  List<Widget> _buildChartRerender(List<ChartData> chartDataList) =>
      chartDataList.map((chartData) => ChartRenderer(data: chartData)).toList();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Expanded(
      child: SignalBuilder(
        signal: chartDataListComputed,
        builder: (context, chartDataList, _) {
          return Row(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  scrollDirection: Axis.vertical,
                  children: _buildChartRerender(chartDataList),
                ),
              ),
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: chartDataList.length,
                    axisDirection: Axis.vertical,
                    onDotClicked: _scrollToChart,
                    effect: WormEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      spacing: 8,
                      activeDotColor: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

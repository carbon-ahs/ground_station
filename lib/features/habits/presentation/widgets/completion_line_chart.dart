import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CompletionLineChart extends StatelessWidget {
  final List<DateTime> completionDates;
  final DateTime startDate;
  final DateTime endDate;

  const CompletionLineChart({
    super.key,
    required this.completionDates,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Create spots for the chart
    final spots = <FlSpot>[];
    final daysDiff = endDate.difference(startDate).inDays + 1;

    for (int i = 0; i < daysDiff; i++) {
      final date = startDate.add(Duration(days: i));
      final isCompleted = completionDates.any(
        (d) =>
            d.year == date.year && d.month == date.month && d.day == date.day,
      );
      spots.add(FlSpot(i.toDouble(), isCompleted ? 1 : 0));
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  colorScheme.surface,
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ]
              : [
                  colorScheme.primaryContainer.withValues(alpha: 0.1),
                  colorScheme.surface,
                ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 1,
                verticalInterval: 7,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: colorScheme.outline.withValues(alpha: 0.15),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    strokeWidth: 1,
                    dashArray: [3, 3],
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: 7,
                    getTitlesWidget: (value, meta) {
                      if (value < 0 || value >= daysDiff) {
                        return const SizedBox();
                      }
                      final date = startDate.add(Duration(days: value.toInt()));
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${date.month}/${date.day}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      if (value != 1) return const SizedBox();
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '✓ Done',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              minX: 0,
              maxX: (daysDiff - 1).toDouble(),
              minY: -0.1,
              maxY: 1.1,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: colorScheme.primary,
                  barWidth: 3.5,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      final isCompleted = spot.y == 1;
                      return FlDotCirclePainter(
                        radius: isCompleted ? 5 : 3.5,
                        color: isCompleted
                            ? colorScheme.primary
                            : colorScheme.error.withValues(alpha: 0.6),
                        strokeWidth: isCompleted ? 2.5 : 2,
                        strokeColor: isCompleted
                            ? colorScheme.primaryContainer
                            : colorScheme.errorContainer,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.25),
                        colorScheme.primary.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

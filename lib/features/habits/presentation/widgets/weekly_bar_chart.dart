import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyBarChart extends StatelessWidget {
  final Map<int, int> weekdayCompletions; // 1=Mon, 7=Sun

  const WeeklyBarChart({super.key, required this.weekdayCompletions});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final barGroups = <BarChartGroupData>[];
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (int i = 1; i <= 7; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i - 1,
          barRods: [
            BarChartRodData(
              toY: (weekdayCompletions[i] ?? 0).toDouble(),
              color: colorScheme.primary,
              width: 20,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    final maxY = weekdayCompletions.values.isEmpty
        ? 10.0
        : (weekdayCompletions.values.reduce((a, b) => a > b ? a : b) + 2)
              .toDouble();

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${weekdays[group.x.toInt()]}\n${rod.toY.toInt()} times',
                    const TextStyle(color: Colors.white),
                  );
                },
              ),
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
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        weekdays[value.toInt()],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: maxY > 10 ? 5 : 2,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            barGroups: barGroups,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  strokeWidth: 1,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

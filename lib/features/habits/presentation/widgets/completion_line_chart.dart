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

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  strokeWidth: 1,
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
                  reservedSize: 30,
                  interval: daysDiff > 15 ? 7 : 3,
                  getTitlesWidget: (value, meta) {
                    final date = startDate.add(Duration(days: value.toInt()));
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        '${date.month}/${date.day}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value == 1 ? 'Done' : 'Miss',
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
            minX: 0,
            maxX: (daysDiff - 1).toDouble(),
            minY: 0,
            maxY: 1,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: colorScheme.primary,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: spot.y == 1 ? colorScheme.primary : Colors.grey,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

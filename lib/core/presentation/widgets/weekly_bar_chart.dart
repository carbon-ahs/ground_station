import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<double>
  weeklyValues; // 7 days of data, index 0 = 6 days ago, index 6 = today
  final List<DateTime> dates; // Corresponding dates
  final double target;
  final Color barColor;
  final String unit;

  const WeeklyBarChart({
    super.key,
    required this.weeklyValues,
    required this.dates,
    required this.target,
    required this.barColor,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    // Find max value to scale the chart nicely
    double maxY = target * 1.2; // Default to slightly above target
    for (final val in weeklyValues) {
      if (val > maxY) maxY = val * 1.1;
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Last 7 Days',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => Colors.blueGrey,
                        tooltipHorizontalAlignment:
                            FLHorizontalAlignment.center,
                        tooltipMargin: -10,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String weekDay = DateFormat.E().format(
                            dates[group.x.toInt()],
                          );
                          return BarTooltipItem(
                            '$weekDay\n',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${rod.toY.toStringAsFixed(1)} $unit',
                                style: const TextStyle(
                                  color: Colors
                                      .white, // WidgetState.widget is not available in this version of flutter
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < dates.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  DateFormat.E().format(
                                    dates[index],
                                  )[0], // First letter of day
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                          reservedSize: 30,
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    barGroups: List.generate(weeklyValues.length, (index) {
                      final value = weeklyValues[index];
                      final isTargetMet = value >= target;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: value,
                            color: isTargetMet ? Colors.green : barColor,
                            width: 16,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY:
                                  target, // Show target as background height? No, maybe just max Y
                              color: Colors.grey[100],
                            ),
                          ),
                        ],
                      );
                    }),
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: target,
                          color: Colors.green.withOpacity(0.5),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                          label: HorizontalLineLabel(
                            show: true,
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.only(right: 5, bottom: 5),
                            style: TextStyle(
                              color: Colors.green.withOpacity(0.8),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            labelResolver: (line) =>
                                'Goal: ${target.toStringAsFixed(0)}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

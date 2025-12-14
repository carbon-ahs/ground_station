import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/services/csv_service.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/ground_station_app_bar.dart';
import '../../../habits/presentation/bloc/habit_bloc.dart';
import '../../../habits/presentation/bloc/habit_event.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_state.dart';
import '../bloc/settings_event.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _exportCSV(BuildContext context) async {
    try {
      final csvService = CSVService(getIt());
      final filePath = await csvService.exportHabitsToCSV();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Habits exported to:\n$filePath'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  Future<void> _importCSV(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final csvService = CSVService(getIt());
        await csvService.importHabitsFromCSV(result.files.single.path!);

        if (context.mounted) {
          context.read<HabitBloc>().add(LoadHabits());

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Habits imported successfully!')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Import failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroundStationAppBar(title: 'Settings'),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Appearance',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Theme', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.system,
                            label: Text('System'),
                            icon: Icon(Icons.brightness_auto),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            label: Text('Light'),
                            icon: Icon(Icons.brightness_5),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            label: Text('Dark'),
                            icon: Icon(Icons.brightness_2),
                          ),
                        ],
                        selected: {state.themeMode},
                        onSelectionChanged: (Set<ThemeMode> newSelection) {
                          context.read<SettingsBloc>().add(
                            UpdateTheme(newSelection.first),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Preferences',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Water Target',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${state.waterIntakeTarget} glasses',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: state.waterIntakeTarget.toDouble(),
                      min: 1,
                      max: 20,
                      divisions: 19,
                      label: '${state.waterIntakeTarget} glasses',
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          UpdateWaterIntakeTarget(value.toInt()),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Sleep Target',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${state.sleepTarget.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')} hours',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: state.sleepTarget,
                      min: 4.0,
                      max: 12.0,
                      divisions: 16, // 0.5 increments: (12-4)/0.5 = 16
                      label: '${state.sleepTarget} hours',
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          UpdateSleepTarget(value),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Set your daily sleep goal (4-12 hours)',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'About',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.satellite_alt),
            title: const Text('Version'),
            subtitle: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data!.version} (${snapshot.data!.buildNumber})',
                  );
                }
                return const Text('Loading...');
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings_input_antenna),
            title: const Text('Ground Station'),
            subtitle: const Text('Your Personal Mission Control'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementSegment(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Data Management',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.upload_file),
          title: const Text('Export to CSV'),
          subtitle: const Text('Save habits to device storage'),
          onTap: () => _exportCSV(context),
        ),
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('Import from CSV'),
          subtitle: const Text('Import habits from a CSV file'),
          onTap: () => _importCSV(context),
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('View Sample CSV Format'),
          subtitle: const Text('See example import file format'),
          onTap: () => _viewSampleCSV(context),
        ),
        const Divider(),
      ],
    );
  }

  Future<void> _viewSampleCSV(BuildContext context) async {
    const sampleCSV = '''habit_id,title,description,created_at,log_date
1,Morning Exercise,30 minutes of cardio,2024-01-01T08:00:00.000,2024-01-01T08:30:00.000
1,Morning Exercise,30 minutes of cardio,2024-01-01T08:00:00.000,2024-01-02T08:30:00.000
1,Morning Exercise,30 minutes of cardio,2024-01-01T08:00:00.000,2024-01-03T08:30:00.000
2,Read Books,Read for 20 minutes,2024-01-01T09:00:00.000,2024-01-01T21:00:00.000
2,Read Books,Read for 20 minutes,2024-01-01T09:00:00.000,2024-01-02T21:00:00.000
3,Drink Water,8 glasses per day,2024-01-01T10:00:00.000,''';

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sample CSV Format'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Use this format for importing habits:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    sampleCSV,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Key Points:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('• Same habit_id groups logs together'),
                const Text('• Empty log_date = no completions'),
                const Text('• Use ISO 8601 date format'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  final directory = await getApplicationDocumentsDirectory();
                  final file = File(
                    '${directory.path}/sample_habits_import.csv',
                  );
                  await file.writeAsString(sampleCSV);

                  if (context.mounted) {
                    Navigator.of(context).pop(); // Close dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sample CSV saved to:\n${file.path}'),
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save sample CSV: $e')),
                    );
                  }
                }
              },
              child: const Text('Download Sample'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/csv_service.dart';
import '../../../../core/di/injection.dart';
import '../../../habits/presentation/bloc/habit_bloc.dart';
import '../../../habits/presentation/bloc/habit_event.dart';

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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
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
            leading: const Icon(Icons.info_outline),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Ground Station'),
            subtitle: const Text('Your Personal Mission Control'),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
        onDestinationSelected: (index) {
          if (index == 0) {
            context.go('/dashboard');
          } else if (index == 1) {
            context.go('/habits');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(icon: Icon(Icons.check_box), label: 'Habits'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

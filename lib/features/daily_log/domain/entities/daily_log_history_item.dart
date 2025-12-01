import '../../data/models/daily_log_entity.dart';
import '../../data/models/daily_note_entity.dart';

class DailyLogHistoryItem {
  final DailyLogEntity log;
  final List<DailyNoteEntity> notes;

  const DailyLogHistoryItem({required this.log, required this.notes});
}

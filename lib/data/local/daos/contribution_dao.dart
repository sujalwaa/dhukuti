import 'package:uuid/uuid.dart';
import '../database_helper.dart';

/// DAO for contributions table
class ContributionDao {
  final DatabaseHelper db;

  ContributionDao(this.db);

  /// Get contributions by goal ID
  Future<List<Map<String, dynamic>>> getByGoalId(String goalId) async {
    return await db.query(
      'contributions',
      where: 'goal_id = ?',
      whereArgs: [goalId],
      orderBy: 'date DESC',
    );
  }

  /// Insert contribution
  Future<void> insert(Map<String, dynamic> contribution) async {
    final data = Map<String, dynamic>.from(contribution);
    if (!data.containsKey('id') || data['id'] == null) {
      data['id'] = const Uuid().v4();
    }
    data['created_at'] = DateTime.now().toIso8601String();
    data['updated_at'] = data['created_at'];
    await db.insert('contributions', data);
  }

  /// Delete contribution
  Future<void> delete(String id) async {
    await db.delete('contributions', 'id = ?', [id]);
  }

  /// Get recent contributions by goal ID within given months
  Future<List<Map<String, dynamic>>> getRecentByGoalId(String goalId, int months) async {
    final date = DateTime.now().subtract(Duration(days: 30 * months)).toIso8601String();
    return await db.query(
      'contributions',
      where: 'goal_id = ? AND date >= ?',
      whereArgs: [goalId, date],
      orderBy: 'date DESC',
    );
  }
}

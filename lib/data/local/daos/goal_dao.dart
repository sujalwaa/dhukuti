import 'package:uuid/uuid.dart';
import '../database_helper.dart';

/// DAO for goals table
class GoalDao {
  final DatabaseHelper db;

  GoalDao(this.db);

  /// Get all goals
  Future<List<Map<String, dynamic>>> getAll(String userId) async {
    return await db.query('goals', where: 'user_id = ?', whereArgs: [userId]);
  }

  /// Get goal by ID
  Future<Map<String, dynamic>?> getById(String id) async {
    final results = await db.query('goals', where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  /// Insert goal
  Future<void> insert(Map<String, dynamic> goal) async {
    final data = Map<String, dynamic>.from(goal);
    if (!data.containsKey('id') || data['id'] == null) {
      data['id'] = const Uuid().v4();
    }
    data['created_at'] = DateTime.now().toIso8601String();
    data['updated_at'] = data['created_at'];
    await db.insert('goals', data);
  }

  /// Update goal
  Future<void> update(Map<String, dynamic> goal) async {
    final data = Map<String, dynamic>.from(goal);
    data['updated_at'] = DateTime.now().toIso8601String();
    await db.update('goals', data, 'id = ?', [data['id']]);
  }

  /// Delete goal
  Future<void> delete(String id) async {
    await db.delete('goals', 'id = ?', [id]);
  }

  /// Update goal balance
  Future<void> updateBalance(String id, int newBalance) async {
    await db.update(
      'goals',
      {
        'balance': newBalance,
        'updated_at': DateTime.now().toIso8601String(),
      },
      'id = ?',
      [id],
    );
  }
}

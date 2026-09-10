import 'package:uuid/uuid.dart';
import '../database_helper.dart';

/// DAO for incomes table
class IncomeDao {
  final DatabaseHelper db;

  IncomeDao(this.db);

  /// Get all incomes sorted by date desc
  Future<List<Map<String, dynamic>>> getAll(String userId) async {
    return await db.query('incomes', where: 'user_id = ?', whereArgs: [userId], orderBy: 'date DESC');
  }

  /// Get incomes by date range
  Future<List<Map<String, dynamic>>> getByDateRange(String userId, String start, String end) async {
    return await db.query(
      'incomes',
      where: 'user_id = ? AND date >= ? AND date <= ?',
      whereArgs: [userId, start, end],
      orderBy: 'date DESC',
    );
  }

  /// Insert income
  Future<void> insert(Map<String, dynamic> income) async {
    final data = Map<String, dynamic>.from(income);
    if (!data.containsKey('id') || data['id'] == null) {
      data['id'] = const Uuid().v4();
    }
    data['created_at'] = DateTime.now().toIso8601String();
    data['updated_at'] = data['created_at'];
    await db.insert('incomes', data);
  }

  /// Update income
  Future<void> update(Map<String, dynamic> income) async {
    final data = Map<String, dynamic>.from(income);
    data['updated_at'] = DateTime.now().toIso8601String();
    await db.update('incomes', data, 'id = ?', [data['id']]);
  }

  /// Delete income
  Future<void> delete(String id) async {
    await db.delete('incomes', 'id = ?', [id]);
  }
}

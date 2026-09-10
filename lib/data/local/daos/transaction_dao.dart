import 'package:uuid/uuid.dart';
import '../database_helper.dart';

/// DAO for transactions table
class TransactionDao {
  final DatabaseHelper db;

  TransactionDao(this.db);

  /// Get all transactions for a user, sorted by date DESC
  Future<List<Map<String, dynamic>>> getAll(String userId) async {
    return await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
  }

  /// Get transactions within a date range
  Future<List<Map<String, dynamic>>> getByDateRange(String userId, String start, String end) async {
    return await db.query(
      'transactions',
      where: 'user_id = ? AND date >= ? AND date <= ?',
      whereArgs: [userId, start, end],
      orderBy: 'date DESC',
    );
  }

  /// Get transactions by category
  Future<List<Map<String, dynamic>>> getByCategory(String userId, String categoryId) async {
    return await db.query(
      'transactions',
      where: 'user_id = ? AND category_id = ?',
      whereArgs: [userId, categoryId],
      orderBy: 'date DESC',
    );
  }

  /// Search transactions by name (case-insensitive)
  Future<List<Map<String, dynamic>>> search(String userId, String query) async {
    return await db.query(
      'transactions',
      where: 'user_id = ? AND name LIKE ?',
      whereArgs: [userId, '%$query%'],
      orderBy: 'date DESC',
    );
  }

  /// Insert a transaction
  Future<void> insert(Map<String, dynamic> transaction) async {
    final data = Map<String, dynamic>.from(transaction);
    if (!data.containsKey('id') || data['id'] == null) {
      data['id'] = const Uuid().v4();
    }
    data['created_at'] = DateTime.now().toIso8601String();
    data['updated_at'] = data['created_at'];
    await db.insert('transactions', data);
  }

  /// Update a transaction
  Future<void> update(Map<String, dynamic> transaction) async {
    final data = Map<String, dynamic>.from(transaction);
    data['updated_at'] = DateTime.now().toIso8601String();
    await db.update('transactions', data, 'id = ?', [data['id']]);
  }

  /// Delete a transaction
  Future<void> delete(String id) async {
    await db.delete('transactions', 'id = ?', [id]);
  }

  /// Insert batch of transactions
  Future<void> insertBatch(List<Map<String, dynamic>> transactions) async {
    final database = await db.database;
    await database.transaction((txn) async {
      for (final transaction in transactions) {
        final data = Map<String, dynamic>.from(transaction);
        if (!data.containsKey('id') || data['id'] == null) {
          data['id'] = const Uuid().v4();
        }
        data['created_at'] = DateTime.now().toIso8601String();
        data['updated_at'] = data['created_at'];
        await txn.insert('transactions', data);
      }
    });
  }
}

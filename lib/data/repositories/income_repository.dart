import '../models/income.dart';
import '../local/database_helper.dart';
import '../local/daos/sync_queue_dao.dart';

/// Repository for managing incomes
class IncomeRepository {
  final DatabaseHelper _db;
  final SyncQueueDao _syncQueueDao;

  IncomeRepository(this._db, this._syncQueueDao);

  /// Get all incomes for a user, sorted by date DESC
  Future<List<Income>> getAll(String userId) async {
    final data = await _db.query('incomes', where: 'user_id = ?', whereArgs: [userId], orderBy: 'date DESC');
    return data.map((map) => Income.fromMap(map)).toList();
  }

  /// Get incomes within a date range
  Future<List<Income>> getByDateRange(String userId, DateTime start, DateTime end) async {
    final data = await _db.query(
      'incomes',
      where: 'user_id = ? AND date >= ? AND date <= ?',
      whereArgs: [userId, start.toUtc().toIso8601String(), end.toUtc().toIso8601String()],
      orderBy: 'date DESC',
    );
    return data.map((map) => Income.fromMap(map)).toList();
  }

  /// Create an income, update account balance (add amount), and enqueue sync
  Future<void> create(Income income) async {
    final data = income.toMap();
    final now = DateTime.now().toIso8601String();
    data['created_at'] = now;
    data['updated_at'] = now;
    data['synced'] = 0;

    final db = await _db.database;
    await db.transaction((txn) async {
      await txn.insert('incomes', data);
      
      // Update account balance (add amount)
      await txn.rawUpdate(
        'UPDATE accounts SET balance = balance + ?, updated_at = ? WHERE id = ?',
        [income.amount, now, income.accountId],
      );
      
      await _syncQueueDao.enqueue('incomes', income.id, 'INSERT', data);
      
      // Enqueue account update
      final accountData = await txn.query('accounts', where: 'id = ?', whereArgs: [income.accountId]);
      if (accountData.isNotEmpty) {
        await _syncQueueDao.enqueue('accounts', income.accountId, 'UPDATE', accountData.first);
      }
    });
  }

  /// Delete an income, restore account balance (subtract amount), and enqueue sync
  Future<void> delete(String id) async {
    final db = await _db.database;
    await db.transaction((txn) async {
      final incData = await txn.query('incomes', where: 'id = ?', whereArgs: [id]);
      if (incData.isEmpty) return;

      final amount = incData.first['amount'] as int;
      final accountId = incData.first['account_id'] as String;
      final now = DateTime.now().toIso8601String();

      await txn.delete('incomes', where: 'id = ?', whereArgs: [id]);
      
      // Restore account balance
      await txn.rawUpdate(
        'UPDATE accounts SET balance = balance - ?, updated_at = ? WHERE id = ?',
        [amount, now, accountId],
      );

      await _syncQueueDao.enqueue('incomes', id, 'DELETE', {});
      
      final accountData = await txn.query('accounts', where: 'id = ?', whereArgs: [accountId]);
      if (accountData.isNotEmpty) {
        await _syncQueueDao.enqueue('accounts', accountId, 'UPDATE', accountData.first);
      }
    });
  }
}

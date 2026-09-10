import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../local/database_helper.dart';
import '../local/daos/sync_queue_dao.dart';

/// Repository for managing transactions
class TransactionRepository {
  final DatabaseHelper _db;
  final SyncQueueDao _syncQueueDao;

  TransactionRepository(this._db, this._syncQueueDao);

  /// Get all transactions for a specific user, sorted by date descending
  Future<List<Transaction>> getAll(String userId) async {
    final data = await _db.query('transactions', where: 'user_id = ?', whereArgs: [userId], orderBy: 'date DESC');
    return data.map((map) => Transaction.fromMap(map)).toList();
  }

  /// Get transactions within a date range
  Future<List<Transaction>> getByDateRange(String userId, DateTime start, DateTime end) async {
    final data = await _db.query(
      'transactions',
      where: 'user_id = ? AND date >= ? AND date <= ?',
      whereArgs: [userId, start.toUtc().toIso8601String(), end.toUtc().toIso8601String()],
      orderBy: 'date DESC',
    );
    return data.map((map) => Transaction.fromMap(map)).toList();
  }

  /// Get transactions by category
  Future<List<Transaction>> getByCategory(String userId, String categoryId) async {
    final data = await _db.query(
      'transactions',
      where: 'user_id = ? AND category_id = ?',
      whereArgs: [userId, categoryId],
      orderBy: 'date DESC',
    );
    return data.map((map) => Transaction.fromMap(map)).toList();
  }

  /// Search transactions by name (case-insensitive)
  Future<List<Transaction>> search(String userId, String query) async {
    final data = await _db.query(
      'transactions',
      where: 'user_id = ? AND name LIKE ?',
      whereArgs: [userId, '%$query%'],
      orderBy: 'date DESC',
    );
    return data.map((map) => Transaction.fromMap(map)).toList();
  }

  /// Create a transaction, update account balance, and enqueue sync
  Future<void> create(Transaction transaction) async {
    final data = transaction.toMap();
    final now = DateTime.now().toIso8601String();
    data['created_at'] = now;
    data['updated_at'] = now;
    data['synced'] = 0;

    final db = await _db.database;
    await db.transaction((txn) async {
      await txn.insert('transactions', data);
      
      // Update account balance (subtract amount for expense)
      await txn.rawUpdate(
        'UPDATE accounts SET balance = balance - ?, updated_at = ? WHERE id = ?',
        [transaction.amount, now, transaction.accountId],
      );
      
      await _syncQueueDao.enqueue('transactions', transaction.id, 'INSERT', data);
      
      // We also need to enqueue the account update
      final accountData = await txn.query('accounts', where: 'id = ?', whereArgs: [transaction.accountId]);
      if (accountData.isNotEmpty) {
        await _syncQueueDao.enqueue('accounts', transaction.accountId, 'UPDATE', accountData.first);
      }
    });
  }

  /// Delete a transaction, restore account balance, and enqueue sync
  Future<void> delete(String id) async {
    final db = await _db.database;
    await db.transaction((txn) async {
      final txData = await txn.query('transactions', where: 'id = ?', whereArgs: [id]);
      if (txData.isEmpty) return;

      final amount = txData.first['amount'] as int;
      final accountId = txData.first['account_id'] as String;
      final now = DateTime.now().toIso8601String();

      await txn.delete('transactions', where: 'id = ?', whereArgs: [id]);
      
      // Restore account balance
      await txn.rawUpdate(
        'UPDATE accounts SET balance = balance + ?, updated_at = ? WHERE id = ?',
        [amount, now, accountId],
      );

      await _syncQueueDao.enqueue('transactions', id, 'DELETE', {});
      
      final accountData = await txn.query('accounts', where: 'id = ?', whereArgs: [accountId]);
      if (accountData.isNotEmpty) {
        await _syncQueueDao.enqueue('accounts', accountId, 'UPDATE', accountData.first);
      }
    });
  }

  /// Import a batch of transactions
  Future<void> importBatch(List<Transaction> transactions) async {
    final db = await _db.database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      for (var tx in transactions) {
        final txWithSource = tx.copyWith(source: 'import');
        final data = txWithSource.toMap();
        data['created_at'] = now;
        data['updated_at'] = now;
        data['synced'] = 0;

        await txn.insert('transactions', data);
        
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance - ?, updated_at = ? WHERE id = ?',
          [tx.amount, now, tx.accountId],
        );

        await _syncQueueDao.enqueue('transactions', tx.id, 'INSERT', data);
        
        final accountData = await txn.query('accounts', where: 'id = ?', whereArgs: [tx.accountId]);
        if (accountData.isNotEmpty) {
          await _syncQueueDao.enqueue('accounts', tx.accountId, 'UPDATE', accountData.first);
        }
      }
    });
  }
}

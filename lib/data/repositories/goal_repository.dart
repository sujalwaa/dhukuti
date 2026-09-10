import 'package:uuid/uuid.dart';
import '../models/goal.dart';
import '../models/contribution.dart';
import '../local/database_helper.dart';
import '../local/daos/sync_queue_dao.dart';

/// Repository for managing goals, with strict money-flow invariants.
class GoalRepository {
  final DatabaseHelper _db;
  final SyncQueueDao _syncQueueDao;

  GoalRepository(this._db, this._syncQueueDao);

  /// Get all goals for a user
  Future<List<Goal>> getAll(String userId) async {
    final data = await _db.query('goals', where: 'user_id = ?', whereArgs: [userId]);
    return data.map((map) => Goal.fromMap(map)).toList();
  }

  /// Get goal by ID
  Future<Goal?> getById(String id) async {
    final data = await _db.query('goals', where: 'id = ?', whereArgs: [id]);
    if (data.isEmpty) return null;
    return Goal.fromMap(data.first);
  }

  /// Get contributions for a goal, sorted by date DESC
  Future<List<Contribution>> getContributions(String goalId) async {
    final data = await _db.query('contributions', where: 'goal_id = ?', whereArgs: [goalId], orderBy: 'date DESC');
    return data.map((map) => Contribution.fromMap(map)).toList();
  }

  /// Create a goal and optionally make an initial deposit
  Future<void> create(Goal goal, {int? initialDeposit}) async {
    final now = DateTime.now().toIso8601String();
    final db = await _db.database;

    await db.transaction((txn) async {
      final goalData = goal.toMap();
      goalData['balance'] = initialDeposit ?? 0;
      goalData['created_at'] = now;
      goalData['updated_at'] = now;
      goalData['synced'] = 0;

      await txn.insert('goals', goalData);
      await _syncQueueDao.enqueue('goals', goal.id, 'INSERT', goalData);

      if (initialDeposit != null && initialDeposit > 0) {
        // Decrease source account balance
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance - ?, updated_at = ? WHERE id = ?',
          [initialDeposit, now, goal.sourceAccountId],
        );

        final accountData = await txn.query('accounts', where: 'id = ?', whereArgs: [goal.sourceAccountId]);
        if (accountData.isNotEmpty) {
          await _syncQueueDao.enqueue('accounts', goal.sourceAccountId, 'UPDATE', accountData.first);
        }

        // Create contribution
        final contributionId = const Uuid().v4();
        final contribData = {
          'id': contributionId,
          'goal_id': goal.id,
          'type': 'contribute',
          'amount': initialDeposit,
          'date': now,
          'note': 'Initial deposit',
          'created_at': now,
          'updated_at': now,
          'synced': 0,
        };
        await txn.insert('contributions', contribData);
        await _syncQueueDao.enqueue('contributions', contributionId, 'INSERT', contribData);
      }
    });
  }

  /// Update goal metadata (not balance)
  Future<void> update(Goal goal) async {
    final db = await _db.database;
    final now = DateTime.now().toIso8601String();
    
    // We fetch existing goal to prevent overwriting balance
    final existingData = await db.query('goals', where: 'id = ?', whereArgs: [goal.id]);
    if (existingData.isEmpty) return;
    
    final existingBalance = existingData.first['balance'] as int;
    
    final data = goal.toMap();
    data['balance'] = existingBalance;
    data['updated_at'] = now;
    data['synced'] = 0;

    await db.update('goals', data, where: 'id = ?', whereArgs: [goal.id]);
    await _syncQueueDao.enqueue('goals', goal.id, 'UPDATE', data);
  }

  /// Contribute money to a goal
  Future<void> contribute(String goalId, int amount, String note) async {
    final db = await _db.database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      final goalData = await txn.query('goals', where: 'id = ?', whereArgs: [goalId]);
      if (goalData.isEmpty) throw Exception('Goal not found');
      
      final sourceAccountId = goalData.first['source_account_id'] as String;

      final accountData = await txn.query('accounts', where: 'id = ?', whereArgs: [sourceAccountId]);
      if (accountData.isEmpty) throw Exception('Source account not found');
      
      final accountBalance = accountData.first['balance'] as int;
      if (amount > accountBalance) throw Exception('Insufficient funds in source account');

      // Update goal balance
      await txn.rawUpdate(
        'UPDATE goals SET balance = balance + ?, updated_at = ? WHERE id = ?',
        [amount, now, goalId],
      );
      
      // Update account balance
      await txn.rawUpdate(
        'UPDATE accounts SET balance = balance - ?, updated_at = ? WHERE id = ?',
        [amount, now, sourceAccountId],
      );

      // Enqueue syncs
      final updatedGoal = await txn.query('goals', where: 'id = ?', whereArgs: [goalId]);
      await _syncQueueDao.enqueue('goals', goalId, 'UPDATE', updatedGoal.first);

      final updatedAccount = await txn.query('accounts', where: 'id = ?', whereArgs: [sourceAccountId]);
      await _syncQueueDao.enqueue('accounts', sourceAccountId, 'UPDATE', updatedAccount.first);

      // Insert contribution record
      final contributionId = const Uuid().v4();
      final contribData = {
        'id': contributionId,
        'goal_id': goalId,
        'type': 'contribute',
        'amount': amount,
        'date': now,
        'note': note,
        'created_at': now,
        'updated_at': now,
        'synced': 0,
      };
      await txn.insert('contributions', contribData);
      await _syncQueueDao.enqueue('contributions', contributionId, 'INSERT', contribData);
    });
  }

  /// Withdraw money from a goal
  Future<void> withdraw(String goalId, int amount, String note) async {
    final db = await _db.database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      final goalData = await txn.query('goals', where: 'id = ?', whereArgs: [goalId]);
      if (goalData.isEmpty) throw Exception('Goal not found');
      
      final goalBalance = goalData.first['balance'] as int;
      if (amount > goalBalance) throw Exception('Insufficient funds in goal');

      final sourceAccountId = goalData.first['source_account_id'] as String;

      // Update goal balance
      await txn.rawUpdate(
        'UPDATE goals SET balance = balance - ?, updated_at = ? WHERE id = ?',
        [amount, now, goalId],
      );
      
      // Update account balance
      await txn.rawUpdate(
        'UPDATE accounts SET balance = balance + ?, updated_at = ? WHERE id = ?',
        [amount, now, sourceAccountId],
      );

      // Enqueue syncs
      final updatedGoal = await txn.query('goals', where: 'id = ?', whereArgs: [goalId]);
      await _syncQueueDao.enqueue('goals', goalId, 'UPDATE', updatedGoal.first);

      final updatedAccount = await txn.query('accounts', where: 'id = ?', whereArgs: [sourceAccountId]);
      await _syncQueueDao.enqueue('accounts', sourceAccountId, 'UPDATE', updatedAccount.first);

      // Insert contribution record
      final contributionId = const Uuid().v4();
      final contribData = {
        'id': contributionId,
        'goal_id': goalId,
        'type': 'withdraw',
        'amount': amount,
        'date': now,
        'note': note,
        'created_at': now,
        'updated_at': now,
        'synced': 0,
      };
      await txn.insert('contributions', contribData);
      await _syncQueueDao.enqueue('contributions', contributionId, 'INSERT', contribData);
    });
  }

  /// Delete goal and restore money to source account
  Future<void> delete(String goalId) async {
    final db = await _db.database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      final goalData = await txn.query('goals', where: 'id = ?', whereArgs: [goalId]);
      if (goalData.isEmpty) return;

      final balance = goalData.first['balance'] as int;
      final sourceAccountId = goalData.first['source_account_id'] as String;

      if (balance > 0) {
        // Return funds to account
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance + ?, updated_at = ? WHERE id = ?',
          [balance, now, sourceAccountId],
        );
        final updatedAccount = await txn.query('accounts', where: 'id = ?', whereArgs: [sourceAccountId]);
        await _syncQueueDao.enqueue('accounts', sourceAccountId, 'UPDATE', updatedAccount.first);
      }

      // Delete contributions
      final contributions = await txn.query('contributions', where: 'goal_id = ?', whereArgs: [goalId]);
      for (var c in contributions) {
        await txn.delete('contributions', where: 'id = ?', whereArgs: [c['id']]);
        await _syncQueueDao.enqueue('contributions', c['id'] as String, 'DELETE', {});
      }

      // Delete goal
      await txn.delete('goals', where: 'id = ?', whereArgs: [goalId]);
      await _syncQueueDao.enqueue('goals', goalId, 'DELETE', {});
    });
  }
}

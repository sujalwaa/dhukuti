import 'package:uuid/uuid.dart';
import '../database_helper.dart';

/// DAO for accounts table
class AccountDao {
  final DatabaseHelper db;
  
  AccountDao(this.db);

  /// Get all accounts for a user
  Future<List<Map<String, dynamic>>> getAll(String userId) async {
    return await db.query('accounts', where: 'user_id = ?', whereArgs: [userId]);
  }

  /// Get account by ID
  Future<Map<String, dynamic>?> getById(String id) async {
    final results = await db.query('accounts', where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  /// Insert a new account
  Future<void> insert(Map<String, dynamic> account) async {
    final data = Map<String, dynamic>.from(account);
    if (!data.containsKey('id') || data['id'] == null) {
      data['id'] = const Uuid().v4();
    }
    data['created_at'] = DateTime.now().toIso8601String();
    data['updated_at'] = data['created_at'];
    await db.insert('accounts', data);
  }

  /// Update an existing account
  Future<void> update(Map<String, dynamic> account) async {
    final data = Map<String, dynamic>.from(account);
    data['updated_at'] = DateTime.now().toIso8601String();
    await db.update('accounts', data, 'id = ?', [data['id']]);
  }

  /// Delete an account
  Future<void> delete(String id) async {
    await db.delete('accounts', 'id = ?', [id]);
  }

  /// Update account balance
  Future<void> updateBalance(String id, int newBalance) async {
    await db.update(
      'accounts',
      {
        'balance': newBalance,
        'updated_at': DateTime.now().toIso8601String(),
      },
      'id = ?',
      [id],
    );
  }
}

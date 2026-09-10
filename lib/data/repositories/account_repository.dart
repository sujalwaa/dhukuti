import '../models/account.dart';
import '../local/daos/account_dao.dart';
import '../local/daos/sync_queue_dao.dart';

/// Repository for managing accounts
class AccountRepository {
  final AccountDao _accountDao;
  final SyncQueueDao _syncQueueDao;

  AccountRepository(this._accountDao, this._syncQueueDao);

  /// Get all accounts for a specific user
  Future<List<Account>> getAll(String userId) async {
    final data = await _accountDao.getAll(userId);
    return data.map((map) => Account.fromMap(map)).toList();
  }

  /// Get a specific account by ID
  Future<Account?> getById(String id) async {
    final data = await _accountDao.getById(id);
    if (data == null) return null;
    return Account.fromMap(data);
  }

  /// Create a new account
  Future<void> create(Account account) async {
    final data = account.toMap();
    data['created_at'] = DateTime.now().toIso8601String();
    data['updated_at'] = data['created_at'];
    data['synced'] = 0;

    await _accountDao.insert(data);
    await _syncQueueDao.enqueue('accounts', account.id, 'INSERT', data);
  }

  /// Update an existing account
  Future<void> update(Account account) async {
    final data = account.toMap();
    data['updated_at'] = DateTime.now().toIso8601String();
    data['synced'] = 0;

    await _accountDao.update(data);
    await _syncQueueDao.enqueue('accounts', account.id, 'UPDATE', data);
  }

  /// Delete an account by ID
  Future<void> delete(String id) async {
    await _accountDao.delete(id);
    await _syncQueueDao.enqueue('accounts', id, 'DELETE', {});
  }

  /// Update the balance of an account atomically
  Future<void> updateBalance(String id, int newBalance) async {
    await _accountDao.updateBalance(id, newBalance);
    
    final account = await getById(id);
    if (account != null) {
      final data = account.toMap();
      data['updated_at'] = DateTime.now().toIso8601String();
      await _syncQueueDao.enqueue('accounts', id, 'UPDATE', data);
    }
  }
}

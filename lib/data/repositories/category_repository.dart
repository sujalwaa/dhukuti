import '../models/category.dart';
import '../local/database_helper.dart';
import '../local/daos/sync_queue_dao.dart';

/// Repository for managing categories
class CategoryRepository {
  final DatabaseHelper _db;
  final SyncQueueDao _syncQueueDao;

  CategoryRepository(this._db, this._syncQueueDao);

  /// Get all categories for a user
  Future<List<Category>> getAll(String userId) async {
    final data = await _db.query('categories', where: 'user_id = ?', whereArgs: [userId]);
    return data.map((map) => Category.fromMap(map)).toList();
  }

  /// Create a new category
  Future<void> create(Category category) async {
    final data = category.toMap();
    final now = DateTime.now().toIso8601String();
    data['created_at'] = now;
    data['updated_at'] = now;
    data['synced'] = 0;

    await _db.insert('categories', data);
    await _syncQueueDao.enqueue('categories', category.id, 'INSERT', data);
  }

  /// Update an existing category
  Future<void> update(Category category) async {
    final data = category.toMap();
    final now = DateTime.now().toIso8601String();
    data['updated_at'] = now;
    data['synced'] = 0;

    await _db.update('categories', data, 'id = ?', [category.id]);
    await _syncQueueDao.enqueue('categories', category.id, 'UPDATE', data);
  }

  /// Delete a category
  Future<void> delete(String id) async {
    await _db.delete('categories', 'id = ?', [id]);
    await _syncQueueDao.enqueue('categories', id, 'DELETE', {});
  }
}

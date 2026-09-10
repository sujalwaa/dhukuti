import 'package:uuid/uuid.dart';
import '../database_helper.dart';

/// DAO for categories table
class CategoryDao {
  final DatabaseHelper db;

  CategoryDao(this.db);

  /// Get all categories
  Future<List<Map<String, dynamic>>> getAll(String userId) async {
    return await db.query('categories', where: 'user_id = ?', whereArgs: [userId]);
  }

  /// Get category by ID
  Future<Map<String, dynamic>?> getById(String id) async {
    final results = await db.query('categories', where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  /// Insert category
  Future<void> insert(Map<String, dynamic> category) async {
    final data = Map<String, dynamic>.from(category);
    if (!data.containsKey('id') || data['id'] == null) {
      data['id'] = const Uuid().v4();
    }
    data['created_at'] = DateTime.now().toIso8601String();
    data['updated_at'] = data['created_at'];
    await db.insert('categories', data);
  }

  /// Update category
  Future<void> update(Map<String, dynamic> category) async {
    final data = Map<String, dynamic>.from(category);
    data['updated_at'] = DateTime.now().toIso8601String();
    await db.update('categories', data, 'id = ?', [data['id']]);
  }

  /// Delete category
  Future<void> delete(String id) async {
    await db.delete('categories', 'id = ?', [id]);
  }
}

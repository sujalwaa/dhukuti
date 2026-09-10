import 'dart:convert';
import '../database_helper.dart';

/// DAO for sync_queue table
class SyncQueueDao {
  final DatabaseHelper db;

  SyncQueueDao(this.db);

  /// Enqueue an operation to the sync queue
  Future<void> enqueue(String tableName, String recordId, String operation, Map<String, dynamic> payload) async {
    final data = {
      'table_name': tableName,
      'record_id': recordId,
      'operation': operation,
      'payload': jsonEncode(payload),
      'created_at': DateTime.now().toIso8601String(),
      'synced': 0,
    };
    await db.insert('sync_queue', data);
  }

  /// Get all unsynced items
  Future<List<Map<String, dynamic>>> getUnsynced() async {
    return await db.query('sync_queue', where: 'synced = ?', whereArgs: [0], orderBy: 'created_at ASC');
  }

  /// Mark an item as synced
  Future<void> markSynced(int id) async {
    await db.update(
      'sync_queue',
      {'synced': 1},
      'id = ?',
      [id],
    );
  }

  /// Clear all synced items
  Future<void> clearSynced() async {
    await db.delete('sync_queue', 'synced = ?', [1]);
  }
}

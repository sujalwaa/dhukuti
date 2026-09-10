import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../local/database_helper.dart';
import '../local/daos/sync_queue_dao.dart';
import 'supabase_service.dart';

/// Background sync service to keep local DB and Supabase in sync.
class SyncService {
  final SyncQueueDao _syncQueueDao;
  final SupabaseService _supabaseService;
  final DatabaseHelper _dbHelper;

  SyncService(this._syncQueueDao, this._supabaseService, this._dbHelper);

  /// Pushes all pending local changes to Supabase.
  Future<void> syncPendingChanges() async {
    final pending = await _syncQueueDao.getUnsynced();
    for (var item in pending) {
      final tableName = item['table_name'] as String;
      final operation = item['operation'] as String;
      final id = item['record_id'] as String;

      try {
        if (operation == 'DELETE') {
          await _supabaseService.deleteRecord(tableName, id);
        } else {
          final payload = jsonDecode(item['payload'] as String) as Map<String, dynamic>;
          payload.remove('synced');
          await _supabaseService.pushRecord(tableName, payload);
        }
        await _syncQueueDao.markSynced(item['id'] as int);
      } catch (e) {
        print('Error syncing item $id: $e');
      }
    }
    await _syncQueueDao.clearSynced();
  }

  /// Pulls the latest data from Supabase and upserts into local DB.
  Future<void> pullLatestData(String userId) async {
    final tables = ['accounts', 'categories', 'transactions', 'incomes', 'goals'];

    for (var table in tables) {
      try {
        final records = await _supabaseService.pullRecords(table, userId);
        for (var record in records) {
          record['synced'] = 1;
          final localData = await _dbHelper.query(table, where: 'id = ?', whereArgs: [record['id']]);
          if (localData.isNotEmpty) {
            final localUpdate = DateTime.parse(localData.first['updated_at'] as String);
            final remoteUpdate = DateTime.parse(record['updated_at'] as String);
            if (remoteUpdate.isAfter(localUpdate)) {
              await _dbHelper.update(table, record, 'id = ?', [record['id']]);
            }
          } else {
            await _dbHelper.insert(table, record);
          }
        }
      } catch (e) {
        print('Error pulling $table: $e');
      }
    }

    try {
      final contributions = await _supabaseService.pullContributions(userId);
      for (var record in contributions) {
        record['synced'] = 1;
        final localData = await _dbHelper.query('contributions', where: 'id = ?', whereArgs: [record['id']]);
        if (localData.isNotEmpty) {
          final localUpdate = DateTime.parse(localData.first['updated_at'] as String);
          final remoteUpdate = DateTime.parse(record['updated_at'] as String);
          if (remoteUpdate.isAfter(localUpdate)) {
            await _dbHelper.update('contributions', record, 'id = ?', [record['id']]);
          }
        } else {
          await _dbHelper.insert('contributions', record);
        }
      }
    } catch (e) {
      print('Error pulling contributions: $e');
    }
  }

  /// Starts listening to network changes to trigger auto-sync.
  void startAutoSync() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      if (result != ConnectivityResult.none && result != ConnectivityResult.bluetooth) {
        syncPendingChanges();
      }
    });
  }
}

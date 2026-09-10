import 'package:supabase_flutter/supabase_flutter.dart';

/// Service to handle interactions with Supabase.
class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Returns the current authenticated user ID, if any.
  String? get currentUserId => _client.auth.currentUser?.id;

  /// Upserts a record into the specified table.
  Future<void> pushRecord(String tableName, Map<String, dynamic> data) async {
    try {
      await _client.from(tableName).upsert(data);
    } catch (e) {
      print('Supabase push error ($tableName): $e');
      rethrow;
    }
  }

  /// Deletes a record from the specified table.
  Future<void> deleteRecord(String tableName, String id) async {
    try {
      await _client.from(tableName).delete().eq('id', id);
    } catch (e) {
      print('Supabase delete error ($tableName): $e');
      rethrow;
    }
  }

  /// Pulls all records for a specific user from the specified table.
  Future<List<Map<String, dynamic>>> pullRecords(String tableName, String userId) async {
    try {
      final data = await _client.from(tableName).select().eq('user_id', userId);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Supabase pull error ($tableName): $e');
      rethrow;
    }
  }

  /// Pulls all contributions related to the given user's goals.
  Future<List<Map<String, dynamic>>> pullContributions(String userId) async {
    try {
      final goals = await _client.from('goals').select('id').eq('user_id', userId);
      if (goals.isEmpty) return [];

      final goalIds = goals.map((g) => g['id']).toList();
      final data = await _client.from('contributions').select().inFilter('goal_id', goalIds);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Supabase pull error (contributions): $e');
      rethrow;
    }
  }
}

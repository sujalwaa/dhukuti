import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

abstract class SyncState {
  const SyncState();
}

class SyncIdle extends SyncState {
  final DateTime? lastSynced;
  const SyncIdle({this.lastSynced});
}

class SyncSyncing extends SyncState {
  const SyncSyncing();
}

class SyncError extends SyncState {
  final String message;
  const SyncError(this.message);
}

class SyncNotifier extends StateNotifier<SyncState> {
  final Ref _ref;

  SyncNotifier(this._ref) : super(const SyncIdle());

  Future<void> triggerSync() async {
    final authState = _ref.read(authProvider);
    if (authState is! AuthAuthenticated) return;

    state = const SyncSyncing();
    try {
      // Implement sync logic using syncQueueDaoProvider and Supabase
      // e.g. SyncService(_ref).sync();
      
      // Simulate sync
      await Future.delayed(const Duration(seconds: 1));
      
      state = SyncIdle(lastSynced: DateTime.now());
    } catch (e) {
      state = SyncError(e.toString());
    }
  }

  void startAutoSync() {
    // Implement auto sync trigger e.g., timer or network connectivity listener
  }
}

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref);
});

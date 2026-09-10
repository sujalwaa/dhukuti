import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/goal.dart';
import '../../data/models/contribution.dart';
import 'database_provider.dart';
import 'account_provider.dart';

class GoalsNotifier extends StateNotifier<List<Goal>> {
  final Ref _ref;

  GoalsNotifier(this._ref) : super([]);

  Future<void> loadGoals(String userId) async {
    final repo = _ref.read(goalRepositoryProvider);
    state = await repo.getAll(userId);
  }

  Future<void> createGoal(Goal goal, int initialDeposit) async {
    final repo = _ref.read(goalRepositoryProvider);
    await repo.create(goal, initialDeposit: initialDeposit);
    await loadGoals(goal.userId);
  }

  Future<void> update(Goal goal) async {
    final repo = _ref.read(goalRepositoryProvider);
    await repo.update(goal);
    await loadGoals(goal.userId);
  }

  Future<void> delete(String goalId) async {
    final repo = _ref.read(goalRepositoryProvider);
    final goal = state.firstWhere((g) => g.id == goalId);
    await repo.delete(goalId);
    await loadGoals(goal.userId);
  }

  Future<void> contribute(String goalId, int amount, String note) async {
    final goalRepo = _ref.read(goalRepositoryProvider);
    final goal = state.firstWhere((g) => g.id == goalId);
    await goalRepo.contribute(goalId, amount, note);
    await loadGoals(goal.userId);
  }
  Future<void> withdraw(String goalId, int amount, String note) async {
    final goalRepo = _ref.read(goalRepositoryProvider);
    final goal = state.firstWhere((g) => g.id == goalId);
    await goalRepo.withdraw(goalId, amount, note);
    await loadGoals(goal.userId);
  }
}

final goalsProvider = StateNotifierProvider<GoalsNotifier, List<Goal>>((ref) {
  return GoalsNotifier(ref);
});

final totalSavedProvider = Provider<int>((ref) {
  final goals = ref.watch(goalsProvider);
  return goals.fold(0, (sum, goal) => sum + goal.balance);
});

final totalCapitalProvider = Provider<int>((ref) {
  final liquid = ref.watch(totalLiquidBalanceProvider);
  final saved = ref.watch(totalSavedProvider);
  return liquid + saved;
});

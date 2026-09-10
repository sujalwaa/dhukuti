import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/income.dart';
import '../../core/utils/formatters.dart';
import 'database_provider.dart';
import 'account_provider.dart';

class IncomesNotifier extends StateNotifier<List<Income>> {
  final Ref _ref;

  IncomesNotifier(this._ref) : super([]);

  Future<void> loadIncomes(String userId) async {
    final repo = _ref.read(incomeRepositoryProvider);
    state = await repo.getAll(userId);
  }

  Future<void> addIncome(Income income) async {
    final repo = _ref.read(incomeRepositoryProvider);
    await repo.create(income);
    
    // Update account balance
    final accountRepo = _ref.read(accountRepositoryProvider);
    final account = await accountRepo.getById(income.accountId);
    if (account != null) {
      final updatedAccount = account.copyWith(balance: account.balance + income.amount);
      await accountRepo.update(updatedAccount);
      await _ref.read(accountsProvider.notifier).loadAccounts(income.userId);
    }
    
    await loadIncomes(income.userId);
  }

  Future<void> delete(String incomeId) async {
    final repo = _ref.read(incomeRepositoryProvider);
    final income = state.firstWhere((i) => i.id == incomeId);
    
    // Reverse account balance
    final accountRepo = _ref.read(accountRepositoryProvider);
    final account = await accountRepo.getById(income.accountId);
    if (account != null) {
      final updatedAccount = account.copyWith(balance: account.balance - income.amount);
      await accountRepo.update(updatedAccount);
      await _ref.read(accountsProvider.notifier).loadAccounts(income.userId);
    }
    
    await repo.delete(incomeId);
    await loadIncomes(income.userId);
  }
}

final incomesProvider = StateNotifierProvider<IncomesNotifier, List<Income>>((ref) {
  return IncomesNotifier(ref);
});

final filteredIncomesProvider = Provider.family<List<Income>, String>((ref, period) {
  final incomes = ref.watch(incomesProvider);
  if (period == 'all') return incomes;
  
  final items = incomes.map((i) => i.toMap()).toList();
  final filteredItems = filterByPeriod(items, period, 'date');
  return filteredItems.map((map) => Income.fromMap(map)).toList();
});

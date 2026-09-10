import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/account.dart';
import 'database_provider.dart';

class AccountsNotifier extends StateNotifier<List<Account>> {
  final Ref _ref;

  AccountsNotifier(this._ref) : super([]);

  Future<void> loadAccounts(String userId) async {
    final repo = _ref.read(accountRepositoryProvider);
    state = await repo.getAll(userId);
  }

  Future<void> addAccount(Account account) async {
    final repo = _ref.read(accountRepositoryProvider);
    await repo.create(account);
    await loadAccounts(account.userId);
  }

  Future<void> update(Account account) async {
    final repo = _ref.read(accountRepositoryProvider);
    await repo.update(account);
    await loadAccounts(account.userId);
  }

  Future<void> delete(String accountId) async {
    final repo = _ref.read(accountRepositoryProvider);
    final account = state.firstWhere((a) => a.id == accountId);
    await repo.delete(accountId);
    await loadAccounts(account.userId);
  }

  Future<void> updateBalance(String accountId, int newBalance) async {
    final repo = _ref.read(accountRepositoryProvider);
    final account = state.firstWhere((a) => a.id == accountId);
    final updatedAccount = account.copyWith(balance: newBalance);
    await repo.update(updatedAccount);
    await loadAccounts(account.userId);
  }
}

final accountsProvider = StateNotifierProvider<AccountsNotifier, List<Account>>((ref) {
  return AccountsNotifier(ref);
});

final totalLiquidBalanceProvider = Provider<int>((ref) {
  final accounts = ref.watch(accountsProvider);
  return accounts.fold(0, (sum, account) => sum + account.balance);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/transaction.dart';
import '../../core/utils/formatters.dart';
import 'database_provider.dart';
import 'account_provider.dart';

class TransactionsNotifier extends StateNotifier<List<Transaction>> {
  final Ref _ref;

  TransactionsNotifier(this._ref) : super([]);

  Future<void> loadTransactions(String userId) async {
    final repo = _ref.read(transactionRepositoryProvider);
    state = await repo.getAll(userId);
  }

  Future<void> addTransaction(Transaction transaction) async {
    final repo = _ref.read(transactionRepositoryProvider);
    await repo.create(transaction);
    
    // Update account balance
    final accountRepo = _ref.read(accountRepositoryProvider);
    final account = await accountRepo.getById(transaction.accountId);
    if (account != null) {
      final updatedAccount = account.copyWith(balance: account.balance + transaction.amount);
      await accountRepo.update(updatedAccount);
      await _ref.read(accountsProvider.notifier).loadAccounts(transaction.userId);
    }
    
    await loadTransactions(transaction.userId);
  }

  Future<void> delete(String transactionId) async {
    final repo = _ref.read(transactionRepositoryProvider);
    final transaction = state.firstWhere((t) => t.id == transactionId);
    
    // Reverse account balance
    final accountRepo = _ref.read(accountRepositoryProvider);
    final account = await accountRepo.getById(transaction.accountId);
    if (account != null) {
      final updatedAccount = account.copyWith(balance: account.balance - transaction.amount);
      await accountRepo.update(updatedAccount);
      await _ref.read(accountsProvider.notifier).loadAccounts(transaction.userId);
    }
    
    await repo.delete(transactionId);
    await loadTransactions(transaction.userId);
  }

  Future<void> importTransactions(List<Transaction> transactions) async {
    for (final transaction in transactions) {
      await addTransaction(transaction);
    }
  }
}

final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<Transaction>>((ref) {
  return TransactionsNotifier(ref);
});

final filteredTransactionsProvider = Provider.family<List<Transaction>, String>((ref, period) {
  final transactions = ref.watch(transactionsProvider);
  if (period == 'all') return transactions;
  
  final items = transactions.map((t) => t.toMap()).toList();
  final filteredItems = filterByPeriod(items, period, 'date');
  return filteredItems.map((map) => Transaction.fromMap(map)).toList();
});

final searchedTransactionsProvider = Provider.family<List<Transaction>, String>((ref, query) {
  final transactions = ref.watch(transactionsProvider);
  if (query.isEmpty) return transactions;
  
  return transactions.where((t) => t.name.toLowerCase().contains(query.toLowerCase())).toList();
});

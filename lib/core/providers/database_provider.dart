import 'package:flutter_riverpod/flutter_riverpod.dart';

// Assuming these exist in data layer
import '../../data/local/database_helper.dart';
import '../../data/local/daos/account_dao.dart';
import '../../data/local/daos/transaction_dao.dart';
import '../../data/local/daos/income_dao.dart';
import '../../data/local/daos/category_dao.dart';
import '../../data/local/daos/goal_dao.dart';
import '../../data/local/daos/contribution_dao.dart';
import '../../data/local/daos/sync_queue_dao.dart';

import '../../data/repositories/account_repository.dart';
import '../../data/repositories/transaction_repository.dart';
import '../../data/repositories/income_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/goal_repository.dart';

/// DatabaseHelper provider that needs to be overridden in main.dart
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  throw UnimplementedError('databaseHelperProvider must be overridden in main.dart');
});

// DAOs
final accountDaoProvider = Provider<AccountDao>((ref) {
  return AccountDao(ref.watch(databaseHelperProvider));
});

final transactionDaoProvider = Provider<TransactionDao>((ref) {
  return TransactionDao(ref.watch(databaseHelperProvider));
});

final incomeDaoProvider = Provider<IncomeDao>((ref) {
  return IncomeDao(ref.watch(databaseHelperProvider));
});

final categoryDaoProvider = Provider<CategoryDao>((ref) {
  return CategoryDao(ref.watch(databaseHelperProvider));
});

final goalDaoProvider = Provider<GoalDao>((ref) {
  return GoalDao(ref.watch(databaseHelperProvider));
});

final contributionDaoProvider = Provider<ContributionDao>((ref) {
  return ContributionDao(ref.watch(databaseHelperProvider));
});

final syncQueueDaoProvider = Provider<SyncQueueDao>((ref) {
  return SyncQueueDao(ref.watch(databaseHelperProvider));
});

// Repositories
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepository(ref.watch(accountDaoProvider), ref.watch(syncQueueDaoProvider));
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(ref.watch(databaseHelperProvider), ref.watch(syncQueueDaoProvider));
});

final incomeRepositoryProvider = Provider<IncomeRepository>((ref) {
  return IncomeRepository(ref.watch(databaseHelperProvider), ref.watch(syncQueueDaoProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(databaseHelperProvider), ref.watch(syncQueueDaoProvider));
});

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository(ref.watch(databaseHelperProvider), ref.watch(syncQueueDaoProvider));
});


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_provider.dart';
import 'income_provider.dart';
import 'category_provider.dart';

final periodProvider = StateProvider<String>((ref) => 'this'); // 'this', 'last', 'all'

final periodExpensesProvider = Provider((ref) {
  final period = ref.watch(periodProvider);
  final transactions = ref.watch(filteredTransactionsProvider(period));
  return transactions.where((t) => t.amount < 0).toList();
});

final periodIncomesProvider = Provider((ref) {
  final period = ref.watch(periodProvider);
  return ref.watch(filteredIncomesProvider(period));
});

final totalExpensesProvider = Provider<int>((ref) {
  final expenses = ref.watch(periodExpensesProvider);
  return expenses.fold(0, (sum, t) => sum + t.amount.abs());
});

final totalIncomesProvider = Provider<int>((ref) {
  final incomes = ref.watch(periodIncomesProvider);
  return incomes.fold(0, (sum, i) => sum + i.amount);
});

final netIncomeProvider = Provider<int>((ref) {
  final totalIncome = ref.watch(totalIncomesProvider);
  final totalExpense = ref.watch(totalExpensesProvider);
  return totalIncome - totalExpense;
});

final savingsRateProvider = Provider<double>((ref) {
  final totalIncome = ref.watch(totalIncomesProvider);
  final totalExpense = ref.watch(totalExpensesProvider);
  if (totalIncome == 0) return 0.0;
  return ((totalIncome - totalExpense) / totalIncome) * 100;
});

class CategoryTotal {
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final int total;
  final double percentage;

  CategoryTotal({
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.total,
    required this.percentage,
  });
}

final categoryTotalsProvider = Provider<List<CategoryTotal>>((ref) {
  final expenses = ref.watch(periodExpensesProvider);
  final categories = ref.watch(categoriesProvider);
  final totalExpenses = ref.watch(totalExpensesProvider);

  if (totalExpenses == 0) return [];

  final map = <String, int>{};
  for (final expense in expenses) {
    map[expense.categoryId] = (map[expense.categoryId] ?? 0) + expense.amount.abs();
  }

  final result = map.entries.map((e) {
    final category = categories.firstWhere(
      (c) => c.id == e.key,
      orElse: () => throw Exception('Category not found'),
    );
    return CategoryTotal(
      categoryId: category.id,
      categoryName: category.name,
      categoryIcon: category.icon,
      categoryColor: category.color,
      total: e.value,
      percentage: (e.value / totalExpenses) * 100,
    );
  }).toList();

  result.sort((a, b) => b.total.compareTo(a.total));
  return result;
});

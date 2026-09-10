import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/category.dart';
import 'database_provider.dart';

class CategoriesNotifier extends StateNotifier<List<Category>> {
  final Ref _ref;

  CategoriesNotifier(this._ref) : super([]);

  Future<void> loadCategories(String userId) async {
    final repo = _ref.read(categoryRepositoryProvider);
    state = await repo.getAll(userId);
  }

  Future<void> addCategory(Category category) async {
    final repo = _ref.read(categoryRepositoryProvider);
    await repo.create(category);
    await loadCategories(category.userId);
  }

  Future<void> update(Category category) async {
    final repo = _ref.read(categoryRepositoryProvider);
    await repo.update(category);
    await loadCategories(category.userId);
  }

  Future<void> delete(String categoryId) async {
    final repo = _ref.read(categoryRepositoryProvider);
    final category = state.firstWhere((c) => c.id == categoryId);
    await repo.delete(categoryId);
    await loadCategories(category.userId);
  }
}

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, List<Category>>((ref) {
  return CategoriesNotifier(ref);
});

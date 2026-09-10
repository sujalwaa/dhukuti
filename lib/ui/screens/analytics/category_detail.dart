import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/analytics_provider.dart';
import '../../../core/providers/transaction_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../widgets/modal_wrapper.dart';
import '../../widgets/amount_display.dart';
import '../../widgets/icon_render.dart';

class CategoryDetail extends ConsumerWidget {
  final CategoryTotal categoryTotal;

  const CategoryDetail({super.key, required this.categoryTotal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(periodProvider);
    final allTransactions = ref.watch(filteredTransactionsProvider(period));
    final transactions = allTransactions.where((t) => t.categoryId == categoryTotal.categoryId).toList();

    return ModalWrapper(
      title: categoryTotal.categoryName,
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Color(int.parse(categoryTotal.categoryColor.replaceAll('#', '0xFF'))).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: IconRender(
                name: categoryTotal.categoryIcon,
                size: 28,
                color: Color(int.parse(categoryTotal.categoryColor.replaceAll('#', '0xFF'))),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AmountDisplay(
            paisa: categoryTotal.total,
            size: AmountSize.hero,
            isHidden: false,
          ),
          const SizedBox(height: 8),
          Text(
            '${transactions.length} transactions · ${period == 'this' ? 'This month' : period == 'last' ? 'Last month' : 'All time'}',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 32),
          if (transactions.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  const IconRender(name: 'receipt', size: 48, color: AppColors.textDisabled),
                  const SizedBox(height: 16),
                  Text('No transactions found.', style: AppTypography.bodySmall),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
              child: Column(
                children: transactions.map((t) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.mutedSurface,
                                borderRadius: BorderRadius.circular(AppRadii.iconTile),
                              ),
                              child: const Center(
                                child: IconRender(
                                  name: 'receipt',
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t.name, style: AppTypography.transactionName),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatDate(t.date.toIso8601String()),
                                    style: AppTypography.timestamp,
                                  ),
                                ],
                              ),
                            ),
                            AmountDisplay(
                              paisa: t.amount,
                              size: AmountSize.transaction,
                              isHidden: false,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.lightDivider),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/account_provider.dart';
import '../../../core/providers/goal_provider.dart';
import '../../../core/providers/income_provider.dart';
import '../../widgets/modal_wrapper.dart';
import '../../widgets/amount_display.dart';
import '../../widgets/sources_bar.dart';

class CapitalSheet extends ConsumerWidget {
  const CapitalSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalCapital = ref.watch(totalCapitalProvider);
    final totalLiquid = ref.watch(totalLiquidBalanceProvider);
    final totalSaved = ref.watch(totalSavedProvider);
    final accounts = ref.watch(accountsProvider);
    final incomes = ref.watch(incomesProvider);

    return ModalWrapper(
      title: 'My capital',
      child: Column(
        children: [
          const SizedBox(height: 24),
          AmountDisplay(
            paisa: totalCapital,
            size: AmountSize.hero,
            isHidden: false,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text('+6.3% this month', style: TextStyle(color: AppColors.success, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.mutedSurface,
                      borderRadius: BorderRadius.circular(AppRadii.standardCard),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Liquid', style: AppTypography.sectionLabel),
                        const SizedBox(height: 8),
                        AmountDisplay(paisa: totalLiquid, size: AmountSize.card),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.mutedSurface,
                      borderRadius: BorderRadius.circular(AppRadii.standardCard),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Goals', style: AppTypography.sectionLabel),
                        const SizedBox(height: 8),
                        AmountDisplay(paisa: totalSaved, size: AmountSize.card),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Accounts', style: AppTypography.sectionLabel),
                const SizedBox(height: 16),
                SourcesBar(
                  height: 10,
                  segments: accounts.map((a) => SourceSegment(
                    amount: a.balance.toDouble(),
                    color: Color(int.parse(a.color.replaceAll('#', '0xFF'))),
                  )).toList(),
                ),
                const SizedBox(height: 24),
                ...accounts.map((a) {
                  final color = Color(int.parse(a.color.replaceAll('#', '0xFF')));
                  final percentage = totalLiquid > 0 ? (a.balance / totalLiquid) * 100 : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                        const SizedBox(width: 12),
                        Text(a.name, style: AppTypography.body),
                        const SizedBox(width: 8),
                        Text('${percentage.toStringAsFixed(1)}%', style: AppTypography.bodySmall),
                        const Spacer(),
                        AmountDisplay(paisa: a.balance, size: AmountSize.transaction),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Recent incomes', style: AppTypography.sectionLabel),
                const SizedBox(height: 16),
                if (incomes.isEmpty)
                  Text('No recent incomes', style: AppTypography.bodySmall)
                else
                  ...incomes.take(5).map((inc) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(inc.name, style: AppTypography.body),
                        AmountDisplay(paisa: inc.amount, size: AmountSize.transaction),
                      ],
                    ),
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

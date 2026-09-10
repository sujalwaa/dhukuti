import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/analytics_provider.dart';
import '../../widgets/amount_display.dart';
import '../../widgets/donut_chart.dart';
import 'category_detail.dart';

class AnalyticsTab extends ConsumerStatefulWidget {
  const AnalyticsTab({super.key});

  @override
  ConsumerState<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends ConsumerState<AnalyticsTab> {
  @override
  Widget build(BuildContext context) {
    final currentPeriod = ref.watch(periodProvider);
    final totalIncomes = ref.watch(totalIncomesProvider);
    final totalExpenses = ref.watch(totalExpensesProvider);
    final netIncome = ref.watch(netIncomeProvider);
    final savingsRate = ref.watch(savingsRateProvider);
    final categoryTotals = ref.watch(categoryTotalsProvider);

    return Scaffold(
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Analytics', style: AppTypography.pageTitle),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Icon(PhosphorIcons.gear(), size: 16, color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),

              // 2. Period toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColors.mutedSurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _buildPeriodTab('this', 'This month', currentPeriod),
                      _buildPeriodTab('last', 'Last month', currentPeriod),
                      _buildPeriodTab('all', 'All time', currentPeriod),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Income/Expenses stat cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppShadows.standardCard,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(8)),
                                  child: Icon(PhosphorIcons.arrowDownLeft(), color: AppColors.success, size: 16),
                                ),
                                const SizedBox(width: 8),
                                const Text('Income', style: AppTypography.sectionLabel),
                              ],
                            ),
                            const SizedBox(height: 12),
                            AmountDisplay(paisa: totalIncomes, size: AmountSize.card),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppShadows.standardCard,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: AppColors.dangerBg, borderRadius: BorderRadius.circular(8)),
                                  child: Icon(PhosphorIcons.arrowUpRight(), color: AppColors.danger, size: 16),
                                ),
                                const SizedBox(width: 8),
                                const Text('Expenses', style: AppTypography.sectionLabel),
                              ],
                            ),
                            const SizedBox(height: 12),
                            AmountDisplay(paisa: totalExpenses, size: AmountSize.card),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. Net Income dark card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [AppColors.heroGradientStart, AppColors.heroGradientMid, AppColors.heroGradientEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: AppShadows.analyticsNetIncome,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: AppColors.heroPurpleGlow, blurRadius: 40, spreadRadius: 10),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Net Income', style: AppTypography.sectionLabelUpper.copyWith(color: Colors.white70)),
                              const SizedBox(height: 8),
                              Text(
                                'रु ${(netIncome / 100).toStringAsFixed(2)}',
                                style: AppTypography.analyticsNetIncome,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(PhosphorIcons.trendUp(), color: AppColors.success, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${savingsRate.toStringAsFixed(1)}%',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Expenses by category card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.analyticsDonut),
                    boxShadow: AppShadows.elevatedCard,
                  ),
                  child: Column(
                    children: [
                      const Text('Expenses by category', style: AppTypography.modalTitle),
                      const SizedBox(height: 32),
                      if (categoryTotals.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('No expenses in this period.'),
                        )
                      else ...[
                        DonutChart(
                          size: 190,
                          strokeWidth: 32,
                          data: categoryTotals.map((c) => DonutSegment(
                            value: c.total.toDouble(),
                            color: Color(int.parse(c.categoryColor.replaceAll('#', '0xFF'))),
                          )).toList(),
                          centerWidget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Total', style: AppTypography.sectionLabelUpper),
                              const SizedBox(height: 4),
                              Text('रु ${(totalExpenses / 100).toStringAsFixed(0)}', style: AppTypography.donutCenterAmount),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        ...categoryTotals.map((c) => GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              
                              builder: (context) => CategoryDetail(categoryTotal: c),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(c.categoryColor.replaceAll('#', '0xFF'))),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: Text(c.categoryName, style: AppTypography.body)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.mutedSurface,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('${c.percentage.toStringAsFixed(1)}%', style: AppTypography.bodySmall),
                                ),
                                const SizedBox(width: 12),
                                Text('रु ${(c.total / 100).toStringAsFixed(0)}', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(width: 8),
                                Icon(PhosphorIcons.caretRight(), size: 16, color: AppColors.textPlaceholder),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.scrollBottomPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodTab(String id, String label, String currentPeriod) {
    final isActive = id == currentPeriod;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(periodProvider.notifier).state = id;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive ? AppShadows.activeToggle : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? AppColors.textPrimary : AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}

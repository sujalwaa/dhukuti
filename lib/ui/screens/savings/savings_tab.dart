import '../../../core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/providers/goal_provider.dart';
import '../../../core/providers/account_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../widgets/progress_ring.dart';
import '../../widgets/icon_render.dart';
import 'goal_detail.dart';
import 'create_goal_sheet.dart';

class SavingsTab extends ConsumerStatefulWidget {
  const SavingsTab({super.key});

  @override
  ConsumerState<SavingsTab> createState() => _SavingsTabState();
}

class _SavingsTabState extends ConsumerState<SavingsTab> {
  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalsProvider);
    final totalSaved = ref.watch(totalSavedProvider);
    final totalTarget = goals.fold<int>(0, (sum, goal) => sum + goal.target);
    final double percentage = totalTarget > 0 ? totalSaved / totalTarget : 0.0;
    
    int autoSavingAmount = 0;
    int autoGoalsCount = 0;
    for (final g in goals) {
      if (g.autoEnabled) {
        autoSavingAmount += g.autoAmount;
        autoGoalsCount++;
      }
    }

    return Scaffold(
      
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Savings', style: AppTypography.contributeAmount),
                    IconButton(
                      icon: const Icon(PhosphorIconsRegular.gear, color: AppColors.textPrimary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.heroGradientStart, AppColors.heroGradientEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL SAVED ACROSS GOALS',
                        style: AppTypography.timestamp.copyWith(color: AppColors.textDisabled, fontSize: 11),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        formatAmount(totalSaved).full,
                        style: AppTypography.contributeAmount.copyWith(color: AppColors.surface, fontWeight: FontWeight.w800, fontSize: 30),
                      ),
                      Text(
                        'of ${formatAmount(totalTarget).full} target',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppColors.surface.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: percentage.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(color: AppColors.success.withOpacity(0.5), blurRadius: 6, spreadRadius: 1),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '${(percentage * 100).toStringAsFixed(0)}%',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.surface, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (autoGoalsCount > 0) ...[
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            const Icon(PhosphorIconsFill.lightning, color: AppColors.warning, size: 16),
                            const SizedBox(width: 4.0),
                            Text(
                              'Auto-saving ${formatAmount(autoSavingAmount).full}/mo across $autoGoalsCount goals',
                              style: AppTypography.timestamp.copyWith(color: AppColors.surface),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (goals.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(PhosphorIconsRegular.info, color: AppColors.info),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Create virtual pots to save for specific goals without opening new bank accounts.',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Text('Your goals', style: AppTypography.pageTitle),
                    const SizedBox(width: 4.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('${goals.length}', style: AppTypography.timestamp.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final goal = goals[index];
                  final goalPercentage = goal.target > 0 ? goal.balance / goal.target : 0.0;
                  final accountList = ref.watch(accountsProvider);
                  final account = accountList.firstWhere((a) => a.id == goal.sourceAccountId, orElse: () => throw Exception('Account not found'));
                  final color = Color(int.parse(goal.color.replaceAll('#', '0xFF')));
                  final accountColor = Color(int.parse(account.color.replaceAll('#', '0xFF')));

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => GoalDetail(goalId: goal.id)));
                      },
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
                                ProgressRing(
                                  size: 50,
                                  thickness: 4,
                                  progress: goalPercentage,
                                  color: color,
                                  
                                  child: IconRender(name: goal.icon, color: color, size: 24),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(goal.name, style: AppTypography.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                                          ),
                                          if (goal.autoEnabled)
                                            const Icon(PhosphorIconsFill.lightning, color: AppColors.warning, size: 16),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${formatAmount(goal.balance).full} saved · ${formatAmount(goal.target - goal.balance).full} to go',
                                        style: AppTypography.timestamp.copyWith(color: const Color(0xFFAAAAAA), fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${(goalPercentage * 100).toStringAsFixed(0)}%',
                                    style: AppTypography.timestamp.copyWith(color: color, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.border,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: goalPercentage.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: accountColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'From ${account.name}',
                                  style: AppTypography.timestamp.copyWith(color: const Color(0xFFAAAAAA), fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: goals.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      
                      builder: (_) => const CreateGoalSheet(),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.canvas,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.textPlaceholder, style: BorderStyle.solid), // Dashboard dash pattern alternative
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(PhosphorIconsRegular.plus, color: AppColors.textSecondary),
                        const SizedBox(width: 4.0),
                        Text('Create new savings goal', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

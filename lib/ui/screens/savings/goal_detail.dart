import '../../../core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/goal_provider.dart';
import '../../../core/providers/account_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../widgets/progress_ring.dart';
import '../../widgets/icon_render.dart';
import 'contribute_sheet.dart';

class GoalDetail extends ConsumerWidget {
  final String goalId;
  const GoalDetail({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);
    final goal = goals.firstWhere((g) => g.id == goalId, orElse: () => throw Exception('Goal not found'));
    final account = ref.watch(accountsProvider).firstWhere((a) => a.id == goal.sourceAccountId);
    
    final color = Color(int.parse(goal.color.replaceAll('#', '0xFF')));
    final percentage = goal.target > 0 ? goal.balance / goal.target : 0.0;
    
    int monthsToGoal = 0;
    if (goal.autoEnabled && goal.autoAmount > 0) {
      final remaining = goal.target - goal.balance;
      if (remaining > 0) {
        monthsToGoal = (remaining / goal.autoAmount).ceil();
      }
    }

    return Scaffold(
      
      appBar: AppBar(
        
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.caretLeft, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.pencilSimple, color: AppColors.textPrimary),
            onPressed: () {
              // Open edit
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.8), color],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    ProgressRing(
                      size: 90,
                      thickness: 6,
                      progress: percentage,
                      color: AppColors.surface,
                      child: IconRender(name: goal.icon, color: AppColors.surface, size: 40),
                    ),
                    const SizedBox(height: 16.0),
                    Text('Saved', style: AppTypography.timestamp.copyWith(color: AppColors.surface.withOpacity(0.8))),
                    Text(
                      formatAmount(goal.balance).full,
                      style: AppTypography.contributeAmount.copyWith(color: AppColors.surface, fontWeight: FontWeight.w800, fontSize: 30),
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'of ${formatAmount(goal.target).full} • ${(percentage * 100).toStringAsFixed(0)}%',
                        style: AppTypography.timestamp.copyWith(color: AppColors.surface, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        
                        foregroundColor: AppColors.surface,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      icon: const Icon(PhosphorIconsRegular.plus),
                      label: const Text('Contribute'),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          
                          builder: (_) => ContributeSheet(goalId: goalId, isDeposit: true),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      icon: const Icon(PhosphorIconsRegular.minus),
                      label: const Text('Withdraw'),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          
                          builder: (_) => ContributeSheet(goalId: goalId, isDeposit: false),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('REMAINING', style: AppTypography.timestamp.copyWith(color: AppColors.textPlaceholder)),
                          const SizedBox(height: 4),
                          Text(formatAmount(goal.target - goal.balance).full, style: AppTypography.body),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AT CURRENT PACE', style: AppTypography.timestamp.copyWith(color: AppColors.textPlaceholder)),
                          const SizedBox(height: 4),
                          Text(monthsToGoal > 0 ? '$monthsToGoal months' : 'N/A', style: AppTypography.body),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              if (goal.autoEnabled)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(PhosphorIconsFill.lightning, color: AppColors.warning),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'Auto-contributing ${formatAmount(goal.autoAmount).full} on the ${goal.autoDayOfMonth}th of every month.',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24.0),
              Text('Danger zone', style: AppTypography.body.copyWith(color: AppColors.danger)),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: () {
                  // Confirmation logic
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.dangerBgLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.danger.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(PhosphorIconsRegular.trash, color: AppColors.danger),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'Delete goal',
                          style: AppTypography.body.copyWith(color: AppColors.danger),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

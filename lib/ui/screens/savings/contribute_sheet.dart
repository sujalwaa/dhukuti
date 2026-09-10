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
import '../../widgets/bottom_sheet_wrapper.dart';
import '../../widgets/numpad.dart';

class ContributeSheet extends ConsumerStatefulWidget {
  final String goalId;
  final bool isDeposit;

  const ContributeSheet({super.key, required this.goalId, required this.isDeposit});

  @override
  ConsumerState<ContributeSheet> createState() => _ContributeSheetState();
}

class _ContributeSheetState extends ConsumerState<ContributeSheet> {
  String amountStr = '0';
  String note = '';

  @override
  Widget build(BuildContext context) {
    final goal = ref.watch(goalsProvider).firstWhere((g) => g.id == widget.goalId);
    final account = ref.watch(accountsProvider).firstWhere((a) => a.id == goal.sourceAccountId);
    
    final int amount = int.tryParse(amountStr) ?? 0;
    final int maxAmount = widget.isDeposit ? account.balance : goal.balance;
    final bool exceeds = amount > maxAmount;
    final bool isValid = amount > 0 && !exceeds;

    final color = widget.isDeposit ? Color(int.parse(goal.color.replaceAll('#', '0xFF'))) : AppColors.textPrimary;

    return BottomSheetWrapper(
      title: widget.isDeposit ? 'Contribute to ${goal.name}' : 'Withdraw from ${goal.name}',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.isDeposit ? account.name : goal.name, style: AppTypography.body),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(PhosphorIconsRegular.arrowRight, size: 16, color: AppColors.textMuted),
              ),
              Text(widget.isDeposit ? goal.name : account.name, style: AppTypography.body),
            ],
          ),
          const SizedBox(height: 32.0),
          Text(
            formatAmount(amount).full,
            style: AppTypography.contributeAmount.copyWith(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: exceeds ? AppColors.danger : AppColors.textPrimary,
            ),
          ),
          if (exceeds)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Amount exceeds available balance',
                style: AppTypography.timestamp.copyWith(color: AppColors.danger),
              ),
            ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              onChanged: (val) => note = val,
              decoration: const InputDecoration(
                hintText: 'Add a note',
                border: InputBorder.none,
                filled: true,
                fillColor: AppColors.mutedSurface,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Numpad(
            onKey: (val) {
              setState(() {
                if (val == '<') {
                  if (amountStr.length > 1) {
                    amountStr = amountStr.substring(0, amountStr.length - 1);
                  } else {
                    amountStr = '0';
                  }
                } else if (val == '.') {
                  // Ignore decimals as amount is in paisa
                } else {
                  if (amountStr == '0') {
                    amountStr = val;
                  } else {
                    amountStr += val;
                  }
                }
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isValid ? () async {
                  if (widget.isDeposit) {
                    await ref.read(goalsProvider.notifier).contribute(goal.id, amount, note);
                  } else {
                    await ref.read(goalsProvider.notifier).withdraw(goal.id, amount, note);
                  }
                  Navigator.pop(context);
                } : null,
                style: ElevatedButton.styleFrom(
                  
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Submit', style: TextStyle(color: isValid ? Colors.white : AppColors.textPrimary)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

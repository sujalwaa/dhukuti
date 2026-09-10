import '../../../core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/goal_provider.dart';
import '../../../core/providers/account_provider.dart';
import '../../../data/models/goal.dart';
import '../../../data/models/account.dart';
import '../../widgets/bottom_sheet_wrapper.dart';
import '../../widgets/toggle_switch.dart';

class CreateGoalSheet extends ConsumerStatefulWidget {
  const CreateGoalSheet({super.key});

  @override
  ConsumerState<CreateGoalSheet> createState() => _CreateGoalSheetState();
}

class _CreateGoalSheetState extends ConsumerState<CreateGoalSheet> {
  String name = '';
  int target = 0;
  String colorHex = '#34C759';
  String iconStr = 'target';
  Account? sourceAccount;
  int initialDeposit = 0;
  bool autoEnabled = false;
  int autoAmount = 0;
  int autoDay = 1;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _autoAmountController = TextEditingController();

  final List<String> colors = AppColors.selectablePalette.map((c) => '#${c.value.toRadixString(16).padLeft(8, '0').substring(2)}').toList();
  final List<String> icons = ['target', 'house', 'car', 'airplane', 'graduation_cap', 'heart', 'piggy_bank', 'gift'];

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      title: 'Create new goal',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              onChanged: (val) => setState(() => name = val),
              decoration: const InputDecoration(labelText: 'Goal Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              onChanged: (val) => setState(() => target = int.tryParse(val) ?? 0),
              decoration: const InputDecoration(labelText: 'Target Amount', border: OutlineInputBorder(), prefixText: 'रु '),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: const Text('Source Account'),
              subtitle: Text(sourceAccount?.name ?? 'Select account'),
              trailing: const Icon(PhosphorIconsRegular.caretRight),
              onTap: () async {
                final accounts = ref.read(accountsProvider);
                if (accounts.isNotEmpty) {
                  setState(() => sourceAccount = accounts.first);
                }
              },
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _depositController,
              keyboardType: TextInputType.number,
              onChanged: (val) => setState(() => initialDeposit = int.tryParse(val) ?? 0),
              decoration: const InputDecoration(labelText: 'Initial Deposit (Optional)', border: OutlineInputBorder(), prefixText: 'रु '),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Auto-contribute', style: AppTypography.body),
                ToggleSwitch(
                  value: autoEnabled,
                  onChanged: (val) => setState(() => autoEnabled = val),
                ),
              ],
            ),
            if (autoEnabled) ...[
              const SizedBox(height: 8.0),
              TextField(
                controller: _autoAmountController,
                keyboardType: TextInputType.number,
                onChanged: (val) => setState(() => autoAmount = int.tryParse(val) ?? 0),
                decoration: const InputDecoration(labelText: 'Monthly Amount', border: OutlineInputBorder(), prefixText: 'रु '),
              ),
            ],
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (name.isNotEmpty && target > 0 && sourceAccount != null) ? () {
                  final goal = Goal(
                    id: const Uuid().v4(),
                    userId: 'default_user',
                    name: name,
                    target: target,
                    icon: iconStr,
                    color: colorHex,
                    sourceAccountId: sourceAccount!.id,
                    balance: 0,
                    autoEnabled: autoEnabled,
                    autoAmount: autoAmount,
                    autoDayOfMonth: autoDay,
                  );
                  ref.read(goalsProvider.notifier).createGoal(goal, initialDeposit);
                  Navigator.pop(context);
                } : null,
                style: ElevatedButton.styleFrom(
                  
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Create goal', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}

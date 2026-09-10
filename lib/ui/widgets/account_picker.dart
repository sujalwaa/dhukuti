import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'icon_render.dart';
import 'bottom_sheet_wrapper.dart';
import 'amount_display.dart';

class AccountInfo {
  final String id;
  final String name;
  final int balancePaisa;
  final String icon;
  final Color color;

  const AccountInfo({
    required this.id,
    required this.name,
    required this.balancePaisa,
    required this.icon,
    required this.color,
  });
}

/// Bottom sheet listing all accounts.
class AccountPicker extends StatelessWidget {
  final String title;
  final List<AccountInfo> accounts;
  final String? selectedAccountId;
  final ValueChanged<AccountInfo> onSelect;

  const AccountPicker({
    super.key,
    this.title = 'Select Account',
    required this.accounts,
    this.selectedAccountId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: AppTypography.pageTitle),
        const SizedBox(height: 16),
        ...accounts.map((account) {
          final isSelected = account.id == selectedAccountId;
          return GestureDetector(
            onTap: () {
              onSelect(account);
              Navigator.of(context).pop();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? account.color.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? Border.all(color: account.color, width: 2) : Border.all(color: Colors.transparent, width: 2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: account.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: IconRender(
                        name: account.icon,
                        color: account.color,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(account.name, style: AppTypography.body),
                        AmountDisplay(paisa: account.balancePaisa, size: AmountSize.transaction),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(PhosphorIcons.checkCircle(), color: account.color),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

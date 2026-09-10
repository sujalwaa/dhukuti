import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/constants.dart';
import 'icon_render.dart';

class ItemData {
  final String name;
  final String balance;
  final Color color;
  final String icon;

  const ItemData({
    required this.name,
    required this.balance,
    required this.color,
    required this.icon,
  });
}

/// Generic form for creating/editing accounts, categories.
class ItemEditor extends StatefulWidget {
  final ItemData? initialData;
  final bool showBalance;
  final ValueChanged<ItemData> onSave;
  final VoidCallback onCancel;
  final VoidCallback? onDelete;

  const ItemEditor({
    super.key,
    this.initialData,
    this.showBalance = true,
    required this.onSave,
    required this.onCancel,
    this.onDelete,
  });

  @override
  State<ItemEditor> createState() => _ItemEditorState();
}

class _ItemEditorState extends State<ItemEditor> {
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late Color _selectedColor;
  late String _selectedIcon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData?.name ?? '');
    _balanceController = TextEditingController(text: widget.initialData?.balance ?? '');
    _selectedColor = widget.initialData?.color ?? AppColors.selectablePalette[0];
    _selectedIcon = widget.initialData?.icon ?? AppConstants.iconOptions[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.inputField),
            ),
          ),
        ),
        if (widget.showBalance) ...[
          const SizedBox(height: 16),
          TextField(
            controller: _balanceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Balance',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.inputField),
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        Text('Color', style: AppTypography.sectionLabel),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AppColors.selectablePalette.map((color) {
            final isSelected = color == _selectedColor;
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: const Color(0xFF333333), width: 3) : null,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text('Icon', style: AppTypography.sectionLabel),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: AppConstants.iconOptions.map((icon) {
            final isSelected = icon == _selectedIcon;
            return GestureDetector(
              onTap: () => setState(() => _selectedIcon = icon),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected ? _selectedColor.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: IconRender(
                    name: icon,
                    size: 20,
                    color: isSelected ? _selectedColor : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            if (widget.onDelete != null) ...[
              GestureDetector(
                onTap: widget.onDelete,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.dangerBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(PhosphorIcons.trash(), color: AppColors.danger),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: TextButton(
                onPressed: widget.onCancel,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancel', style: TextStyle(color: AppColors.textPrimary)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextButton(
                onPressed: () {
                  widget.onSave(ItemData(
                    name: _nameController.text,
                    balance: _balanceController.text,
                    color: _selectedColor,
                    icon: _selectedIcon,
                  ));
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

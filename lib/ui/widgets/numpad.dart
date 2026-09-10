import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// A 3x4 grid numpad for entering amounts.
class Numpad extends StatelessWidget {
  final ValueChanged<String> onKey;

  const Numpad({super.key, required this.onKey});

  @override
  Widget build(BuildContext context) {
    final keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      '.', '0', 'back'
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 4; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i < 3 ? 7.0 : 0.0),
            child: Row(
              children: [
                for (int j = 0; j < 3; j++) ...[
                  Expanded(
                    child: _buildKey(keys[i * 3 + j]),
                  ),
                  if (j < 2) const SizedBox(width: 7),
                ]
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildKey(String keyVal) {
    return Material(
      color: AppColors.numpadKey,
      borderRadius: BorderRadius.circular(AppRadii.numpadKey),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.numpadKey),
        onTap: () => onKey(keyVal),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          alignment: Alignment.center,
          child: keyVal == 'back'
              ? Icon(PhosphorIcons.backspace(), color: AppColors.textPrimary)
              : Text(
                  keyVal,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
        ),
      ),
    );
  }
}

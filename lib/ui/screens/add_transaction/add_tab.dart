import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/numpad.dart';

class AddTab extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  const AddTab({super.key, required this.onClose});

  @override
  ConsumerState<AddTab> createState() => _AddTabState();
}

class _AddTabState extends ConsumerState<AddTab> {
  String type = 'expense';
  String amountStr = '0';
  String description = '';
  bool isSuccess = false;

  void _onNumpadTap(String value) {
    setState(() {
      if (value == 'backspace') {
        if (amountStr.length > 1) {
          amountStr = amountStr.substring(0, amountStr.length - 1);
        } else {
          amountStr = '0';
        }
      } else if (value == '.') {
        if (!amountStr.contains('.')) amountStr += '.';
      } else {
        if (amountStr == '0') {
          amountStr = value;
        } else {
          final parts = amountStr.split('.');
          if (parts.length == 2 && parts[1].length >= 2) return;
          amountStr += value;
        }
      }
    });
  }

  void _submit() {
    if (amountStr == '0' || amountStr == '0.0' || amountStr == '0.00') return;
    setState(() => isSuccess = true);
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAmountZero = amountStr == '0' || amountStr == '0.0' || amountStr == '0.00';
    
    return Scaffold(
      
      appBar: AppBar(
        
        elevation: 0,
        title: const Text('Add transaction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black)),
        actions: [
          IconButton(
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF5F5F5)),
              child: const Icon(PhosphorIconsRegular.x, size: 16, color: Colors.black),
            ),
            onPressed: widget.onClose,
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('expense'),
                selected: type == 'expense',
                onSelected: (val) => setState(() => type = 'expense'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('income'),
                selected: type == 'income',
                onSelected: (val) => setState(() => type = 'income'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'रु $amountStr',
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: const InputDecoration(hintText: 'Description'),
              onChanged: (val) => description = val,
            ),
          ),
          const Spacer(),
          Numpad(onKey: _onNumpadTap),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  
                  disabledBackgroundColor: Colors.grey.withOpacity(0.4),
                ),
                onPressed: isAmountZero || isSuccess ? null : _submit,
                child: isSuccess
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(PhosphorIconsRegular.check, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Added!', style: TextStyle(color: Colors.white)),
                        ],
                      )
                    : Text('Add $type', style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

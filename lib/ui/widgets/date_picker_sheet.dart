import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Calendar bottom sheet.
class DatePickerSheet extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onSelect;

  const DatePickerSheet({
    super.key,
    required this.initialDate,
    required this.onSelect,
  });

  @override
  State<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  void _changeMonth(int offset) {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + offset);
    });
  }

  void _selectDate(DateTime date) {
    if (date.isAfter(DateTime.now())) return;
    setState(() => _selectedDate = date);
    widget.onSelect(date);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(_displayedMonth.year, _displayedMonth.month);
    final firstDayOffset = DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday % 7;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Quick chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickChip('Today', now),
              const SizedBox(width: 8),
              _buildQuickChip('Yesterday', now.subtract(const Duration(days: 1))),
              const SizedBox(width: 8),
              _buildQuickChip('2 days ago', now.subtract(const Duration(days: 2))),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(PhosphorIcons.caretLeft()),
              onPressed: () => _changeMonth(-1),
            ),
            Text(
              DateFormat('MMMM yyyy').format(_displayedMonth),
              style: AppTypography.pageTitle,
            ),
            IconButton(
              icon: Icon(PhosphorIcons.caretRight()),
              onPressed: _displayedMonth.year == now.year && _displayedMonth.month == now.month 
                ? null 
                : () => _changeMonth(1),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].map((day) {
            return Expanded(
              child: Center(
                child: Text(day, style: AppTypography.weekdayHeader),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // Day grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: 42, // 6 rows of 7 days
          itemBuilder: (context, index) {
            final day = index - firstDayOffset + 1;
            if (day <= 0 || day > daysInMonth) return const SizedBox.shrink();

            final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
            final isFuture = date.isAfter(DateTime(now.year, now.month, now.day));
            final isSelected = date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;
            final isToday = date.year == now.year && date.month == now.month && date.day == now.day;

            BoxDecoration decoration = const BoxDecoration();
            TextStyle textStyle = AppTypography.calendarDay;

            if (isSelected) {
              decoration = const BoxDecoration(color: Color(0xFF111111), shape: BoxShape.circle);
              textStyle = textStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w700);
            } else if (isToday) {
              decoration = const BoxDecoration(color: Color(0xFFF0F0F0), shape: BoxShape.circle);
              textStyle = textStyle.copyWith(fontWeight: FontWeight.w600);
            } else if (isFuture) {
              textStyle = textStyle.copyWith(color: const Color(0xFFDDDDDD));
            }

            return GestureDetector(
              onTap: isFuture ? null : () => _selectDate(date),
              child: Container(
                decoration: decoration,
                child: Center(
                  child: Text(day.toString(), style: textStyle),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickChip(String label, DateTime date) {
    final isSelected = date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;
    return GestureDetector(
      onTap: () => _selectDate(date),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF111111) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTypography.quickChip.copyWith(
            color: isSelected ? Colors.white : const Color(0xFF555555),
          ),
        ),
      ),
    );
  }
}

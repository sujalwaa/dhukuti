import 'package:intl/intl.dart';
import 'constants.dart';

/// Format amount from paisa to display string
/// Takes paisa (int), returns formatted parts
class AmountParts {
  final String sign;
  final String integer;
  final String decimal;
  final String symbol;

  AmountParts({
    required this.sign,
    required this.integer,
    required this.decimal,
    required this.symbol,
  });

  String get full => '$sign$symbol$integer.$decimal';
}

AmountParts formatAmount(int paisa, {String currency = 'NPR'}) {
  final info = AppConstants.currencies[currency] ?? AppConstants.currencies['NPR']!;
  final rate = info.rate;
  final symbol = info.symbol;

  final isNegative = paisa < 0;
  final sign = isNegative ? '-' : '';

  final amountValue = (paisa.abs() / 100) * rate;
  final amountString = amountValue.toStringAsFixed(2);

  final parts = amountString.split('.');
  final integerPart = parts[0];
  final decimalPart = parts[1];

  // Format integer part with commas using intl
  final formatter = NumberFormat("#,##0", "en_US");
  final formattedInt = formatter.format(int.parse(integerPart));

  return AmountParts(
    sign: sign,
    integer: formattedInt,
    decimal: decimalPart,
    symbol: symbol,
  );
}

/// Format date relative to now
/// Within 24h -> "Today at 1:30 pm"
/// Within 48h -> "Yesterday at 1:30 pm"
/// Otherwise -> "15 Apr at 1:30 pm"
String formatDate(String isoDate) {
  final date = DateTime.parse(isoDate).toLocal();
  final now = DateTime.now();
  final isToday = now.day == date.day && now.month == date.month && now.year == date.year;
  
  final yesterday = now.subtract(const Duration(days: 1));
  final isYesterday = yesterday.day == date.day && yesterday.month == date.month && yesterday.year == date.year;

  final timeFormat = DateFormat('h:mm a');
  if (isToday) {
    return 'Today at ${timeFormat.format(date)}';
  } else if (isYesterday) {
    return 'Yesterday at ${timeFormat.format(date)}';
  } else {
    final dateFormat = DateFormat('d MMM');
    return '${dateFormat.format(date)} at ${timeFormat.format(date)}';
  }
}

/// Short date: "15 Apr 26"
String formatShortDate(String isoDate) {
  final date = DateTime.parse(isoDate).toLocal();
  return DateFormat('d MMM yy').format(date);
}

/// Get month range for period filtering
/// offset 0 = current month, -1 = last month
({DateTime start, DateTime end}) getMonthRange(int offset) {
  final now = DateTime.now();
  final targetMonth = DateTime(now.year, now.month + offset, 1);
  // Get the last day of the target month
  final endMonth = DateTime(now.year, now.month + offset + 1, 0, 23, 59, 59, 999);
  return (start: targetMonth, end: endMonth);
}

/// Filter items by period
/// 'this' = current month, 'last' = last month, 'all' = no filter
List<Map<String, dynamic>> filterByPeriod(
  List<Map<String, dynamic>> items,
  String period,
  String dateField,
) {
  if (period == 'all') return items;

  final offset = period == 'last' ? -1 : 0;
  final range = getMonthRange(offset);

  return items.where((item) {
    final dateStr = item[dateField] as String?;
    if (dateStr == null) return false;
    
    final date = DateTime.parse(dateStr).toLocal();
    return date.isAfter(range.start.subtract(const Duration(milliseconds: 1))) &&
        date.isBefore(range.end.add(const Duration(milliseconds: 1)));
  }).toList();
}

/// Format display date for the date picker pill
/// Shows "Today", "Yesterday", or "12 Apr 2026"
String formatDatePill(DateTime date) {
  final now = DateTime.now();
  final isToday = now.day == date.day && now.month == date.month && now.year == date.year;
  
  final yesterday = now.subtract(const Duration(days: 1));
  final isYesterday = yesterday.day == date.day && yesterday.month == date.month && yesterday.year == date.year;

  if (isToday) return 'Today';
  if (isYesterday) return 'Yesterday';
  return DateFormat('d MMM yyyy').format(date);
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/constants.dart';

enum AmountSize { hero, card, transaction }

/// Formatted amount display widget.
class AmountDisplay extends StatelessWidget {
  final int paisa;
  final String currencyCode;
  final bool isHidden;
  final AmountSize size;

  const AmountDisplay({
    super.key,
    required this.paisa,
    this.currencyCode = AppConstants.defaultCurrency,
    this.isHidden = false,
    this.size = AmountSize.transaction,
  });

  @override
  Widget build(BuildContext context) {
    if (isHidden) {
      return Text(
        '•••••',
        style: _getStyle(context),
      );
    }

    final currency = AppConstants.currencies[currencyCode] ?? AppConstants.currencies[AppConstants.defaultCurrency]!;
    final symbol = currency.symbol;
    
    final double amount = paisa / 100;
    
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final parts = formatter.format(amount).split('.');
    
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '00';

    final style = _getStyle(context);
    final decimalStyle = _getDecimalStyle(context, style);

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: '$symbol '),
          TextSpan(text: integerPart),
          TextSpan(
            text: '.$decimalPart',
            style: decimalStyle,
          ),
        ],
      ),
    );
  }

  TextStyle _getStyle(BuildContext context) {
    switch (size) {
      case AmountSize.hero:
        return AppTypography.heroAmount;
      case AmountSize.card:
        return AppTypography.accountCardBalance;
      case AmountSize.transaction:
        return AppTypography.body.copyWith(
          fontWeight: FontWeight.w600,
        );
    }
  }

  TextStyle _getDecimalStyle(BuildContext context, TextStyle baseStyle) {
    switch (size) {
      case AmountSize.hero:
        return AppTypography.heroDecimal;
      case AmountSize.card:
        return baseStyle.copyWith(
          color: baseStyle.color?.withOpacity(0.6),
          fontSize: (baseStyle.fontSize ?? 14) * 0.8,
        );
      case AmountSize.transaction:
        return baseStyle.copyWith(
          color: baseStyle.color?.withOpacity(0.5),
          fontWeight: FontWeight.w400,
        );
    }
  }
}

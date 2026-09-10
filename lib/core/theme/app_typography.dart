import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Defines all the text styles used in the Dhukuti app.
class AppTypography {
  AppTypography._();

  static const String _fontFamily = 'DM Sans';

  static const TextStyle heroAmount = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.2,
    color: Colors.white,
  );

  static TextStyle get heroDecimal => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white.withOpacity(0.45),
      );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Color(0xFF111111),
  );

  static const TextStyle addTransactionTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Color(0xFF111111),
  );

  static const TextStyle modalTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF333333),
  );

  static const TextStyle accountCardBalance = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: Colors.white,
  );

  static const TextStyle numpadAmount = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 38,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
    color: Color(0xFF111111),
  );

  static const TextStyle contributeAmount = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
    color: Color(0xFF111111),
  );

  static const TextStyle analyticsNetIncome = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: Colors.white,
  );

  static const TextStyle goalDetailSaved = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: Colors.white,
  );

  static const TextStyle donutCenterAmount = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Color(0xFF111111),
  );

  static const TextStyle transactionName = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF111111),
  );

  static const TextStyle accountTag = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 9,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle sectionLabelUpper = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: Color(0xFFAAAAAA),
  );

  static const TextStyle sectionLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Color(0xFF999999),
  );

  static const TextStyle timestamp = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: Color(0xFFAAAAAA),
  );

  static const TextStyle navLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Color(0xFFBBBBBB),
  );

  static const TextStyle navLabelActive = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: Color(0xFF111111),
  );

  static const TextStyle quickChip = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle categoryChip = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle accountChip = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle weekdayHeader = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Color(0xFFBBBBBB),
  );

  static const TextStyle calendarDay = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF333333),
  );

  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Color(0xFF111111),
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF666666),
  );
}

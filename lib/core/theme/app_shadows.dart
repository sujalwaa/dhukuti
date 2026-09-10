import 'package:flutter/material.dart';

/// Defines all the box shadows used in the Dhukuti app.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> get heroCard => const [
        BoxShadow(
          color: Color.fromRGBO(10, 10, 26, 0.5),
          offset: Offset(0, 20),
          blurRadius: 50,
          spreadRadius: -12,
        ),
        BoxShadow(
          color: Color.fromRGBO(10, 10, 26, 0.4),
          offset: Offset(0, 8),
          blurRadius: 20,
          spreadRadius: -8,
        ),
      ];

  static List<BoxShadow> get savingsHero => const [
        BoxShadow(
          color: Color.fromRGBO(10, 10, 26, 0.4),
          offset: Offset(0, 15),
          blurRadius: 40,
          spreadRadius: -10,
        ),
      ];

  static List<BoxShadow> goalPreview(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.37),
          offset: const Offset(0, 10),
          blurRadius: 30,
          spreadRadius: -10,
        ),
      ];

  static List<BoxShadow> get analyticsNetIncome => const [
        BoxShadow(
          color: Color.fromRGBO(10, 10, 26, 0.4),
          offset: Offset(0, 10),
          blurRadius: 30,
          spreadRadius: -10,
        ),
      ];

  static List<BoxShadow> get standardCard => const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.04),
          offset: Offset(0, 1),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get elevatedCard => const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.04),
          offset: Offset(0, 1),
          blurRadius: 5,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get itemEditor => const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.06),
          offset: Offset(0, 2),
          blurRadius: 12,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get toggleDot => const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          offset: Offset(0, 1),
          blurRadius: 3,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get navAddButton => const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          offset: Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get activeToggle => const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.06),
          offset: Offset(0, 1),
          blurRadius: 3,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get progressGlow => const [
        BoxShadow(
          color: Color.fromRGBO(52, 199, 89, 0.5),
          offset: Offset(0, 0),
          blurRadius: 10,
          spreadRadius: 0,
        ),
      ];
}

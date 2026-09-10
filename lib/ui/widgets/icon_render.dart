import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Renders a Phosphor icon based on a string name.
class IconRender extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;
  final double strokeWidth;

  const IconRender({
    super.key,
    required this.name,
    this.size = 24.0,
    this.color,
    this.strokeWidth = 2.0,
  });

  IconData _getIconData() {
    switch (name) {
      case 'receipt':
        return PhosphorIcons.receipt();
      case 'utensils':
        return PhosphorIcons.forkKnife();
      case 'gamepad':
        return PhosphorIcons.gameController();
      case 'car':
        return PhosphorIcons.car();
      case 'heart':
        return PhosphorIcons.heart();
      case 'shoppingBag':
        return PhosphorIcons.shoppingBag();
      case 'wallet':
        return PhosphorIcons.wallet();
      case 'building':
        return PhosphorIcons.buildings();
      case 'banknote':
        return PhosphorIcons.money();
      case 'trendingUp':
        return PhosphorIcons.trendUp();
      case 'landmark':
        return PhosphorIcons.bank();
      case 'target':
        return PhosphorIcons.target();
      case 'shield':
        return PhosphorIcons.shield();
      case 'airplane':
        return PhosphorIcons.airplane();
      case 'laptop':
        return PhosphorIcons.laptop();
      case 'creditCard':
        return PhosphorIcons.creditCard();
      case 'currencyDollar':
        return PhosphorIcons.currencyDollar();
      case 'tag':
        return PhosphorIcons.tag();
      case 'stack':
        return PhosphorIcons.stack();
      case 'piggyBank':
        return PhosphorIcons.piggyBank();
      default:
        return PhosphorIcons.tag();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIconData(),
      size: size,
      color: color,
    );
  }
}

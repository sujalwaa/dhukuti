class AppConstants {
  static const String appName = 'Dhukuti';
  static const String tagline = 'धुकुटि · know your money';
  static const String defaultCurrency = 'NPR';
  
  static const Map<String, CurrencyInfo> currencies = {
    'NPR': CurrencyInfo(symbol: 'रु', name: 'Nepalese Rupee', rate: 1.0),
    'USD': CurrencyInfo(symbol: '\$', name: 'US Dollar', rate: 0.0075),
  };
  
  // Icon options (20 icons available for user selection)
  static const List<String> iconOptions = [
    'receipt', 'utensils', 'gamepad', 'car', 'heart', 'shoppingBag',
    'wallet', 'building', 'banknote', 'trendingUp', 'landmark', 'target',
    'shield', 'airplane', 'laptop', 'creditCard', 'currencyDollar',
    'tag', 'stack', 'piggyBank',
  ];
}

class CurrencyInfo {
  final String symbol;
  final String name;
  final double rate;

  const CurrencyInfo({
    required this.symbol,
    required this.name,
    required this.rate,
  });
}

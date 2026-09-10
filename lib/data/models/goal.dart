class Goal {
  final String id;
  final String userId;
  final String name;
  final int target; // paisa
  final String icon;
  final String color;
  final String sourceAccountId;
  final int balance; // current pot value, paisa
  final bool autoEnabled;
  final int autoAmount; // paisa
  final int autoDayOfMonth;

  const Goal({
    required this.id,
    required this.userId,
    required this.name,
    required this.target,
    required this.icon,
    required this.color,
    required this.sourceAccountId,
    required this.balance,
    required this.autoEnabled,
    required this.autoAmount,
    required this.autoDayOfMonth,
  });

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      target: map['target'] as int,
      icon: map['icon'] as String,
      color: map['color'] as String,
      sourceAccountId: map['sourceAccountId'] as String,
      balance: map['balance'] as int,
      autoEnabled: (map['autoEnabled'] as int) == 1,
      autoAmount: map['autoAmount'] as int,
      autoDayOfMonth: map['autoDayOfMonth'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'target': target,
      'icon': icon,
      'color': color,
      'sourceAccountId': sourceAccountId,
      'balance': balance,
      'autoEnabled': autoEnabled ? 1 : 0,
      'autoAmount': autoAmount,
      'autoDayOfMonth': autoDayOfMonth,
    };
  }

  Goal copyWith({
    String? id,
    String? userId,
    String? name,
    int? target,
    String? icon,
    String? color,
    String? sourceAccountId,
    int? balance,
    bool? autoEnabled,
    int? autoAmount,
    int? autoDayOfMonth,
  }) {
    return Goal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      target: target ?? this.target,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sourceAccountId: sourceAccountId ?? this.sourceAccountId,
      balance: balance ?? this.balance,
      autoEnabled: autoEnabled ?? this.autoEnabled,
      autoAmount: autoAmount ?? this.autoAmount,
      autoDayOfMonth: autoDayOfMonth ?? this.autoDayOfMonth,
    );
  }
}

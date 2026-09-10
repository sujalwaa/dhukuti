class Account {
  final String id;
  final String userId;
  final String name;
  final String color;
  final String icon;
  final int balance; // in paisa

  const Account({
    required this.id,
    required this.userId,
    required this.name,
    required this.color,
    required this.icon,
    required this.balance,
  });

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      color: map['color'] as String,
      icon: map['icon'] as String,
      balance: map['balance'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'color': color,
      'icon': icon,
      'balance': balance,
    };
  }

  Account copyWith({
    String? id,
    String? userId,
    String? name,
    String? color,
    String? icon,
    int? balance,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      balance: balance ?? this.balance,
    );
  }
}

class Income {
  final String id;
  final String userId;
  final String name;
  final String accountId;
  final int amount; // paisa, positive
  final DateTime date;

  const Income({
    required this.id,
    required this.userId,
    required this.name,
    required this.accountId,
    required this.amount,
    required this.date,
  });

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      accountId: map['accountId'] as String,
      amount: map['amount'] as int,
      date: DateTime.parse(map['date'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'accountId': accountId,
      'amount': amount,
      'date': date.toUtc().toIso8601String(),
    };
  }

  Income copyWith({
    String? id,
    String? userId,
    String? name,
    String? accountId,
    int? amount,
    DateTime? date,
  }) {
    return Income(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      accountId: accountId ?? this.accountId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }
}

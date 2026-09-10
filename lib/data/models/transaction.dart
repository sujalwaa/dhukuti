class Transaction {
  final String id;
  final String userId;
  final String name;
  final String accountId;
  final String categoryId;
  final int amount; // paisa, negative = expense
  final DateTime date;
  final String source; // 'manual' or 'import'

  const Transaction({
    required this.id,
    required this.userId,
    required this.name,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.date,
    required this.source,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      accountId: map['accountId'] as String,
      categoryId: map['categoryId'] as String,
      amount: map['amount'] as int,
      date: DateTime.parse(map['date'] as String).toLocal(),
      source: map['source'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'accountId': accountId,
      'categoryId': categoryId,
      'amount': amount,
      'date': date.toUtc().toIso8601String(),
      'source': source,
    };
  }

  Transaction copyWith({
    String? id,
    String? userId,
    String? name,
    String? accountId,
    String? categoryId,
    int? amount,
    DateTime? date,
    String? source,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      source: source ?? this.source,
    );
  }
}

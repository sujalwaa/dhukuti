class Contribution {
  final String id;
  final String goalId;
  final String type; // 'contribute' or 'withdraw'
  final int amount; // always positive
  final DateTime date;
  final String note;

  const Contribution({
    required this.id,
    required this.goalId,
    required this.type,
    required this.amount,
    required this.date,
    required this.note,
  });

  factory Contribution.fromMap(Map<String, dynamic> map) {
    return Contribution(
      id: map['id'] as String,
      goalId: map['goalId'] as String,
      type: map['type'] as String,
      amount: map['amount'] as int,
      date: DateTime.parse(map['date'] as String).toLocal(),
      note: map['note'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goalId': goalId,
      'type': type,
      'amount': amount,
      'date': date.toUtc().toIso8601String(),
      'note': note,
    };
  }

  Contribution copyWith({
    String? id,
    String? goalId,
    String? type,
    int? amount,
    DateTime? date,
    String? note,
  }) {
    return Contribution(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}

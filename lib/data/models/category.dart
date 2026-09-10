class Category {
  final String id;
  final String userId;
  final String name;
  final String icon;
  final String color;

  const Category({
    required this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      icon: map['icon'] as String,
      color: map['color'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  Category copyWith({
    String? id,
    String? userId,
    String? name,
    String? icon,
    String? color,
  }) {
    return Category(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}

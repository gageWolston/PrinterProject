class OrderRecord {
  final String id;
  final String? user;
  final DateTime placedAt;
  final double subtotal;
  final double discount;
  final String? couponCode;
  final double total;
  final List<Map<String, dynamic>> items;

  OrderRecord({
    String? id,
    required this.user,
    required this.placedAt,
    required this.subtotal,
    required this.discount,
    this.couponCode,
    required this.total,
    required this.items,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'placedAt': placedAt.toIso8601String(),
      'subtotal': subtotal,
      'discount': discount,
      'couponCode': couponCode,
      'total': total,
      'items': items,
    };
  }

  factory OrderRecord.fromMap(Map<dynamic, dynamic> map) {
    return OrderRecord(
      id: map['id'] as String?,
      user: map['user'] as String?,
      placedAt: DateTime.parse(map['placedAt'] as String),
      subtotal: (map['subtotal'] as num?)?.toDouble() ??
          (map['total'] as num).toDouble(),
      discount: (map['discount'] as num?)?.toDouble() ?? 0.0,
      couponCode: map['couponCode'] as String?,
      total: (map['total'] as num).toDouble(),
      items: List<Map<String, dynamic>>.from(
        (map['items'] as List<dynamic>).map(
          (item) => Map<String, dynamic>.from(item as Map),
        ),
      ),
    );
  }
}

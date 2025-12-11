class Printer {
  final String id;
  final String name;
  final String brand;
  final String type;
  final bool onSale;
  final double rating;
  final double price;
  final String description;
  final List<String> highlights;
  final Set<String> features;

  Printer({
    String? id,
    required this.name,
    required this.brand,
    required this.type,
    required this.onSale,
    required this.rating,
    required this.price,
    required this.description,
    required this.highlights,
    required this.features,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Printer copyWith({
    String? id,
    String? name,
    String? brand,
    String? type,
    bool? onSale,
    double? rating,
    double? price,
    String? description,
    List<String>? highlights,
    Set<String>? features,
  }) {
    return Printer(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      type: type ?? this.type,
      onSale: onSale ?? this.onSale,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      description: description ?? this.description,
      highlights: highlights ?? this.highlights,
      features: features ?? this.features,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'type': type,
      'onSale': onSale,
      'rating': rating,
      'price': price,
      'description': description,
      'highlights': highlights,
      'features': features.toList(),
    };
  }

  factory Printer.fromMap(Map<dynamic, dynamic> map) {
    return Printer(
      id: map['id'] as String?,
      name: map['name'] as String,
      brand: (map['brand'] as String?) ?? 'Unknown',
      type: map['type'] as String,
      onSale: map['onSale'] as bool,
      rating: (map['rating'] as num).toDouble(),
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      highlights: List<String>.from(map['highlights'] as List<dynamic>),
      features: Set<String>.from((map['features'] as List<dynamic>? ?? <dynamic>[])
          .map((f) => f.toString())),
    );
  }
}

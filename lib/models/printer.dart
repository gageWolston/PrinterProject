class Printer {
  final String id;
  final String name;
  final String type;
  final bool onSale;
  final double rating;
  final double price;
  final String image; // asset path
  final String description;
  final List<String> highlights;

  Printer({
    String? id,
    required this.name,
    required this.type,
    required this.onSale,
    required this.rating,
    required this.price,
    required this.image,
    required this.description,
    required this.highlights,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Printer copyWith({
    String? id,
    String? name,
    String? type,
    bool? onSale,
    double? rating,
    double? price,
    String? image,
    String? description,
    List<String>? highlights,
  }) {
    return Printer(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      onSale: onSale ?? this.onSale,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      highlights: highlights ?? this.highlights,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'onSale': onSale,
      'rating': rating,
      'price': price,
      'image': image,
      'description': description,
      'highlights': highlights,
    };
  }

  factory Printer.fromMap(Map<dynamic, dynamic> map) {
    return Printer(
      id: map['id'] as String?,
      name: map['name'] as String,
      type: map['type'] as String,
      onSale: map['onSale'] as bool,
      rating: (map['rating'] as num).toDouble(),
      price: (map['price'] as num).toDouble(),
      image: map['image'] as String,
      description: map['description'] as String,
      highlights: List<String>.from(map['highlights'] as List<dynamic>),
    );
  }
}

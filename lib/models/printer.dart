class Printer {
  final String name;
  final String type;
  final bool onSale;
  final double rating;
  final double price;
  final String image; // asset path

  Printer({
    required this.name,
    required this.type,
    required this.onSale,
    required this.rating,
    required this.price,
    required this.image,
  });
}

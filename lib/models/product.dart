class Product {
  final String id;
  final String name;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  @override
  bool operator ==(Object other) {
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

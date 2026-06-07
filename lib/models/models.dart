class Product {
  final String id;
  final String name;
  final double price;
  final double originalPrice;
  final int discount;
  final String imageAsset;
  final List<String> images;
  final String category;
  final String material;
  final String description;
  final List<String> colors;
  final List<String> sizes;
  final int stock;
  final double rating;
  final int reviewCount;
  final List<String> tags;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.imageAsset,
    required this.images,
    required this.category,
    required this.material,
    required this.description,
    required this.colors,
    required this.sizes,
    required this.stock,
    required this.rating,
    required this.reviewCount,
    required this.tags,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}

class ProductReview {
  final String name;
  final double rating;
  final String text;
  final String date;

  const ProductReview({
    required this.name,
    required this.rating,
    required this.text,
    required this.date,
  });
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../models/product_data.dart';
import '../providers/providers.dart';
import '../theme.dart';
import '../widgets/app_drawer.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Lehenga', 'Bridal', 'Party'];

  List<Product> get _filtered => _selectedCategory == 'All'
      ? allProducts
      : allProducts.where((p) => p.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        title: Text('Products', style: GoogleFonts.josefinSans(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          Stack(
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
              ),
              if (cart.count > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                    child: Text('${cart.count}',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final selected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: selected,
                      selectedColor: kPrimary,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : kDark,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) => _ProductCard(product: _filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();
    final inCart = cart.containsProduct(product.id);
    final inWishlist = wishlist.isWishlisted(product.id);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
      ),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    product.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                    ),
                  ),
                  // Discount badge
                  if (product.discount > 0)
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: kPrimary, borderRadius: BorderRadius.circular(6)),
                        child: Text('${product.discount}% OFF',
                            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  // Wishlist icon
                  Positioned(
                    top: 6, right: 6,
                    child: GestureDetector(
                      onTap: () => wishlist.toggle(product.id),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          inWishlist ? Icons.favorite : Icons.favorite_border,
                          color: inWishlist ? Colors.red : Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: GoogleFonts.poppins(color: kPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text('₹${product.price.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 4),
                      Text('₹${product.originalPrice.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                              fontSize: 10, color: Colors.grey,
                              decoration: TextDecoration.lineThrough)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: inCart ? Colors.grey : kPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: inCart ? null : () {
                        cart.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${product.name} added to cart'),
                          backgroundColor: kPrimary,
                          duration: const Duration(seconds: 1),
                        ));
                      },
                      child: Text(inCart ? 'In Cart' : 'Add to Cart',
                          style: const TextStyle(fontSize: 11, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

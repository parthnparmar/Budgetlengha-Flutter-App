import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../models/product_data.dart';
import '../providers/providers.dart';
import '../theme.dart';

// ── Sample reviews ────────────────────────────────────────────────────────────
const _sampleReviews = [
  ProductReview(name: 'Priya S.', rating: 5, text: 'Absolutely stunning lehenga! The fabric quality is superb and the embroidery is even more beautiful in person.', date: '12 Nov 2024'),
  ProductReview(name: 'Anjali M.', rating: 4, text: 'Great quality and fast delivery. The color is exactly as shown. Very happy with my purchase!', date: '8 Oct 2024'),
  ProductReview(name: 'Nisha R.', rating: 5, text: "Wore this to my cousin's wedding and received so many compliments. Worth every rupee!", date: '2 Sep 2024'),
];

// ── Color map ─────────────────────────────────────────────────────────────────
Color _colorFromName(String name) {
  const map = {
    'Red': Color(0xFFc0392b), 'Maroon': Color(0xFF6b1a1a), 'Pink': Color(0xFFe91e8c),
    'Blue': Color(0xFF2980b9), 'Teal': Color(0xFF009688), 'Purple': Color(0xFF7b2d8b),
    'Green': Color(0xFF27ae60), 'Yellow': Color(0xFFf1c40f), 'Orange': Color(0xFFe67e22),
    'Royal Blue': Color(0xFF1a237e), 'Wine': Color(0xFF722f37), 'Black': Color(0xFF222222),
    'White': Color(0xFFf5f5f5), 'Ivory': Color(0xFFFFFFF0), 'Champagne': Color(0xFFf7e7ce),
    'Gold': Color(0xFFc9953a), 'Peach': Color(0xFFffcba4), 'Cream': Color(0xFFfffdd0),
    'Lavender': Color(0xFF967bb6), 'Coral': Color(0xFFff6b6b), 'Navy': Color(0xFF001f5b),
    'Burgundy': Color(0xFF800020), 'Blush': Color(0xFFffb7c5), 'Bottle Green': Color(0xFF006a4e),
    'Mint': Color(0xFF98ff98), 'Lilac': Color(0xFFc8a2c8), 'Salmon': Color(0xFFfa8072),
    'Hot Pink': Color(0xFFff69b4), 'Magenta': Color(0xFFff00ff), 'Turquoise': Color(0xFF40e0d0),
    'Light Purple': Color(0xFFc084fc), 'Off-White': Color(0xFFfaf9f6), 'Multi': Color(0xFF9c27b0),
    'Golden': Color(0xFFffd700),
  };
  return map[name] ?? Colors.grey;
}

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late Product p;
  int _imgIndex = 0;
  String? _selectedColor;
  String? _selectedSize;
  int _qty = 1;
  late TabController _tabCtrl;
  final PageController _pageCtrl = PageController();

  @override
  void initState() {
    super.initState();
    p = widget.product;
    _selectedColor = p.colors.isNotEmpty ? p.colors[0] : null;
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  String get _deliveryDate {
    final d = DateTime.now().add(const Duration(days: 5));
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.poppins(fontSize: 13)),
      backgroundColor: kDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      duration: const Duration(seconds: 2),
    ));
  }

  void _addToCart(CartProvider cart) {
    if (p.stock <= 0) return;
    for (var i = 0; i < _qty; i++) {
      if (!cart.containsProduct(p.id)) cart.addToCart(p);
    }
    if (cart.containsProduct(p.id)) {
      cart.updateQuantity(p.id, _qty);
    }
    _showToast('${p.name} added to cart!');
  }

  void _buyNow(CartProvider cart) {
    _addToCart(cart);
    Navigator.pushNamed(context, '/cart');
  }

  void _shareProduct() {
    Clipboard.setData(ClipboardData(text: 'Check out ${p.name} on Budgetlengha! Price: ₹${p.price.toStringAsFixed(0)}'));
    _showToast('🔗 Product link copied!');
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();
    final inWishlist = wishlist.isWishlisted(p.id);
    final inCart = cart.containsProduct(p.id);

    final recommended = allProducts
        .where((r) => r.id != p.id && r.category == p.category)
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar with image gallery ──────────────────────────────
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: kDark,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                  child: Icon(
                    inWishlist ? Icons.favorite : Icons.favorite_border,
                    color: inWishlist ? Colors.red : Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  wishlist.toggle(p.id);
                  _showToast(wishlist.isWishlisted(p.id)
                      ? '❤️ Added to Wishlist!'
                      : 'Removed from Wishlist');
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                  child: const Icon(Icons.share, color: Colors.white, size: 20),
                ),
                onPressed: _shareProduct,
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _pageCtrl,
                    itemCount: p.images.length,
                    onPageChanged: (i) => setState(() => _imgIndex = i),
                    itemBuilder: (_, i) => Image.asset(
                      p.images[i],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                      ),
                    ),
                  ),
                  // Dot indicators
                  if (p.images.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0, right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(p.images.length, (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _imgIndex == i ? 20 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: _imgIndex == i ? kPrimary : Colors.white70,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
                      ),
                    ),
                  // Thumbnail strip
                  Positioned(
                    bottom: 38,
                    left: 12,
                    child: Row(
                      children: p.images.asMap().entries.map((e) => GestureDetector(
                        onTap: () {
                          _pageCtrl.animateToPage(e.key,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _imgIndex == e.key ? kPrimary : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(e.value, width: 48, height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                    width: 48, height: 48, color: Colors.grey[300])),
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Product info ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + stock badge
                  Row(
                    children: [
                      _Chip(p.category, kAccent),
                      const SizedBox(width: 8),
                      _stockBadge(p.stock),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Name
                  Text(p.name,
                      style: GoogleFonts.cormorantGaramond(
                          fontSize: 26, fontWeight: FontWeight.w700, color: kDark)),
                  const SizedBox(height: 8),

                  // Rating
                  Row(
                    children: [
                      _StarRow(p.rating),
                      const SizedBox(width: 6),
                      Text('${p.rating}',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => _tabCtrl.animateTo(2),
                        child: Text('(${p.reviewCount} reviews)',
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('₹${p.price.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                              fontSize: 26, fontWeight: FontWeight.w700, color: kPrimary)),
                      const SizedBox(width: 10),
                      Text('₹${p.originalPrice.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                              fontSize: 15, color: Colors.grey,
                              decoration: TextDecoration.lineThrough)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: kPrimary, borderRadius: BorderRadius.circular(20)),
                        child: Text('${p.discount}% OFF',
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  Text('Inclusive of all taxes',
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 20),

                  // Color selector
                  _SectionLabel('Color', suffix: _selectedColor ?? ''),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: p.colors.map((c) {
                      final sel = c == _selectedColor;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = c),
                        child: Tooltip(
                          message: c,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: _colorFromName(c),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: sel ? kPrimary : Colors.transparent, width: 3),
                              boxShadow: [BoxShadow(
                                color: Colors.black.withOpacity(0.2), blurRadius: 4)],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Size selector
                  _SectionLabel('Size', suffix: _selectedSize ?? 'Select'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: p.sizes.map((s) {
                      final sel = s == _selectedSize;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSize = s),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: sel ? kPrimary : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: sel ? kPrimary : const Color(0xFFE8D5C4), width: 1.5),
                          ),
                          child: Text(s,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: sel ? Colors.white : kDark)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Quantity
                  _SectionLabel('Quantity', suffix: ''),
                  const SizedBox(height: 8),
                  _QuantitySelector(
                    qty: _qty,
                    max: p.stock,
                    onChanged: (v) => setState(() => _qty = v),
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _ActionBtn(
                          label: inCart ? 'In Cart' : 'Add to Cart',
                          icon: Icons.shopping_bag_outlined,
                          color: inCart ? Colors.grey : kPrimary,
                          onTap: p.stock > 0 && !inCart ? () => _addToCart(cart) : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionBtn(
                          label: 'Buy Now',
                          icon: Icons.bolt,
                          color: const Color(0xFFc9953a),
                          onTap: p.stock > 0 ? () => _buyNow(cart) : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Delivery info card
                  _InfoCard(children: [
                    _InfoRow(Icons.local_shipping_outlined, 'Estimated Delivery', _deliveryDate, Colors.green),
                    _InfoRow(Icons.card_giftcard, 'Free Shipping', 'On orders above ₹5,000', kAccent),
                    _InfoRow(Icons.refresh, 'Returns', '7-day easy return', kPrimary),
                    _InfoRow(Icons.verified_outlined, 'Authenticity', '100% genuine product', Colors.blue),
                  ]),
                  const SizedBox(height: 12),

                  // Specs card
                  _InfoCard(children: [
                    _InfoRow(Icons.info_outline, 'Material', p.material, kPrimary),
                    _InfoRow(Icons.category_outlined, 'Category', p.category, kAccent),
                    _InfoRow(Icons.celebration_outlined, 'Occasion', 'Wedding / Festive', Colors.purple),
                    _InfoRow(Icons.dry_cleaning_outlined, 'Wash Care', 'Dry Clean Only', Colors.teal),
                    _InfoRow(Icons.flag_outlined, 'Origin', 'India', Colors.orange),
                  ]),
                  const SizedBox(height: 16),

                  // Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: p.tags.map((t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E9E2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('#$t',
                          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[700])),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Tabs: Description | Return Policy | Reviews
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8D5C4)),
                    ),
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabCtrl,
                          labelColor: kPrimary,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: kPrimary,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w600),
                          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
                          tabs: const [
                            Tab(text: 'Description'),
                            Tab(text: 'Return Policy'),
                            Tab(text: 'Reviews'),
                          ],
                        ),
                        SizedBox(
                          height: 280,
                          child: TabBarView(
                            controller: _tabCtrl,
                            children: [
                              _DescriptionTab(p),
                              const _ReturnPolicyTab(),
                              _ReviewsTab(p),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Recommended
                  if (recommended.isNotEmpty) ...[
                    Text('You May Also Like',
                        style: GoogleFonts.cormorantGaramond(
                            fontSize: 20, fontWeight: FontWeight.w700, color: kPrimary)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: recommended.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (_, i) => _RecommendedCard(product: recommended[i]),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

Widget _stockBadge(int stock) {
  if (stock <= 0) return _Chip('Out of Stock', Colors.red);
  if (stock <= 3) return _Chip('Only $stock left!', Colors.orange);
  return _Chip('In Stock', Colors.green);
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Text(label,
            style: GoogleFonts.poppins(
                color: color, fontSize: 11, fontWeight: FontWeight.w600)),
      );
}

class _StarRow extends StatelessWidget {
  final double rating;
  const _StarRow(this.rating);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (i) {
          if (i < rating.floor()) {
            return const Icon(Icons.star, color: Color(0xFFE6A817), size: 16);
          } else if (i < rating) {
            return const Icon(Icons.star_half, color: Color(0xFFE6A817), size: 16);
          }
          return const Icon(Icons.star_border, color: Color(0xFFE6A817), size: 16);
        }),
      );
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final String suffix;
  const _SectionLabel(this.label, {required this.suffix});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text('$label: ',
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: Colors.grey[600], letterSpacing: 0.5)),
          Text(suffix,
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w700, color: kPrimary)),
        ],
      );
}

class _QuantitySelector extends StatelessWidget {
  final int qty;
  final int max;
  final ValueChanged<int> onChanged;
  const _QuantitySelector({required this.qty, required this.max, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE8D5C4), width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _QtyBtn(icon: Icons.remove, onTap: qty > 1 ? () => onChanged(qty - 1) : null),
            SizedBox(
              width: 48,
              child: Text('$qty',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            _QtyBtn(icon: Icons.add, onTap: qty < max ? () => onChanged(qty + 1) : null),
          ],
        ),
      );
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QtyBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 18,
              color: onTap != null ? kPrimary : Colors.grey),
        ),
      );
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const _ActionBtn({required this.label, required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: onTap != null ? color : Colors.grey,
            borderRadius: BorderRadius.circular(12),
            boxShadow: onTap != null ? [BoxShadow(
              color: color.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 4))] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(label,
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
        ),
      );
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8D5C4)),
        ),
        child: Column(children: children),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  const _InfoRow(this.icon, this.label, this.value, this.iconColor);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
            ),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w600, color: kDark)),
          ],
        ),
      );
}

class _DescriptionTab extends StatelessWidget {
  final Product p;
  const _DescriptionTab(this.p);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.description,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: Colors.grey[700], height: 1.7)),
            const SizedBox(height: 12),
            ...['Premium Quality Fabric', 'Hand-crafted Embroidery',
                'Free Alterations Available', 'Customizable Colors',
                'Same-day Dispatch on Orders Before 2PM']
                .map((h) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: kPrimary, size: 16),
                          const SizedBox(width: 8),
                          Text(h, style: GoogleFonts.poppins(fontSize: 12, color: kDark)),
                        ],
                      ),
                    )),
          ],
        ),
      );
}

class _ReturnPolicyTab extends StatelessWidget {
  const _ReturnPolicyTab();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Return & Refund Policy',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w700, color: kPrimary)),
            const SizedBox(height: 10),
            ...const [
              'Returns accepted within 7 days of delivery.',
              'Item must be unworn, unwashed, with original tags.',
              'Refund processed within 5–7 business days.',
              'Custom-stitched garments are non-returnable.',
              'Free return pickup in select pincodes.',
              'For exchanges, contact +91 63594 72166 within 3 days.',
            ].map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: kPrimary, fontSize: 16)),
                      Expanded(
                        child: Text(s,
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey[700], height: 1.6)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );
}

class _ReviewsTab extends StatelessWidget {
  final Product p;
  const _ReviewsTab(this.p);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating summary
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF6F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE8D5C4)),
                  ),
                  child: Column(
                    children: [
                      Text('${p.rating}',
                          style: GoogleFonts.poppins(
                              fontSize: 32, fontWeight: FontWeight.w700, color: kPrimary)),
                      _StarRow(p.rating),
                      Text('${p.reviewCount} ratings',
                          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    children: [5, 4, 3, 2, 1].map((s) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text('$s', style: GoogleFonts.poppins(fontSize: 11)),
                          const Icon(Icons.star, size: 11, color: Color(0xFFE6A817)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: s == 5 ? 0.6 : s == 4 ? 0.25 : s == 3 ? 0.1 : 0.03,
                                backgroundColor: Colors.grey[200],
                                color: kPrimary,
                                minHeight: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Reviews
            ..._sampleReviews.map((r) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE8D5C4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(r.name,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 13)),
                      Text(r.date,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _StarRow(r.rating),
                  const SizedBox(height: 6),
                  Text(r.text,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey[700], height: 1.5)),
                ],
              ),
            )),
          ],
        ),
      );
}

class _RecommendedCard extends StatelessWidget {
  final Product product;
  const _RecommendedCard({required this.product});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        ),
        child: Container(
          width: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8D5C4)),
            boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.05), blurRadius: 6)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(product.imageAsset,
                    height: 130, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        height: 130, color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey))),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: GoogleFonts.poppins(
                            fontSize: 11, fontWeight: FontWeight.w600, color: kPrimary),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text('₹${product.price.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                                fontSize: 12, fontWeight: FontWeight.w700, color: kPrimary)),
                        const SizedBox(width: 4),
                        Text('${product.discount}% off',
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

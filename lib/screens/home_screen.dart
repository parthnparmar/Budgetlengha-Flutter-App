import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';
import '../models/product_data.dart';
import '../models/models.dart';
import '../theme.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final auth = context.watch<AuthProvider>();
    final featured = allProducts.take(4).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              height: 36, width: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kAccent, width: 2),
              ),
              child: ClipOval(
                child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 8),
            Text('Budgetlengha',
                style: GoogleFonts.josefinSans(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              auth.isLoggedIn ? Icons.account_circle : Icons.login,
              color: Colors.white,
            ),
            tooltip: auth.isLoggedIn ? auth.username : 'Sign In',
            onPressed: () {
              if (auth.isLoggedIn) {
                auth.logout();
              } else {
                Navigator.pushNamed(context, '/signin');
              }
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
              ),
              if (cart.count > 0)
                Positioned(
                  right: 8, top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                    child: Text('${cart.count}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroBanner(),
            _CategorySection(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text('Featured Products',
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.bold, color: kDark)),
            ),
            _FeaturedGrid(products: featured),
            _AboutStrip(),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

// ── Hero Banner ──────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 260,
          width: double.infinity,
          child: Image.asset('assets/images/hero.jpg', fit: BoxFit.cover),
        ),
        Container(
          height: 260,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.65), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 28, left: 20, right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to\nBudgetlengha',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  shadows: [const Shadow(blurRadius: 8, color: Colors.black54)],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007bff),
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  elevation: 4,
                ),
                onPressed: () => Navigator.pushNamed(context, '/main'),
                child: Text('Start Shopping',
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Category Section ─────────────────────────────────────────
class _CategorySection extends StatelessWidget {
  static const _cats = [
    {'label': 'Lehenga',  'icon': Icons.checkroom,       'color': Color(0xFFa83f39)},
    {'label': 'Bridal',   'icon': Icons.favorite,        'color': Color(0xFFe91e8c)},
    {'label': 'Party',    'icon': Icons.celebration,     'color': Color(0xFF7b1fa2)},
    {'label': 'Services', 'icon': Icons.design_services, 'color': Color(0xFF1565c0)},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 14),
            child: Text('Shop by Category',
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.bold, color: kDark)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _cats.map((c) {
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/main'),
                child: Column(
                  children: [
                    Container(
                      height: 62, width: 62,
                      decoration: BoxDecoration(
                        color: (c['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: (c['color'] as Color).withOpacity(0.4), width: 1.5),
                      ),
                      child: Icon(c['icon'] as IconData,
                          color: c['color'] as Color, size: 28),
                    ),
                    const SizedBox(height: 6),
                    Text(c['label'] as String,
                        style: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.w500, color: kDark)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Featured Products Grid ────────────────────────────────────
class _FeaturedGrid extends StatelessWidget {
  final List<Product> products;
  const _FeaturedGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (ctx, i) {
          final p = products[i];
          final inCart = cart.containsProduct(p.id);
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.asset(p.imageAsset, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported,
                              color: Colors.grey, size: 40))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name,
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: kPrimary, fontWeight: FontWeight.w600),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('₹${p.price.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(fontSize: 11, color: Colors.black87)),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: inCart ? Colors.grey : kPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: inCart
                              ? null
                              : () {
                                  cart.addToCart(p);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('${p.name} added!'),
                                    backgroundColor: kPrimary,
                                    duration: const Duration(seconds: 1),
                                  ));
                                },
                          child: Text(inCart ? 'In Cart' : 'Add to Cart',
                              style: const TextStyle(fontSize: 10, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── About Strip ───────────────────────────────────────────────
class _AboutStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 20, 12, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kPrimary,
        borderRadius: BorderRadius.circular(14),
        image: const DecorationImage(
          image: AssetImage('assets/images/about.jpg'),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About Nuriya's Clothing",
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            'Affordable, stylish lehengas for weddings, festivals & cultural gatherings.',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white70),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            onPressed: () => Navigator.pushNamed(context, '/about'),
            child: Text('Learn More', style: GoogleFonts.poppins(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      color: const Color(0xFF222222),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Text("Nuriya's Clothing",
              style: GoogleFonts.josefinSans(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Traditional Indian Fashion & Bridal Wear',
              style: GoogleFonts.poppins(color: kAccent, fontSize: 11)),
          const SizedBox(height: 10),
          const Text(
            'Hussain Sindhi, near CB School, Valsad, Gujarat\n+91 63594 72166 | +91 63593 33433',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.6),
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24),
          const SizedBox(height: 6),
          Text("© 2024 Nuriya's Clothing. All rights reserved.",
              style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }
}

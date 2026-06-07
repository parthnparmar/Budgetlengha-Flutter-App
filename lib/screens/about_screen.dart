import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/app_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text('About Us',
            style: GoogleFonts.josefinSans(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Hero banner
          Stack(
            children: [
              SizedBox(
                height: 160,
                width: double.infinity,
                child: Image.asset('assets/images/hero.jpg', fit: BoxFit.cover),
              ),
              Container(height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.65), Colors.transparent],
                    begin: Alignment.bottomCenter, end: Alignment.topCenter,
                  ),
                ),
              ),
              const Positioned(
                bottom: 16, left: 20,
                child: Text('About Us',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 6, color: Colors.black54)])),
              ),
            ],
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('About Us',
                        style: GoogleFonts.poppins(fontSize: 26, color: kPrimary, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/about.jpg',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220, color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 60, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Budget Lehengas', style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    'At Budget Lehengas, we pride ourselves on offering stylish, high-quality lehengas that don\'t break the bank. Our vision is to create a fashion-forward platform where affordability meets elegance, allowing you to look your best without straining your budget.',
                    style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF555555), height: 1.8),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF555555), height: 1.8),
                      children: [
                        TextSpan(
                          text: 'Day by day, your choices shape who you are. ',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: kPrimary),
                        ),
                        const TextSpan(
                          text: 'Our lehengas, with their intricate designs and stunning details, celebrate the beauty of South Asian culture. We understand that lehengas hold a special place in weddings, festivals, and cultural gatherings.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: () => Navigator.pushReplacementNamed(context, '/products'),
                      child: Text('Explore Our Collection', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Footer
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFF333333), borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Text("Nuriya's Clothing", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        const Text(
                          'Address: Hussain Sindhi, Next to Shiraz Dairy,\nnear CB School, Halar Road, Valsad (Gujarat)\n+91 63594 72166 | +91 63593 33433',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



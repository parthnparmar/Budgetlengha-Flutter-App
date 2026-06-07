import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.75, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));

    _ctrl.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/main');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background hero image
          Image.asset('assets/images/hero.jpg', fit: BoxFit.cover),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.75),
                  kPrimary.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Content
          FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo circle
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kAccent, width: 3),
                      boxShadow: [
                        BoxShadow(color: kAccent.withOpacity(0.4), blurRadius: 20, spreadRadius: 2),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Budgetlengha',
                    style: GoogleFonts.josefinSans(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Nuriya's Clothing",
                    style: GoogleFonts.poppins(
                      color: kAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Traditional Fashion · Bridal Wear · Ethnic Styles',
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: kAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom tagline
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fade,
              child: Text(
                'Bringing traditional fashion to the digital world',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

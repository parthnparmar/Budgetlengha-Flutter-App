import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../theme.dart';
import 'home_screen.dart';
import 'products_screen.dart';
import 'cart_screen.dart';
import 'services_screen.dart';
import 'contact_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ProductsScreen(),
    CartScreen(),
    ServicesScreen(),
    ContactScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF222222),
        selectedItemColor: kAccent,
        unselectedItemColor: Colors.white54,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        elevation: 12,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (cart.count > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                      child: Text('${cart.count}',
                          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
            activeIcon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cart.count > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                      child: Text('${cart.count}',
                          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.design_services_outlined),
            activeIcon: Icon(Icons.design_services),
            label: 'Services',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail_outlined),
            activeIcon: Icon(Icons.contact_mail),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}

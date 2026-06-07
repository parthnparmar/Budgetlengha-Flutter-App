import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';
import '../theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: kDark),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 70, width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kAccent, width: 3),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                  ),
                  child: ClipOval(child: Image.asset('assets/images/logo.png', fit: BoxFit.cover)),
                ),
                const SizedBox(height: 8),
                Text('Budgetlengha',
                    style: GoogleFonts.josefinSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _Tile(Icons.home,           'Home',     () { Navigator.pop(context); Navigator.pushReplacementNamed(context, '/main'); }),
          _Tile(Icons.shopping_bag,   'Products', () { Navigator.pop(context); Navigator.pushReplacementNamed(context, '/main'); }),
          _Tile(Icons.design_services,'Services', () { Navigator.pop(context); Navigator.pushReplacementNamed(context, '/main'); }),
          _Tile(Icons.info_outline,   'About',    () { Navigator.pop(context); Navigator.pushNamed(context, '/about'); }),
          _Tile(Icons.contact_mail,   'Contact',  () { Navigator.pop(context); Navigator.pushReplacementNamed(context, '/main'); }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_cart, color: kPrimary),
            title: Text('My Cart (${cart.count})'),
            onTap: () { Navigator.pop(context); Navigator.pushReplacementNamed(context, '/main'); },
          ),
          const Divider(),
          if (auth.isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout, color: kPrimary),
              title: Text('Logout (${auth.username})'),
              onTap: () { auth.logout(); Navigator.pop(context); Navigator.pushReplacementNamed(context, '/main'); },
            )
          else ...[
            _Tile(Icons.login,      'Sign In', () { Navigator.pop(context); Navigator.pushNamed(context, '/signin'); }),
            _Tile(Icons.person_add, 'Sign Up', () { Navigator.pop(context); Navigator.pushNamed(context, '/signup'); }),
          ],
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _Tile(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: kPrimary),
        title: Text(label),
        onTap: onTap,
      );
}

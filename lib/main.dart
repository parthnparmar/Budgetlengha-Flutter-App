import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/providers.dart';
import 'screens/splash_screen.dart';
import 'screens/main_shell.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/about_screen.dart';
import 'theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const BudgetLenghaApp(),
    ),
  );
}

class BudgetLenghaApp extends StatelessWidget {
  const BudgetLenghaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budgetlengha',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: '/',
      routes: {
        '/':       (ctx) => const SplashScreen(),
        '/main':   (ctx) => const MainShell(),
        '/signin': (ctx) => const SignInScreen(),
        '/signup': (ctx) => const SignUpScreen(),
        '/about':  (ctx) => const AboutScreen(),
        '/cart':   (ctx) => const MainShell(),
      },
    );
  }
}

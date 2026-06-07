import 'package:flutter/material.dart';
import '../models/models.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get count => _items.length;
  double get grandTotal => _items.fold(0, (sum, item) => sum + item.total);

  bool containsProduct(String productId) =>
      _items.any((item) => item.product.id == productId);

  void addToCart(Product product) {
    if (containsProduct(product.id)) return;
    _items.add(CartItem(product: product));
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class WishlistProvider extends ChangeNotifier {
  final Set<String> _ids = {};

  bool isWishlisted(String productId) => _ids.contains(productId);
  int get count => _ids.length;

  void toggle(String productId) {
    if (_ids.contains(productId)) {
      _ids.remove(productId);
    } else {
      _ids.add(productId);
    }
    notifyListeners();
  }
}

class AuthProvider extends ChangeNotifier {
  String? _username;
  bool get isLoggedIn => _username != null;
  String? get username => _username;

  void login(String username) {
    _username = username;
    notifyListeners();
  }

  void logout() {
    _username = null;
    notifyListeners();
  }
}

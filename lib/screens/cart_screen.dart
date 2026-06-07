import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';
import '../theme.dart';
import '../widgets/app_drawer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _nameCtrl   = TextEditingController();
  final _phoneCtrl  = TextEditingController();
  final _addrCtrl   = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose(); _addrCtrl.dispose();
    super.dispose();
  }

  void _placeOrder(CartProvider cart) {
    if (_formKey.currentState!.validate()) {
      cart.clearCart();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Order Placed!'),
          ]),
          content: Text(
            'Thank you, ${_nameCtrl.text}!\n\nDelivery to:\n${_addrCtrl.text}\n\nPayment: Cash On Delivery',
          ),
          actions: [
            TextButton(
              onPressed: () { Navigator.pop(context); },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text('My Cart (${cart.count})',
            style: GoogleFonts.josefinSans(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 90, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Your cart is empty',
                      style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: const StadiumBorder(),
                    ),
                    icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                    label: Text('Shop Now',
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Cart',
                      style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: kDark)),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 8),
                  // Cart items
                  ...cart.items.map((item) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(item.product.imageAsset,
                                width: 64, height: 72, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                    width: 64, height: 72,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image, color: Colors.grey))),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name,
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                                Text('₹${item.product.price.toStringAsFixed(0)} each',
                                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    _QtyBtn(
                                      icon: Icons.remove,
                                      onTap: item.quantity > 1
                                          ? () => cart.updateQuantity(item.product.id, item.quantity - 1)
                                          : null,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text('${item.quantity}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    ),
                                    _QtyBtn(
                                      icon: Icons.add,
                                      onTap: item.quantity < 10
                                          ? () => cart.updateQuantity(item.product.id, item.quantity + 1)
                                          : null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                onPressed: () => cart.removeFromCart(item.product.id),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(height: 8),
                              Text('₹${item.total.toStringAsFixed(0)}',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold, color: kPrimary, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 8),
                  // Grand total
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Grand Total:',
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('₹${cart.grandTotal.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.bold, color: kPrimary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Delivery form
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Delivery Details',
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          _Field(ctrl: _nameCtrl,  label: 'Full Name',    hint: 'Enter your full name'),
                          const SizedBox(height: 10),
                          _Field(ctrl: _phoneCtrl, label: 'Phone Number', hint: 'Enter your phone',
                              type: TextInputType.phone),
                          const SizedBox(height: 10),
                          _Field(ctrl: _addrCtrl,  label: 'Address',      hint: 'Enter your full address'),
                          const SizedBox(height: 14),
                          Row(children: [
                            const Icon(Icons.radio_button_checked, color: kPrimary, size: 20),
                            const SizedBox(width: 8),
                            Text('Cash On Delivery', style: GoogleFonts.poppins(fontSize: 14)),
                          ]),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF007bff),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => _placeOrder(cart),
                              child: Text('Make Purchase',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QtyBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: onTap != null ? kPrimary.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: onTap != null ? kPrimary : Colors.grey, width: 0.8),
          ),
          child: Icon(icon, size: 16, color: onTap != null ? kPrimary : Colors.grey),
        ),
      );
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final TextInputType type;
  const _Field({required this.ctrl, required this.label, required this.hint, this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13)),
          const SizedBox(height: 4),
          TextFormField(
            controller: ctrl,
            keyboardType: type,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            validator: (v) => (v == null || v.isEmpty) ? '$label is required' : null,
          ),
        ],
      );
}

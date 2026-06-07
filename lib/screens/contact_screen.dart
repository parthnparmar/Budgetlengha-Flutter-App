import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../widgets/app_drawer.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey     = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _mobileCtrl  = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _submitted    = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _mobileCtrl.dispose(); _messageCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _submitted = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _submitted = false);
        _nameCtrl.clear(); _emailCtrl.clear();
        _mobileCtrl.clear(); _messageCtrl.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message sent successfully!'), backgroundColor: Colors.green),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Contact Us',
            style: GoogleFonts.josefinSans(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: kAccent),
            onPressed: () => launchUrl(Uri.parse('tel:+916359472166')),
            tooltip: '+91 63594 72166',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Quick contact cards
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.phone,
                    label: 'Call Us',
                    value: '+91 63594 72166',
                    color: Colors.green,
                    onTap: () => launchUrl(Uri.parse('tel:+916359472166')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.location_on,
                    label: 'Visit Us',
                    value: 'Valsad, Gujarat',
                    color: kPrimary,
                    onTap: () => launchUrl(Uri.parse('https://maps.google.com/?q=Valsad,Gujarat')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Form card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("We'd love to hear from you",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Fill the form below to send a message.',
                        style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 16),
                    _CField(ctrl: _nameCtrl,   label: 'Name',   hint: 'Your full name',  icon: Icons.person),
                    const SizedBox(height: 12),
                    _CField(
                      ctrl: _emailCtrl, label: 'Email', hint: 'Your email address', icon: Icons.email,
                      type: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _CField(ctrl: _mobileCtrl, label: 'Mobile', hint: 'Your mobile number', icon: Icons.phone,
                        type: TextInputType.phone),
                    const SizedBox(height: 12),
                    Text('Message', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _messageCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Write your message here...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Message required' : null,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF28a745),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _submitted ? null : _submit,
                        child: _submitted
                            ? const SizedBox(height: 20, width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text('Send Message',
                                style: GoogleFonts.poppins(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Address card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.store, color: kAccent, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nuriya's Clothing",
                            style: GoogleFonts.josefinSans(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        const Text(
                          'Hussain Sindhi, Near CB School,\nHalar Road, Valsad, Gujarat',
                          style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.5),
                        ),
                      ],
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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;
  const _InfoCard({required this.icon, required this.label, required this.value, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: Colors.grey, fontSize: 11), textAlign: TextAlign.center),
            ],
          ),
        ),
      );
}

class _CField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType type;
  final String? Function(String?)? validator;
  const _CField({required this.ctrl, required this.label, required this.hint, required this.icon,
      this.type = TextInputType.text, this.validator});

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: ctrl,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: kPrimary, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        validator: validator ?? (v) => (v == null || v.isEmpty) ? '$label required' : null,
      );
}

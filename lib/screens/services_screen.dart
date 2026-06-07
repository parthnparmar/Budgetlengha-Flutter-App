import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../widgets/app_drawer.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  static const _services = [
    {'icon': Icons.checkroom,       'title': 'Bridal Lehengas',    'desc': 'Stunning bridal lehengas for your special day.'},
    {'icon': Icons.celebration,     'title': 'Party Wear',         'desc': 'Gorgeous collections for every festive occasion.'},
    {'icon': Icons.style,           'title': 'Traditional Wear',   'desc': 'Authentic Indian ethnic wear for cultural events.'},
    {'icon': Icons.design_services, 'title': 'Custom Designs',     'desc': 'Bespoke lehenga designs tailored to your taste.'},
    {'icon': Icons.content_cut,     'title': 'Tailoring Services', 'desc': 'Expert stitching and alteration for a perfect fit.'},
    {'icon': Icons.local_shipping,  'title': 'Home Delivery',      'desc': 'Convenient cash-on-delivery across India.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text('Our Services',
            style: GoogleFonts.josefinSans(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero banner
            Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.asset('assets/images/hero.jpg', fit: BoxFit.cover),
                ),
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 16, left: 20,
                  child: Text('Our Services',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold,
                          shadows: [Shadow(blurRadius: 6, color: Colors.black54)])),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('We offer a variety of services tailored to your needs.',
                        style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.05,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _services.length,
                    itemBuilder: (ctx, i) {
                      final s = _services[i];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(s['icon'] as IconData, color: kPrimary, size: 36),
                              const SizedBox(height: 8),
                              Text(s['title'] as String,
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 4),
                              Text(s['desc'] as String,
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text('Our Location',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => launchUrl(Uri.parse('https://maps.google.com/?q=Valsad,Gujarat')),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: kPrimary, size: 32),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Hussain Sindhi, Next to Shiraz Dairy,\nnear CB School, Halar Road,\nValsad, Gujarat',
                              style: TextStyle(fontSize: 13, height: 1.6),
                            ),
                          ),
                          const Icon(Icons.open_in_new, color: kPrimary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

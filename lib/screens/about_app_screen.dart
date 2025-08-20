import 'package:flutter/material.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});
  static const id = "/about_app_screen";

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo Aplikasi
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                // color: Colors.blue[100],
                color: const Color(0xFFE8DEF8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 60,
                color: Color(0xFF6750A4),
              ),
            ),

            // Nama Aplikasi
            const Text(
              'Money Tracer',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4F378A),
              ),
            ),
            const SizedBox(height: 10),

            // Versi Aplikasi
            const Text(
              'Versi 1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Deskripsi Aplikasi
            const Card(
              color: Color(0xFFE8DEF8),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.description),
                      title: Text('Deskripsi Aplikasi'),
                      subtitle: Text(
                        'Aplikasi ini membantu Anda mencatat pemasukan dan pengeluaran keuangan sehari-hari dengan mudah dan terorganisir.',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fitur Unggulan
            const Card(
              color: Color(0xFFE8DEF8),
              elevation: 3,
              margin: EdgeInsets.only(top: 20),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.star),
                      title: Text('Fitur Unggulan'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.attach_money),
                      title: Text('Catatan Pemasukan'),
                      subtitle: Text('Record semua sumber pemasukan'),
                    ),
                    ListTile(
                      leading: Icon(Icons.money_off),
                      title: Text('Catatan Pengeluaran'),
                      subtitle: Text('Lacak semua pengeluaran'),
                    ),
                    ListTile(
                      leading: Icon(Icons.bar_chart),
                      title: Text('Rekapitulasi Keuangan'),
                      subtitle: Text('Perincian semua laporan pengeluaran'),
                    ),
                  ],
                ),
              ),
            ),
            // Copyright
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: const Text(
                '© 2025 Money Tracer. All rights reserved.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

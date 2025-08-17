import 'package:flutter/material.dart';
import 'package:tugas_13_laporan_keuangan_harian/widgets/button_action.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const id = "/dashboard_screen";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Tracker', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        // leading: Icon(Icons.more_vert),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF6750A4)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.balance_rounded, size: 64, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    "Money Tracker",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('Manajemen Akun'),
              onTap: () async {},
              // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen())),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Tambah Saldo'),
              onTap: () async {},
              // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen())),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Saldo'),
              onTap: () async {},
              // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen())),
            ),
            ListTile(
              leading: Icon(Icons.balance_rounded),
              title: Text('Rekap & Laporan Saldo'),
              onTap: () async {},
              // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen())),
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Keluar Sesi'),
              onTap: () async {
                // await Provider.of<AuthService>(context).logout();
                // Navigator.pushReplacementNamed(context, '/LoginScreen');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informasi saldo
                Container(
                  padding: EdgeInsets.all(16),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8DEF8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Saldo Dompet Anda:",
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF4F378A),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Rp25.912.800",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4F378A),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                // Menu (Tambah, Edit, Rekap)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildActionButton(
                      icon: Icons.add,
                      label: "Tambah",
                      color: Colors.blue,
                    ),
                    buildActionButton(
                      icon: Icons.edit,
                      label: "Edit",
                      color: Colors.green,
                    ),
                    buildActionButton(
                      icon: Icons.balance,
                      label: "Rekap",
                      color: Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // currentIndex: _selectedIndex > 2 ? 0 : _selectedIndex,
        // 0 untuk dashboard, 1 untuk about, dan 2 untuk tombol logout
        // Kalau lagi buka drawer menu, bottomnav tetap highlight dashboard
        // onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tips_and_updates),
            label: 'Tip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Keluar',
          ),
        ],
      ),
    );
  }
}

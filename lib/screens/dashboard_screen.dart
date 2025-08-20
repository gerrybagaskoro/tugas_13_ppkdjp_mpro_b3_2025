// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:tugas_13_laporan_keuangan_harian/main.dart';
import 'package:tugas_13_laporan_keuangan_harian/models/transaction.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/add_transaction_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/edit_transaction_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/login_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/profile_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/report_transaction_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/user_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/sqflite/db_helper.dart';
import 'package:tugas_13_laporan_keuangan_harian/widgets/button_action.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const id = "/dashboard_screen";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void _showEditOptions(BuildContext context) {
    if (transaksiList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada transaksi untuk diedit')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Transaksi untuk Diedit'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: transaksiList.length,
              itemBuilder: (context, index) {
                final transaksi = transaksiList[index];
                return ListTile(
                  title: Text(transaksi.kategori),
                  subtitle: Text(
                    '${formatCurrency(transaksi.jumlah)} - ${transaksi.tanggal.day}/${transaksi.tanggal.month}/${transaksi.tanggal.year}',
                  ),
                  trailing: Icon(Icons.edit),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditTransactionScreen(transaksi: transaksi),
                      ),
                    ).then((_) => _loadData()); // Reload data setelah kembali
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<Transaksi> transaksiList = [];
  double totalSaldo = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final transaksi = await DbHelper.getAllTransaksi();
    final saldo = await DbHelper.getTotalSaldo();

    setState(() {
      transaksiList = transaksi;
      totalSaldo = saldo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Tracker', style: TextStyle(fontSize: 20)),
        centerTitle: true,
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
              leading: Icon(Icons.person),
              title: Text('Profil'),
              // onTap: () => _onDrawerTapped(0),
              // onTap: () async {},
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('Manajemen Akun'),
              // onTap: () => _onDrawerTapped(0),
              // onTap: () async {},
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Tambah Saldo'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTransactionScreen()),
              ),
              // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen())),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Saldo'),
              // onTap: () => Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => EditTransactionScreen(),
              //   ),
              // ),
              // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen())),
            ),
            ListTile(
              leading: Icon(Icons.balance_rounded),
              title: Text('Rekap & Laporan Saldo'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportTransactionScreen(),
                ),
              ),
              // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen())),
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Keluar Sesi'),
              onTap: () {
                // Tampilkan dialog konfirmasi
                _showLogoutConfirmation(context);
              },

              // onTap: () => _onDrawerTapped(1),
              // onTap: () async {},
              // await Provider.of<AuthService>(context).logout();
              // Navigator.pushReplacementNamed(context, MaterialPageRoute(builder: (context) => LoginScreen()))
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
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8DEF8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        "Saldo Dompet Anda:",
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF4F378A),
                        ),
                      ),
                      SizedBox(height: 4),

                      Text(
                        formatCurrency(totalSaldo), // Ganti yang lama
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4F378A),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          actionButton(
                            icon: Icons.add,
                            label: "Tambah",
                            color: Colors.blue,
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/add_transaction_screen',
                            ),
                          ),
                          actionButton(
                            icon: Icons.edit,
                            label: "Edit",
                            color: Colors.green,
                            onTap: () => _showEditOptions(context),
                          ),
                          actionButton(
                            icon: Icons.balance,
                            label: "Rekap",
                            color: Colors.amber,
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/report_transaction_screen',
                            ),
                          ),
                          actionButton(
                            icon: Icons.person,
                            label: "Profil",
                            color: Colors.grey,
                            onTap: () =>
                                Navigator.pushNamed(context, '/profile_screen'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text("Riwayat Transaksi", style: TextStyle(fontSize: 16)),
                SizedBox(height: 12),
                Column(
                  children: transaksiList.map((transaksi) {
                    return _buildTransactionItem(transaksi);
                  }).toList(),
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

void _showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Konfirmasi Keluar"),
        content: const Text("Apakah Anda yakin ingin keluar dari akun anda?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Keluar", style: TextStyle(color: Colors.red)),
            onPressed: () {
              // Tutup dialog
              Navigator.pop(context);
              // Tutup drawer
              Navigator.pop(context);
              // Navigasi ke login screen tanpa bisa kembali
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
          ),
        ],
      );
    },
  );
}

Widget _incomeTransactionItem(String type, String amount, String date) {
  return Card(
    margin: EdgeInsets.all(8),
    child: Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatCurrency(double.parse(amount)), // Ganti yang lama
            style: TextStyle(
              fontSize: 18,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            type,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(date, style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    ),
  );
}

Widget _outcomeTransactionItem(String type, String amount, String date) {
  return Card(
    margin: EdgeInsets.all(8),
    child: Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatCurrency(double.parse(amount)), // Ganti yang lama
            style: TextStyle(
              fontSize: 18,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            type,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(date, style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    ),
  );
}

Widget _buildTransactionItem(Transaksi transaksi) {
  return Card(
    margin: EdgeInsets.all(8),
    child: ListTile(
      title: Text(
        transaksi.deskripsi.isNotEmpty
            ? transaksi.deskripsi
            : transaksi.kategori,
      ),
      subtitle: Text(
        '${transaksi.tanggal.day}/${transaksi.tanggal.month}/${transaksi.tanggal.year}',
      ),
      trailing: Text(
        formatCurrency(transaksi.jumlah), // Ganti yang lama
        style: TextStyle(
          color: transaksi.jenis == 'Pemasukan' ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

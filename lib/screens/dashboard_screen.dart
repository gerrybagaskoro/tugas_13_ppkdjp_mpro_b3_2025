// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tugas_13_laporan_keuangan_harian/main.dart';
import 'package:tugas_13_laporan_keuangan_harian/models/transaction.dart';
import 'package:tugas_13_laporan_keuangan_harian/preference/shared_preference.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/about_app_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/add_transaction_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/edit_transaction_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/login_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/profile_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/report_transaction_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/statistic_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/user_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/sqflite/db_helper.dart';
import 'package:tugas_13_laporan_keuangan_harian/utils/category_constants.dart';
import 'package:tugas_13_laporan_keuangan_harian/widgets/button_action.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const id = "/dashboard_screen";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Transaksi> transaksiList = [];
  double totalSaldo = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    initializeDateFormatting(
      'id_ID',
      null,
    ); // Untuk inisialisasi format tanggal Indonesia
  }

  Future<void> _loadData() async {
    final transaksi = await DbHelper.getAllTransaksi();
    final saldo = await DbHelper.getTotalSaldo();

    // Pastikan widget masih ada sebelum memanggil setState
    if (mounted) {
      setState(() {
        transaksiList = transaksi;
        totalSaldo = saldo;
      });
    }
  }

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
          title: Text(
            'Pilih transaksi untuk di-edit',
            style: TextStyle(fontSize: 20),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: transaksiList.length,
              itemBuilder: (context, index) {
                final transaksi = transaksiList[index];
                final isPemasukan = transaksi.jenis == 'Pemasukan';
                final amountColor = isPemasukan ? Colors.green : Colors.red;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  elevation: 2,
                  child: ListTile(
                    leading: Text(
                      CategoryConstants.getEmojiForCategory(transaksi.kategori),
                      style: TextStyle(fontSize: 20),
                    ),
                    title: Text(transaksi.kategori), // Tetap warna default
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatTanggal(
                            transaksi.tanggal,
                          ), // Tetap warna default
                        ),
                        Text(
                          formatCurrency(transaksi.jumlah),
                          style: TextStyle(
                            color: amountColor, // Hanya jumlah yang diwarnai
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.edit), // Tetap warna default
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditTransactionScreen(transaksi: transaksi),
                        ),
                      ).then((_) => _loadData());
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
  // void _showEditOptions(BuildContext context) {
  //   if (transaksiList.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Tidak ada transaksi untuk diedit')),
  //     );
  //     return;
  //   }

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Pilih transaksimu untuk di edit:',
  //           style: TextStyle(fontSize: 20),
  //         ),
  //         content: SizedBox(
  //           width: double.maxFinite,
  //           height: 300,
  //           child: ListView.builder(
  //             itemCount: transaksiList.length,
  //             itemBuilder: (context, index) {
  //               final transaksi = transaksiList[index];
  //               return Card(
  //                 margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
  //                 elevation: 2,
  //                 child: ListTile(
  //                   title: Text(transaksi.kategori),
  //                   subtitle: Text(
  //                     '${formatCurrency(transaksi.jumlah)} - ${transaksi.tanggal.day}/${transaksi.tanggal.month}/${transaksi.tanggal.year}',
  //                   ),
  //                   trailing: Icon(Icons.edit),
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) =>
  //                             EditTransactionScreen(transaksi: transaksi),
  //                       ),
  //                     ).then((_) => _loadData());
  //                   },
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
                  Icon(
                    Icons.account_balance_wallet,
                    size: 64,
                    color: Colors.white,
                  ),
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
              title: Text('Profil Saya'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('Manajemen Akun'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Tambah Saldo'),
              // --- PERBAIKAN 2 DI SINI ---
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTransactionScreen(),
                  ),
                ).then((_) => _loadData()); // Muat ulang data setelah kembali
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Saldo'),
              onTap: () {
                _showEditOptions(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.balance_rounded),
              title: Text('Rekap Saldo'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportTransactionScreen(),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.pie_chart),
              title: Text('Statistik'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatisticsScreen()),
              ),
            ),

            Divider(),
            ListTile(
              leading: Icon(Icons.android),
              title: Text('Tentang Aplikasi'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutAppScreen()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Keluar Sesi'),
              onTap: () {
                // Tampilkan dialog konfirmasi
                _showLogoutConfirmation(context);
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
                        formatCurrency(totalSaldo),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4F378A),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          actionButton(
                            icon: Icons.add,
                            label: "Tambah",
                            color: Colors.blue,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/add_transaction_screen',
                              ).then(
                                (_) => _loadData(),
                              ); // Muat ulang data setelah kembali
                            },
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
                            icon: Icons.pie_chart,
                            label: "Statistik",
                            color: Colors.purple,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StatisticsScreen(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text("Riwayat Transaksi :", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                // Tampilkan pesan jika tidak ada transaksi
                transaksiList.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Text(
                            'Belum ada transaksi.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      )
                    : Column(
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
        onTap: (index) {
          if (index == 2) {
            // Index 2 adalah tombol Keluar
            _showLogoutConfirmation(context);
          }
        },
      ),
    );
  }
}

void _showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animasi Lottie
              SizedBox(
                height: 120,
                child: Lottie.asset(
                  'assets/images/animations/logout_animation.json',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Keluar Sesi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                "Apakah Anda yakin ingin keluar dari akun anda?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text("Batal"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    child: Text("Keluar", style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      // 1. Hapus data login dari shared preferences
                      PreferenceHandler.removeLogin();
                      // 2. Navigasi ke halaman login dan hapus riwayat halaman sebelumnya
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(LoginScreen.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

String _formatTanggal(DateTime tanggal) {
  final format = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
  return format.format(tanggal);
}

Widget _buildTransactionItem(Transaksi transaksi) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    child: ListTile(
      leading: Text(
        CategoryConstants.getEmojiForCategory(transaksi.kategori),
        style: TextStyle(fontSize: 24),
      ),
      title: Text(
        transaksi.deskripsi.isNotEmpty
            ? transaksi.deskripsi
            : transaksi.kategori,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(_formatTanggal(transaksi.tanggal)),
      trailing: Text(
        formatCurrency(transaksi.jumlah),
        style: TextStyle(
          color: transaksi.jenis == 'Pemasukan' ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    ),
  );
}

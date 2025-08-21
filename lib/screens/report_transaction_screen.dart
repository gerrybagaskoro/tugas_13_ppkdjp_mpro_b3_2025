// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tugas_13_laporan_keuangan_harian/main.dart';
import 'package:tugas_13_laporan_keuangan_harian/sqflite/db_helper.dart';

class ReportTransactionScreen extends StatefulWidget {
  static const id = '/report_transaction_screen';

  const ReportTransactionScreen({super.key});

  @override
  _ReportTransactionScreenState createState() =>
      _ReportTransactionScreenState();
}

class _ReportTransactionScreenState extends State<ReportTransactionScreen> {
  double totalPemasukan = 0;
  double totalPengeluaran = 0;
  double saldo = 0;

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    final allTransaksi = await DbHelper.getAllTransaksi();

    double pemasukan = 0;
    double pengeluaran = 0;

    for (var transaksi in allTransaksi) {
      if (transaksi.jenis == 'Pemasukan') {
        pemasukan += transaksi.jumlah;
      } else {
        pengeluaran += transaksi.jumlah;
      }
    }

    setState(() {
      totalPemasukan = pemasukan;
      totalPengeluaran = pengeluaran;
      saldo = pemasukan - pengeluaran;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rekap Transaksi'),
        // backgroundColor: Color(0xFF6750A4),
        // foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card untuk Total Pemasukan dan Pengeluaran
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Total Pemasukan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pemasukan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          formatCurrency(totalPemasukan),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Total Pengeluaran
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pengeluaran',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          formatCurrency(totalPengeluaran),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Divider dengan teks Saldo Akhir
            Row(
              children: [
                Expanded(child: Divider(thickness: 1, color: Colors.grey[400])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Saldo Akhir',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: Divider(thickness: 1, color: Colors.grey[400])),
              ],
            ),
            SizedBox(height: 20),
            // Card untuk Saldo Akhir
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: saldo >= 0 ? Colors.green[50] : Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    formatCurrency(saldo),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: saldo >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Tombol Refresh
            // ElevatedButton(
            //   onPressed: _loadReportData,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Color(0xFF6750A4),
            //     foregroundColor: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     minimumSize: Size(double.infinity, 50),
            //   ),
            //   child: Text('Refresh Data'),
            // ),
          ],
        ),
      ),
    );
  }
}

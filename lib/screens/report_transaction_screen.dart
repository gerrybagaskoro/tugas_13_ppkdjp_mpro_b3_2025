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
      appBar: AppBar(title: Text('Laporan Keuangan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Saldo saat ini', style: TextStyle(fontSize: 18)),
                  Text(
                    formatCurrency(saldo),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.green[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Pemasukan Total',
                            style: TextStyle(color: Colors.green),
                          ),
                          Text(
                            // 'Rp${totalPemasukan.toStringAsFixed(2)}',
                            formatCurrency(totalPemasukan),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.red[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Pengeluaran Total',
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(
                            formatCurrency(totalPengeluaran),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadReportData,
              child: Text('Refresh Data'),
            ),
          ],
        ),
      ),
    );
  }
}

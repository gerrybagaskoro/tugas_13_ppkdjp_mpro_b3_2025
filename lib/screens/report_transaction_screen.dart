import 'package:flutter/material.dart';

class ReportTransactionScreen extends StatefulWidget {
  const ReportTransactionScreen({super.key});
  static const id = "/report_transaction_screen";

  @override
  State<ReportTransactionScreen> createState() =>
      _ReportTransactionScreenState();
}

class _ReportTransactionScreenState extends State<ReportTransactionScreen> {
  final int _value = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Laporan & Filter Saldo")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        "Saldo terkini:",
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF4F378A),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Rp25.000.000",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4F378A),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text("Tipe Transaksi"),
                DropdownButton(
                  // value: pilihDropDown,
                  hint: Text("Pilih Opsi Transaksi"),
                  items: ["Pendapatan", "Pengeluaran"].map((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      // pilihDropDown = value!;
                    });
                  },
                ),
                ListTile(
                  title: Text("Pemasukan"),
                  leading: Radio(
                    groupValue: _value,
                    value: 1,
                    onChanged: (value) {},
                  ),
                ),
                ListTile(
                  title: Text("Pengeluaran"),
                  leading: Radio(
                    groupValue: _value,
                    value: 2,
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(height: 8),
                Text("Masukkan Nominal"),
                TextField(),
                SizedBox(height: 8),
                Text("Masukkan Deskripsi"),
                TextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

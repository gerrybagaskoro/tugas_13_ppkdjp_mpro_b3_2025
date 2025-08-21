// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tugas_13_laporan_keuangan_harian/models/transaction.dart';
// import 'package:tugas_13_laporan_keuangan_harian/models/transaksi.dart';
import 'package:tugas_13_laporan_keuangan_harian/sqflite/db_helper.dart';
import 'package:tugas_13_laporan_keuangan_harian/utils/currency_input_formatter.dart';

class AddTransactionScreen extends StatefulWidget {
  static const id = '/add_transaction_screen';

  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  String selectedJenis = 'Pemasukan';
  DateTime selectedDate = DateTime.now();

  List<String> kategoriPemasukan = ['Gaji', 'Bonus', 'Investasi', 'Lainnya'];
  List<String> kategoriPengeluaran = [
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Tagihan',
    'Lainnya',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: selectedJenis,
                items: ['Pemasukan', 'Pengeluaran'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedJenis = newValue!;
                    kategoriController.text = '';
                  });
                },
                decoration: InputDecoration(labelText: 'Jenis Transaksi'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                decoration: InputDecoration(labelText: 'Jumlah'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jumlah transaksi';
                  }

                  // Hapus format currency untuk validasi
                  String cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
                  if (double.tryParse(cleanValue) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value:
                    kategoriController.text.isEmpty ||
                        !(selectedJenis == 'Pemasukan'
                                ? kategoriPemasukan
                                : kategoriPengeluaran)
                            .contains(kategoriController.text)
                    ? null
                    : kategoriController.text,
                items:
                    (selectedJenis == 'Pemasukan'
                            ? kategoriPemasukan
                            : kategoriPengeluaran)
                        .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                        .toList(),
                onChanged: (newValue) {
                  setState(() {
                    kategoriController.text = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Kategori'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih kategori';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: deskripsiController,
                decoration: InputDecoration(labelText: 'Deskripsi (opsional)'),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Tanggal'),
                subtitle: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Hapus format currency sebelum menyimpan
                    String cleanValue = jumlahController.text.replaceAll(
                      RegExp(r'[^\d]'),
                      '',
                    );

                    Transaksi newTransaksi = Transaksi(
                      jenis: selectedJenis,
                      jumlah: double.parse(cleanValue),
                      kategori: kategoriController.text,
                      deskripsi: deskripsiController.text,
                      tanggal: selectedDate,
                    );

                    await DbHelper.addTransaksi(newTransaksi);
                    Navigator.pop(context);
                  }
                },
                child: Text('Simpan Transaksi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

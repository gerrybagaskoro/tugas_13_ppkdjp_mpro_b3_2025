// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tugas_13_laporan_keuangan_harian/models/transaction.dart';
// import 'package:tugas_13_laporan_keuangan_harian/models/transaksi.dart';
import 'package:tugas_13_laporan_keuangan_harian/sqflite/db_helper.dart';

class EditTransactionScreen extends StatefulWidget {
  static const id = '/edit_transaction_screen';
  final Transaksi transaksi;

  const EditTransactionScreen({super.key, required this.transaksi});

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController jumlahController;
  late TextEditingController kategoriController;
  late TextEditingController deskripsiController;

  late String selectedJenis;
  late DateTime selectedDate;

  List<String> kategoriPemasukan = ['Gaji', 'Bonus', 'Investasi', 'Lainnya'];
  List<String> kategoriPengeluaran = [
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Tagihan',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    selectedJenis = widget.transaksi.jenis;
    jumlahController = TextEditingController(
      text: widget.transaksi.jumlah.toString(),
    );
    kategoriController = TextEditingController(text: widget.transaksi.kategori);
    deskripsiController = TextEditingController(
      text: widget.transaksi.deskripsi,
    );
    selectedDate = widget.transaksi.tanggal;
  }

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
      appBar: AppBar(title: Text('Edit Transaksi')),
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
                    if (!(selectedJenis == 'Pemasukan'
                            ? kategoriPemasukan
                            : kategoriPengeluaran)
                        .contains(kategoriController.text)) {
                      kategoriController.text = '';
                    }
                  });
                },
                decoration: InputDecoration(labelText: 'Jenis Transaksi'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah',
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jumlah transaksi';
                  }
                  if (double.tryParse(value) == null) {
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
                  setState(() {});
                  kategoriController.text = newValue!;
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
                decoration: InputDecoration(labelText: 'Deskripsi (Opsional)'),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Tanggal Transaksi'),
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
                    Transaksi updatedTransaksi = Transaksi(
                      id: widget.transaksi.id,
                      jenis: selectedJenis,
                      jumlah: double.parse(jumlahController.text),
                      kategori: kategoriController.text,
                      deskripsi: deskripsiController.text,
                      tanggal: selectedDate,
                    );

                    await DbHelper.updateTransaksi(updatedTransaksi);
                    Navigator.pop(context);
                  }
                },
                child: Text('Perbarui Transaksi'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await DbHelper.deleteTransaksi(widget.transaksi.id!);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  'Hapus Transaksi',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

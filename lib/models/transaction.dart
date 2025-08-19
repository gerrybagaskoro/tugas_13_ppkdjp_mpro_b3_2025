// transaksi.dart
import 'dart:convert';

class Transaksi {
  final int? id;
  final String jenis;
  final double jumlah;
  final String kategori;
  final String deskripsi;
  final DateTime tanggal;

  Transaksi({
    this.id,
    required this.jenis,
    required this.jumlah,
    required this.kategori,
    required this.deskripsi,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jenis': jenis,
      'jumlah': jumlah,
      'kategori': kategori,
      'deskripsi': deskripsi,
      'tanggal': tanggal.toIso8601String(),
    };
  }

  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      jenis: map['jenis'],
      jumlah: map['jumlah'],
      kategori: map['kategori'],
      deskripsi: map['deskripsi'],
      tanggal: DateTime.parse(map['tanggal']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaksi.fromJson(String source) =>
      Transaksi.fromMap(json.decode(source));
}

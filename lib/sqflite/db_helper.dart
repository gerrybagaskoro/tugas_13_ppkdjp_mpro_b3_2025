// import 'package:path_provider/path_provider.dart'; // Tidak selalu dibutuhkan
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// a. TAMBAHKAN IMPORT UNTUK MODEL TRANSAKSI
import 'package:tugas_13_laporan_keuangan_harian/models/transaction.dart';
import 'package:tugas_13_laporan_keuangan_harian/models/users.dart';

class DbHelper {
  static Future<Database> databaseHelper() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'login.db'),
      onCreate: (db, version) {
        // Eksekusi pembuatan tabel users
        db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, email TEXT, password TEXT, name TEXT)',
        );

        // b. TAMBAHKAN PERINTAH PEMBUATAN TABEL TRANSAKSI DI SINI
        db.execute('''
          CREATE TABLE IF NOT EXISTS transaksi (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            jenis TEXT NOT NULL,
            jumlah REAL NOT NULL,
            kategori TEXT NOT NULL,
            deskripsi TEXT,
            tanggal TEXT NOT NULL
          )
        ''');
      },
      version:
          2, // Jika Anda mengubah skema di database yang sudah ada, naikkan versi ini
    );
  }

  // =======================================================
  // == METODE UNTUK USERS (KODE LAMA ANDA)
  // =======================================================

  static Future<void> registerUser(User user) async {
    final db = await databaseHelper();
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<User?> loginUser(String email, String password) async {
    final db = await databaseHelper();
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }

  static Future<List<User>> getAllUsers() async {
    final db = await databaseHelper();
    final List<Map<String, dynamic>> results = await db.query('users');
    return results.map((e) => User.fromMap(e)).toList();
  }

  static Future<void> updateUser(User user) async {
    final db = await databaseHelper();
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteUser(int id) async {
    final db = await databaseHelper();
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // =======================================================
  // == c. SEMUA METODE BARU UNTUK TRANSAKSI DITAMBAHKAN DI SINI
  // =======================================================

  static Future<int> addTransaksi(Transaksi transaksi) async {
    final db = await databaseHelper();
    return await db.insert('transaksi', transaksi.toMap());
  }

  static Future<List<Transaksi>> getAllTransaksi() async {
    final db = await databaseHelper();
    final List<Map<String, dynamic>> results = await db.query(
      'transaksi',
      orderBy: 'tanggal DESC',
    );
    return results.map((map) => Transaksi.fromMap(map)).toList();
  }

  static Future<int> updateTransaksi(Transaksi transaksi) async {
    final db = await databaseHelper();
    return await db.update(
      'transaksi',
      transaksi.toMap(),
      where: 'id = ?',
      whereArgs: [transaksi.id],
    );
  }

  static Future<int> deleteTransaksi(int id) async {
    final db = await databaseHelper();
    return await db.delete('transaksi', where: 'id = ?', whereArgs: [id]);
  }

  static Future<double> getTotalSaldo() async {
    // final db = await databaseHelper();
    final List<Transaksi> allTransaksi = await getAllTransaksi();

    double total = 0;
    for (var transaksi in allTransaksi) {
      if (transaksi.jenis == 'Pemasukan') {
        total += transaksi.jumlah;
      } else {
        total -= transaksi.jumlah;
      }
    }
    return total;
  }

  static Future<void> initDatabase() async {}
}

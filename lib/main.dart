import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/add_transaction_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/dashboard_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/login_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/profile_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/register_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/report_transaction_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/splash_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/sqflite/db_helper.dart';

String formatCurrency(double amount) {
  final format = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return format.format(amount);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting("id_ID");
  await DbHelper.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        DashboardScreen.id: (context) => DashboardScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        '/profile_screen': (context) => ProfileScreen(),
        '/add_transaction_screen': (context) => AddTransactionScreen(),
        // '/edit_transaction_screen': (context) => EditTransactionScreen(),
        '/report_transaction_screen': (context) => ReportTransactionScreen(),
      },
    );
  }
}

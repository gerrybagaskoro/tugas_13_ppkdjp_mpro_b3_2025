import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/add_transaction_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/dashboard_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/edit_transaction_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/login_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/register_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/report_transaction_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/splash_screen.dart';

void main() {
  initializeDateFormatting("id_ID");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        '/add_transaction_screen': (context) => AddTransactionScreen(),
        '/edit_transaction_screen': (context) => EditTransactionScreen(),
        '/report_transaction_screen': (context) => ReportTransactionScreen(),
      },
    );
  }
}

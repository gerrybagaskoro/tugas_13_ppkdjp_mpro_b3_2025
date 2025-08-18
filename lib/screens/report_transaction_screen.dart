import 'package:flutter/material.dart';

class ReportTransactionScreen extends StatefulWidget {
  const ReportTransactionScreen({super.key});
  static const id = "/report_transaction_screen";

  @override
  State<ReportTransactionScreen> createState() =>
      _ReportTransactionScreenState();
}

class _ReportTransactionScreenState extends State<ReportTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Laporan & Filter Saldo")));
  }
}

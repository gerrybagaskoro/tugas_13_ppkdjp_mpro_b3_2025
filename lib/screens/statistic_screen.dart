// statistics_screen.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tugas_13_laporan_keuangan_harian/sqflite/db_helper.dart';
import 'package:tugas_13_laporan_keuangan_harian/utils/category_constants.dart';

class StatisticsScreen extends StatefulWidget {
  static const id = '/statistics_screen';

  const StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, double> pemasukanByKategori = {};
  Map<String, double> pengeluaranByKategori = {};
  double totalPemasukan = 0;
  double totalPengeluaran = 0;
  int touchedIndexPemasukan = -1;
  int touchedIndexPengeluaran = -1;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final allTransaksi = await DbHelper.getAllTransaksi();

    Map<String, double> pemasukanTemp = {};
    Map<String, double> pengeluaranTemp = {};
    double totalPemasukanTemp = 0;
    double totalPengeluaranTemp = 0;

    for (var transaksi in allTransaksi) {
      if (transaksi.jenis == 'Pemasukan') {
        totalPemasukanTemp += transaksi.jumlah;
        pemasukanTemp[transaksi.kategori] =
            (pemasukanTemp[transaksi.kategori] ?? 0) + transaksi.jumlah;
      } else {
        totalPengeluaranTemp += transaksi.jumlah;
        pengeluaranTemp[transaksi.kategori] =
            (pengeluaranTemp[transaksi.kategori] ?? 0) + transaksi.jumlah;
      }
    }

    setState(() {
      pemasukanByKategori = pemasukanTemp;
      pengeluaranByKategori = pengeluaranTemp;
      totalPemasukan = totalPemasukanTemp;
      totalPengeluaran = totalPengeluaranTemp;
    });
  }

  List<PieChartSectionData> _buildPieChartData(
    Map<String, double> data,
    List<Color> colors,
    int touchedIndex,
  ) {
    final List<PieChartSectionData> pieChartData = [];
    int colorIndex = 0;

    data.forEach((category, amount) {
      final isTouched = colorIndex == touchedIndex;
      final double fontSize = isTouched ? 14 : 12;
      final double radius = isTouched ? 50 : 40; // Diperkecil

      pieChartData.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: amount,
          title: isTouched
              ? '${((amount / (data == pemasukanByKategori ? totalPemasukan : totalPengeluaran)) * 100).toStringAsFixed(1)}%'
              : '',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

      colorIndex++;
    });

    return pieChartData;
  }

  Widget _buildPieChart(
    String title,
    Map<String, double> data,
    List<Color> colors,
    int touchedIndex,
    Function(int) onTouchCallback,
  ) {
    if (data.isEmpty) {
      return SizedBox(
        height: 180, // Diperkecil
        child: Center(
          child: Text(
            'Tidak ada data $title',
            style: TextStyle(color: const Color(0xFF4F378A), fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16, // Diperkecil
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4F378A),
            ),
          ),
        ),
        SizedBox(
          height: 150, // Diperkecil
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          onTouchCallback(-1);
                          return;
                        }
                        onTouchCallback(
                          pieTouchResponse.touchedSection!.touchedSectionIndex,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2, // Diperkecil
                    centerSpaceRadius: 30, // Diperkecil
                    sections: _buildPieChartData(data, colors, touchedIndex),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildLegend(data, colors),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildLegend(Map<String, double> data, List<Color> colors) {
    final List<Widget> legendItems = [];
    int index = 0;

    data.forEach((category, amount) {
      final color = colors[index % colors.length];
      final percentage =
          (amount /
              (data == pemasukanByKategori
                  ? totalPemasukan
                  : totalPengeluaran)) *
          100;

      legendItems.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(width: 12, height: 12, color: color),
              SizedBox(width: 6),
              Text(
                CategoryConstants.getEmojiForCategory(category),
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  category,
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 6),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );

      index++;
    });

    return legendItems;
  }

  @override
  Widget build(BuildContext context) {
    // Warna untuk pie chart
    final List<Color> pemasukanColors = [
      Colors.green,
      Colors.lightGreen,
      Colors.greenAccent,
      Colors.teal,
      Colors.cyan,
    ];

    final List<Color> pengeluaranColors = [
      Colors.red,
      Colors.orange,
      Colors.deepOrange,
      Colors.pink,
      Colors.purple,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistik Transaksi'),
        // backgroundColor: Color(0xFF6750A4),
        // foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0), // Diperkecil
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: const Color(0xFFE8DEF8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0), // Diperkecil
                  child: _buildPieChart(
                    'Pemasukan',
                    pemasukanByKategori,
                    pemasukanColors,
                    touchedIndexPemasukan,
                    (index) {
                      setState(() {
                        touchedIndexPemasukan = index;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: const Color(0xFFE8DEF8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0), // Diperkecil
                  child: _buildPieChart(
                    'Pengeluaran',
                    pengeluaranByKategori,
                    pengeluaranColors,
                    touchedIndexPengeluaran,
                    (index) {
                      setState(() {
                        touchedIndexPengeluaran = index;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: _loadStatistics,
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Color(0xFF6750A4),
              //     foregroundColor: Colors.white,
              //     minimumSize: Size(double.infinity, 40), // Diperkecil
              //   ),
              //   child: Text(
              //     'Perbarui Statistik',
              //     style: TextStyle(fontSize: 14),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

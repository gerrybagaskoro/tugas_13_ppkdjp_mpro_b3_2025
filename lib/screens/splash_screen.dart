// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tugas_13_laporan_keuangan_harian/extensions/navigations.dart';
import 'package:tugas_13_laporan_keuangan_harian/preference/shared_preference.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/dashboard_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/login_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/utils/app_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const id = "/splash_screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    bool? isLogin = await PreferenceHandler.getLogin();

    Future.delayed(Duration(seconds: 3)).then((value) async {
      //
      if (isLogin == true) {
        context.pushReplacementNamed(DashboardScreen.id);
      } else {
        context.pushReplacement(LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6750A4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset(AppImage.iconDashboard, fit: BoxFit.contain),
            ),
            const SizedBox(height: 16), // Jarak tambahan
            const Text(
              "Money Tracker",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

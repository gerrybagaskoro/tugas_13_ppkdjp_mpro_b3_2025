// auth_service.dart
import 'package:flutter/material.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/login_screen.dart';

class AuthService {
  static void logout(BuildContext context) {
    // Hapus token/session disini jika ada
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }
}

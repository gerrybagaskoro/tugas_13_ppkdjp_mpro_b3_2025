import 'package:flutter/material.dart';
import 'package:tugas_13_laporan_keuangan_harian/extensions/navigations.dart';
import 'package:tugas_13_laporan_keuangan_harian/preference/shared_preference.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/login_screen.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        PreferenceHandler.removeLogin();
        context.pushReplacementNamed(LoginScreen.id);
      },
      child: Text("Keluar"),
    );
  }
}

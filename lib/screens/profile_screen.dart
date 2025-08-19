import 'package:flutter/material.dart';
import 'package:tugas_13_laporan_keuangan_harian/utils/profile_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const id = "/profile_screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil Saya"), centerTitle: true),
      body: Center(
        // padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Nama
            SizedBox(
              width: 240,
              height: 240,
              child: Image.asset(ProfileImage.iconProfile, fit: BoxFit.contain),
            ),
            const SizedBox(height: 12),
            Text(
              'Gerry Bagaskoro Putro',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

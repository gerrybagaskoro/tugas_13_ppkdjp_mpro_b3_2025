import 'package:flutter/material.dart';

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
      appBar: AppBar(title: const Text('Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto Profile dengan Bingkai Circle
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE8DEF8), // Warna bingkai
                  width: 7.5, // Tebal bingkai
                ),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/profile/kano.jpg"),
                radius: 120, // Ukuran radius
              ),
            ),

            // Informasi Developer
            Card(
              color: const Color(0xFFE8DEF8),
              elevation: 3,
              margin: const EdgeInsets.only(top: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.blue[700]),
                      title: const Text('Gerry Bagaskoro Putro'),
                      subtitle: const Text('Mobile Programming Developer'),
                    ),
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.blue[700]),
                      title: const Text('Email'),
                      subtitle: const Text('my.gerry139@gmail.com'),
                    ),
                    ListTile(
                      leading: Icon(Icons.language, color: Colors.blue[700]),
                      title: const Text('Github'),
                      subtitle: const Text('https://github.com/gerrybagaskoro'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

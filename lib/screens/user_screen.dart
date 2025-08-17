// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tugas_13_laporan_keuangan_harian/models/users.dart';
import 'package:tugas_13_laporan_keuangan_harian/sqflite/db_helper.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<User> users = [];
  @override
  void initState() {
    super.initState();
    getUser();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> getUser() async {
    final dataUser = await DbHelper.getAllUsers();
    setState(() {
      users = dataUser;
    });
  }

  // Fungsi untuk menampilkan dialog edit
  void _showEditDialog(BuildContext context, User dataUserLogin) {
    // Buat controller baru khusus untuk dialog
    final editNameController = TextEditingController(text: dataUserLogin.name);
    final editEmailController = TextEditingController(
      text: dataUserLogin.email,
    );
    final editPasswordController = TextEditingController(
      text: dataUserLogin.password,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormConst(controller: editNameController, hintText: 'Nama'),
            const SizedBox(height: 12),
            TextFormConst(controller: editEmailController, hintText: 'Email'),
            const SizedBox(height: 12),
            TextFormConst(
              controller: editPasswordController,
              hintText: 'Password',
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final updatedUser = User(
                id: dataUserLogin.id!,
                email: editEmailController.text,
                password: editPasswordController.text,
                name: editNameController.text.trim(),
              );
              DbHelper.updateUser(updatedUser);
              getUser();
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Akun')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text("Daftar Akun", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextFormConst(hintText: "Nama", controller: nameController),
            const SizedBox(height: 8),
            TextFormConst(hintText: "Email", controller: emailController),
            const SizedBox(height: 8),
            TextFormConst(hintText: "Password", controller: passwordController),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                final name = nameController.text.trim();

                if (email.isEmpty || password.isEmpty || name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Email, Password, dan Nama tidak boleh kosong",
                      ),
                    ),
                  );
                  return;
                }

                final user = User(email: email, password: password, name: name);
                await DbHelper.registerUser(user);

                // Membersihkan Form setelah disimpan
                nameController.clear();
                emailController.clear();
                passwordController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pendaftaran berhasil")),
                );

                getUser();
              },
              child: const Text("Simpan Data"),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final dataUserLogin = users[index];
                return ListTile(
                  title: Text(dataUserLogin.name!),
                  subtitle: Text(dataUserLogin.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () =>
                            _showEditDialog(context, dataUserLogin),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          DbHelper.deleteUser(dataUserLogin.id!);
                          getUser();
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TextFormConst extends StatelessWidget {
  const TextFormConst({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
  });

  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: Colors.black, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
      ),
    );
  }
}

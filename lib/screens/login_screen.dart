// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tugas_13_laporan_keuangan_harian/preference/shared_preference.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/dashboard_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/screens/register_screen.dart';
import 'package:tugas_13_laporan_keuangan_harian/sqflite/db_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const id = "/login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Initialize any controllers or variables here if needed
  }

  @override
  void dispose() {
    emailController.dispose();
    // Dispose of any controllers or resources here if needed
    super.dispose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password tidak boleh kosong")),
      );
      return;
    }

    final userData = await DbHelper.loginUser(email, password);
    if (userData != null) {
      PreferenceHandler.saveLogin();
      Navigator.pushReplacementNamed(
        context,
        DashboardScreen.id,
        arguments: userData,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email atau Password salah")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text("Login", style: TextStyle(color: Colors.black)),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.all(8)),
              SizedBox(height: 92),
              // Center(),
              Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 64),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        labelText: 'Email',
                        hintText: "Masukkan Email anda",
                        hintStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        labelStyle: TextStyle(color: const Color(0xFF1D1B20)),
                        filled: true,
                        fillColor: const Color(0xFFE6E0E9),
                        // border: InputBorder.none,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF49454F),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        // focusedBorder: const OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Color(0xFF4F378A),
                        //     width: 2,
                        //   ),
                        // ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email tidak boleh kosong";
                        }
                        if (!value.contains("@")) {
                          return "Email tidak valid";
                        }
                        if (!value.contains(".com")) {
                          return "Email tidak valid";
                        }
                        return null;
                      },
                      // onTap: () {
                      //   // Trigger validation when field is tapped
                      //   if (_formKey.currentState != null) {
                      //     _formKey.currentState!.validate();
                      //   }
                      // },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      style: TextStyle(color: const Color(0xFF1D1B20)),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF1D1B20),
                        ),
                        labelText: 'Password',
                        hintText: "Masukkan Password anda",
                        hintStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        labelStyle: TextStyle(color: const Color(0xFF1D1B20)),
                        filled: true,
                        fillColor: const Color(0xFFE6E0E9),
                        // border: InputBorder.none,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF49454F),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        // focusedBorder: const OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Color(0xFF4F378A),
                        //     width: 2,
                        //   ),
                        // ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password tidak boleh kosong";
                        }
                        if (value.length < 6) {
                          return 'Password terlalu pendek (minimal 6 karakter)';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          activeColor: const Color(0xFF6750A4),
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            rememberMe ? "Ingat Saya" : "Ingat Saya",
                            style: TextStyle(
                              color: rememberMe ? Colors.black : Colors.black,
                              // fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        //Error dan sukses menggunakan ScaffoldMessenger dan formKey
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Login Berhasil!"),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          Future.delayed(const Duration(seconds: 3), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardScreen(),
                              ),
                            );
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Peringatan"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Login Gagal"),
                                    SizedBox(height: 20),
                                    Lottie.asset(
                                      'assets/images/animations/error.json',
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: Text("Batal"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Lanjutkan"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(360, 48),
                        backgroundColor: const Color(0xFFEADDFF),
                      ),
                      child: Text(
                        "Masuk",
                        style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.bold,
                          color: Color(0xFF4F378A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: const Color(0xFF79747E),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Atau",
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF79747E),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: const Color(0xFF79747E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  Center(),
                  // Tombol login with Facebook
                  ElevatedButton.icon(
                    onPressed: () {
                      // print("Login with Facebook");
                    },
                    icon: Icon(Icons.facebook, color: const Color(0xFF49454F)),
                    label: Text(
                      "Lanjutkan dengan Facebook",
                      style: TextStyle(
                        color: const Color(0xFF49454F),
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3EDF7),
                      minimumSize: Size(360, 48),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Tombol Login with Gmail
                  ElevatedButton.icon(
                    onPressed: () {
                      // print("Login with Gmail");
                    },
                    icon: Image.asset(
                      "assets/images/icons/iconGoogle.png",
                      height: 16,
                      width: 16,
                    ),
                    label: Text(
                      "Lanjutkan dengan Google",
                      style: TextStyle(
                        color: const Color(0xFF49454F),
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3EDF7),
                      minimumSize: Size(360, 48),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // print("Login with Apple");
                    },
                    icon: Image.asset(
                      "assets/images/icons/iconApple.png",
                      height: 16,
                      width: 16,
                    ),
                    label: Text(
                      "Lanjutkan dengan Apple",
                      style: TextStyle(
                        color: const Color(0xFF49454F),
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3EDF7),
                      minimumSize: Size(360, 48),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // print('Navigasi ke halaman daftar');
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Belum memiliki akun? ',
                          style: TextStyle(color: Color(0xFF79747E)),
                        ),
                        TextSpan(
                          text: 'Daftar',
                          style: const TextStyle(
                            color: Color(0xFF6750A4),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

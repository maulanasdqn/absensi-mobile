import 'package:absensi_karyawan/screen/home_page.dart';
import 'package:absensi_karyawan/screen/register_page.dart';
import 'package:flutter/material.dart';
import 'package:absensi_karyawan/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? token;
  final _emailFormKey = GlobalKey<FormFieldState>();
  final _passwordFormKey = GlobalKey<FormFieldState>();
  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    if (!isEmail(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    return null;
  }

  bool isEmail(String value) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.blue[300],
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const Image(image: AssetImage('assets/images/logo.png')),
            Form(
              key: GlobalKey<FormState>(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: _emailFormKey,
                    controller: emailController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Email Anda',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 121, 118, 118)),
                      filled: true,
                      fillColor: Colors.white,
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) => validateEmail(value!),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    key: _passwordFormKey,
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Password Anda',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle:
                          const TextStyle(color: Colors.black, fontSize: 14),
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 121, 118, 118)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) => validatePassword(value!),
                  ),
                  const SizedBox(height: 16.0),
                  FilledButton(
                      onPressed: isLoading ? null : handleLogin,
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.blue[900]),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 14.0),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Belum punya Akun ?',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
                onPressed: navigateToRegister,
                style: const ButtonStyle(alignment: Alignment.centerLeft),
                child: Text(
                  'Daftar disini',
                  style: TextStyle(color: Colors.blue[900], fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> navigateToRegister() async {
    final route = MaterialPageRoute(builder: (context) => const RegisterPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
  }

  Future<void> handleLogin() async {
    if (_emailFormKey.currentState!.validate() &&
        _passwordFormKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Aktifkan loading button
      });
      final bool success = await authService.login(
        emailController.text,
        passwordController.text,
      );
      setState(() {
        isLoading = false; // Aktifkan loading button
      });
      if (success) {
        final data = (await authService.getUserData());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userData: data),
          ),
        );
      } else {
        // Handle authentication failure
        print('Login failed');
      }
    }
  }
}

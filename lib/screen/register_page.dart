import 'dart:convert';
import 'package:absensi_karyawan/screen/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  int? gender;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthdayDateController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController registrationNumberController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
                      controller: fullNameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nama Anda',
                        prefixIcon: const Icon(Icons.person_3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 121, 118, 118)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
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
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<int>(
                      value: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text(
                            'Laki-laki',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text('Perempuan',
                              style: TextStyle(color: Colors.black54)),
                        ),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Jenis Kelamin',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: registrationNumberController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Nomor Induk',
                        prefixIcon: const Icon(Icons.numbers),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 121, 118, 118)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: phoneNumberController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Nomor Handphone',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 121, 118, 118)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: birthdayDateController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Tanggal lahir',
                        prefixIcon: const Icon(Icons.calendar_month),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 121, 118, 118)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onTap: handleBirthday,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
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
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (!_containsLetter(value) ||
                            !_containsNumber(value)) {
                          return 'Password harus berupa gabungan angka dan huruf';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Konfirmasi Password',
                        prefixIcon: const Icon(Icons.lock_clock_sharp),
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
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: addressController,
                      maxLines: null,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Alamat',
                        prefixIcon: const Icon(Icons.location_city),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 121, 118, 118)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    FilledButton(
                        onPressed: handleRegister,
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue[900]),
                        child: const Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ))
                  ]),
            )
          ],
        ),
      ),
    );
  }

  bool _containsLetter(String value) {
    return RegExp(r'[a-zA-Z]').hasMatch(value);
  }

  bool _containsNumber(String value) {
    return RegExp(r'[0-9]').hasMatch(value);
  }

  Future<void> handleRegister() async {
    final String fullName = fullNameController.text;
    final String email = emailController.text;
    final String phoneNumber = phoneNumberController.text;
    final String registrationNumber = registrationNumberController.text;
    final String birthdayDate = birthdayDateController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;
    final String address = addressController.text;

    final body = {
      'fullName': fullName,
      'email': email,
      'phone': phoneNumber,
      'nik': registrationNumber,
      'birthdate': birthdayDate,
      'password': password,
      'gender_id': gender,
      'password_confirm': confirmPassword,
      'address': address,
    };
    if (fullName.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        registrationNumber.isEmpty ||
        birthdayDate.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showSnackbar('Tidak Boleh ada yang kosong');
    } else {
      final url = dotenv.env['API_URL'] ?? '';
      final apiUrl = '$url/auth/register';
      final uri = Uri.parse(apiUrl);
      try {
        final res = await http.post(uri,
            body: jsonEncode(body),
            headers: {'Content-Type': 'application/json'});
        if (res.statusCode == 200) {
          print('Berhasil Register');
          showSnackbar('Berhasil Register');
          fullNameController.text = '';
          emailController.text = '';
          phoneNumberController.text = '';
          registrationNumberController.text = '';
          birthdayDateController.text = '';
          passwordController.text = '';
          confirmPasswordController.text = '';
          gender;
          addressController.text = '';
          navigateToLoginPage();
          print(res.body);
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  Future<void> navigateToLoginPage() async {
    final route = MaterialPageRoute(builder: (context) => const LoginPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
  }

  Future<void> handleBirthday() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Colors.blue,
              hintColor: Colors.blue,
              colorScheme: const ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        });
    if (pickedDate != null) {
      setState(() {
        birthdayDateController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

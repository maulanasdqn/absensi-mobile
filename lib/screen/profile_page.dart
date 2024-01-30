import 'package:flutter/material.dart';
import 'package:absensi_karyawan/component/nav_bar.dart';

class ProfilePage extends StatefulWidget {
  final Map? data;
  const ProfilePage({super.key, this.data});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  String avatar = '';
  bool isEditMode = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    final dataUser = widget.data;
    if (dataUser != null) {
      final fullname = dataUser['fullname'];
      final phoneNumber = dataUser['phone'];
      final address = dataUser['address'];
      final gender = dataUser['gender'];

      fullNameController.text = fullname;
      phoneNumberController.text = phoneNumber;
      addressController.text = address;
      genderController.text = gender;
      avatar = dataUser['avatar'];
    }
    print(dataUser);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Image.asset(
            'assets/images/logo.png',
            width: 70,
            height: 70,
          ),
        ]),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.blue[300],
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            CircleAvatar(
                radius: 100,
                child: ClipOval(
                  child: Image.network(
                    '$avatar',
                    width: 200,
                    height: 200,
                  ),
                )),
            const SizedBox(height: 16.0),
            TextField(
              controller: fullNameController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Masukkan Nama Anda',
                prefixIcon: const Icon(Icons.person_3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabled: false,
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 121, 118, 118)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: phoneNumberController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'No Telepon',
                prefixIcon: const Icon(Icons.numbers),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 121, 118, 118)),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: addressController,
              maxLines: null,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Alamat',
                prefixIcon: const Icon(Icons.location_city),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 121, 118, 118)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: genderController,
              maxLines: null,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Jenis Kelamin',
                prefixIcon: const Icon(Icons.male_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 121, 118, 118)),
                filled: true,
                enabled: false,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            FilledButton(
                onPressed: () {},
                style:
                    FilledButton.styleFrom(backgroundColor: Colors.blue[900]),
                child: const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

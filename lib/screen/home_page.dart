import 'package:flutter/material.dart';
import 'package:absensi_karyawan/component/nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const HomePage({
    super.key,
    this.userData,
  });
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String currentTime;
  late String currentDate;
  Map<String, dynamic>? _userData;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null);
    updateTime();
    _userData = widget.userData;
    print(_userData);
  }

  void updateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat.yMMMMd('id').format(now);
    final dayOfWeek = DateFormat('EEEE', 'id').format(now);
    final formattedTime = DateFormat('HH:mm').format(now);
    setState(() {
      currentDate = '$dayOfWeek $formattedDate ';
      currentTime = formattedTime;
    });

    Future.delayed(
        Duration(days: 1, hours: 24 - now.hour, minutes: 60 - now.minute),
        updateTime);
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
        color: Colors.blue[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$currentDate',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius:
                    BorderRadius.circular(10), // Adjust the radius as needed
              ),
              child: Text(
                '$currentTime',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            const Text(
              'Selamat Datang',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            Text(
              _userData?['fullname'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const Text(
              'Silahkan tekan tombol',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const Text(
              'menu di kiri atas',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

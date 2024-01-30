import 'package:absensi_karyawan/screen/absence_page.dart';
import 'package:absensi_karyawan/screen/attendance_history.dart';
import 'package:absensi_karyawan/screen/login_page.dart';
import 'package:absensi_karyawan/screen/profile_page.dart';
import 'package:absensi_karyawan/services/auth.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const NavBar({
    Key? key,
    this.userData,
  }) : super(key: key);
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final authService = AuthService();

  Map<String, dynamic>? _userData;
  Future<void> getUserData() async {
    final userData = await authService.getUserData();
    if (userData != null) {
      setState(() {
        _userData = userData;
      });
    }
  }

  _NavBarState() {
    getUserData();
  }
  @override
  void initState() {
    super.initState();
    _userData = widget.userData;
    _userData?['avatar'];
  }

  @override
  Widget build(BuildContext context) {
    Future<void> navigateToPage(Widget Function() page) async {
      final route = MaterialPageRoute(builder: (context) => page());
      await Navigator.push(context, route);
    }

    Future<void> navigateToProfilePage(Map<String, dynamic>? dataList) async {
      final route =
          MaterialPageRoute(builder: (context) => ProfilePage(data: dataList));
      await Navigator.push(context, route);
      getUserData();
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_userData?['fullname'] ?? ''),
            accountEmail: Text(_userData?['nik'] ?? ''),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  _userData?['avatar'] ??
                      'https://res.cloudinary.com/dp6zyk7g0/image/upload/v1706508268/avatar/ykefnkchhlbvbnwodqwr.jpg',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://img.freepik.com/free-photo/green-paint-wall-background-texture_53876-23269.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.black54),
            title: const Text(
              'Absensi',
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () => navigateToPage(() => const AbsencePage()),
          ),
          ListTile(
            leading: const Icon(
              Icons.history,
              color: Colors.black54,
            ),
            title: const Text(
              'Riwayat Absensi',
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () => navigateToPage(() => const AttendanceHistory()),
          ),
          ListTile(
            leading: const Icon(
              Icons.person_2_rounded,
              color: Colors.black54,
            ),
            title: const Text(
              'Kelola profil',
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () => navigateToProfilePage(_userData),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.black54,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () => {
              authService.logout().whenComplete(() => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  )),
            },
          ),
        ],
      ),
    );
  }
}

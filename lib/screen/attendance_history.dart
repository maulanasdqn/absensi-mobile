import 'package:flutter/material.dart';
import 'package:absensi_karyawan/component/nav_bar.dart';
import 'package:absensi_karyawan/services/api.dart';

class AttendanceHistory extends StatefulWidget {
  final Map<String, dynamic>? attendanceHistory;
  const AttendanceHistory({
    Key? key,
    this.attendanceHistory,
  }) : super(key: key);

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  final apiRequest = ApiRequest();
  Map<String, dynamic>? _attendanceData;

  Future<void> getAttendanceData() async {
    try {
      final attendanceData = await apiRequest.getAttendanceHistory();
      if (attendanceData != null) {
        print('before :$attendanceData');
        setState(() {
          _attendanceData = attendanceData;
        });
        print('after :$_attendanceData');
      }
    } catch (error) {
      print("Error fetching attendance data: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    getAttendanceData();
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
        padding: const EdgeInsets.all(14),
        color: Colors.blue[300],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat Minggu ini',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _attendanceData?['data'].length,
                itemBuilder: (context, index) {
                  final dataList = _attendanceData?['data'][index];
                  if (dataList != null && dataList is Map) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${dataList['day']} ${dataList['date']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        dataList['location'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          dataList['status'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                dataList['status'] == 'Ontime'
                                                    ? Colors.green.shade400
                                                    : Colors.red,
                                          ),
                                        ),
                                        Text(
                                          dataList['time'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

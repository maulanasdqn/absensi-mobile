import 'package:flutter/material.dart';
import 'package:absensi_karyawan/component/nav_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:absensi_karyawan/services/api.dart';
import 'package:map_launcher/map_launcher.dart';

class AbsencePage extends StatefulWidget {
  const AbsencePage({super.key});

  @override
  State<AbsencePage> createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  String? latitude;
  String? longitude;
  String locationMessage = 'Lokasi anda';
  bool isLoading = false;
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _openMap(String lat, String long) async {
    final availableMaps = await MapLauncher.installedMaps;
    print(availableMaps);
    await availableMaps.first.showMarker(
      coords: Coords(31.233568, 121.505504),
      title: "Shanghai Tower",
      description: "Asia's tallest building",
    );
    if (lat != null && long != null) {
      bool isGoogleMapsAvailable =
          (await MapLauncher.isMapAvailable(MapType.google)) ?? false;
      if (isGoogleMapsAvailable) {
        await MapLauncher.showMarker(
          mapType: MapType.google,
          coords: Coords(double.parse(lat), double.parse(long)),
          title: 'Your Location',
        );
      } else {
        print('Google Maps is not available on the device.');
      }
    } else {
      print('Latitude or longitude is null.');
    }
  }

  Future<void> _getCurrentLocationAndSetState() async {
    try {
      setState(() {
        isLoading = true;
      });
      Position position = await _getCurrentLocation();
      String newLatitude = '${position.latitude}';
      String newLongitude = '${position.longitude}';

      if (mounted) {
        setState(() {
          latitude = newLatitude;
          longitude = newLongitude;
          locationMessage = 'latitude: $latitude, longitude: $longitude';
        });
        ApiRequest().sendAttendace(latitude!, longitude!);
        _liveLocation();
        showSnackbar('Absensi Berhasil');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error getting current location: $error');
    }
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
          padding: const EdgeInsets.all(20),
          color: Colors.blue[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: '$locationMessage',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabled: false,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () async {
                    isLoading ? null : await _getCurrentLocationAndSetState();
                  },
                  style:
                      FilledButton.styleFrom(backgroundColor: Colors.blue[900]),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Lakukan Absensi',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                  )),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: (latitude != null && longitude != null)
                      ? () {
                          _openMap(latitude.toString(), longitude.toString());
                        }
                      : null,
                  child: const Text('Lokasi saya'))
            ],
          )),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      String newLatitude = position.latitude.toString();
      String newLongitude = position.longitude.toString();
      if (mounted) {
        setState(() {
          latitude = newLatitude;
          longitude = newLongitude;
          locationMessage = 'latitude: $latitude, longitude: $longitude';
        });
      }
    });
  }
}

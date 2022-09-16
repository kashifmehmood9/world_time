import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'loading.dart';
import 'package:world_time/Services/world_time.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  GeolocatorPlatform platform = GeolocatorPlatform.instance;

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentPosition();
  }

  void getInitialTime() async {
    WorldTime instance = WorldTime(
        location: "Berlin", flag: "germany.png", url: "Europe/Berlin");
    await instance.getTime();

    setState(() {
      data = {
        'location': instance.location,
        'time': instance.time,
        'isDayTime': instance.isDayTime
      };
    });
  }

  Future<void> _getCurrentPosition() async {
    await platform.requestPermission();
    final position = await platform.getCurrentPosition();
    print("location is $position");
    List<Placemark> locations =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print("location is $locations");

    setState(() {
      data = {
        'location': locations.first.name,
        'isDayTime': true,
        'time': "123"
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    print(data);
    if (data.isEmpty) {
      return const Scaffold(body: Loading());
    }
    String backgroundImage = data['isDayTime'] ? 'day.png' : 'night.png';
    Color backgroundColor = data['isDayTime'] ? Colors.blue : Colors.indigo;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/$backgroundImage'),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
          child: Column(
            children: [
              TextButton.icon(
                  onPressed: () async {
                    dynamic result =
                        await Navigator.pushNamed(context, '/location');
                    setState(() {
                      data = result as Map;
                    });
                  },
                  icon: const Icon(
                    Icons.location_city,
                    color: Colors.grey,
                  ),
                  label: const Text(
                    "Edit location",
                    style: TextStyle(color: Colors.grey),
                  )),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['location'],
                    style: const TextStyle(
                        fontSize: 28, letterSpacing: 2, color: Colors.white),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                data['time'],
                style: const TextStyle(
                    fontSize: 60, letterSpacing: 3, color: Colors.white),
              )
            ],
          ),
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'loading.dart';
import 'package:world_time/Services/world_time.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  void initState() {
    // TODO: implement initState
    getInitialTime();
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

  @override
  Widget build(BuildContext context) {
    print(data);

    if (data.isEmpty) {
      return Scaffold(
        body: Loading(),
      );
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
                  icon: Icon(
                    Icons.location_city,
                    color: Colors.grey,
                  ),
                  label: Text(
                    "Edit location",
                    style: TextStyle(color: Colors.grey),
                  )),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['location'],
                    style: TextStyle(
                        fontSize: 28, letterSpacing: 2, color: Colors.white),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                data['time'],
                style: TextStyle(
                    fontSize: 60, letterSpacing: 3, color: Colors.white),
              )
            ],
          ),
        ),
      )),
    );
  }
}

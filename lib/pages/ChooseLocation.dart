import 'package:flutter/material.dart';
import 'package:world_time/Services/world_time.dart';
import 'package:http/http.dart';
import 'package:world_time/pages/loading.dart';
import 'dart:convert';
import 'PathExtractor.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List locations = [];
  List flags = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocations();
  }

  void getLocations() async {
    print("Getting locations");
    Response response =
        await get(Uri.parse("http://worldtimeapi.org/api/timezones"));

    setState(() {
      locations = jsonDecode(response.body);
      getFlags();
    });
  }

  void getFlags() {
    print("Getting Flags");

    for (String country in locations) {
      flags.add("https://countryflagsapi.com/png/${country.split('/').first}");
    }
  }

  void updateTime(index) async {
    String location = locations[index];
    WorldTime instance =
        WorldTime(location: location, flag: "flag", url: location);
    await instance.getTime();

    //navigate back to the home screen

    Navigator.pop(context, {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDayTime': instance.isDayTime
    });
  }

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) {
      return const Scaffold(
        body: Loading(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose a Location"),
        backgroundColor: Colors.grey,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Card(
              child: ListTile(
                onTap: () {
                  updateTime(index);
                },
                title: Text(locations[index]),
                leading:
                    CircleAvatar(backgroundImage: NetworkImage(flags[index])),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; // Location name
  String? time; // Time in the location
  String flag; // URL to an asset flag icon
  String url; // url for the location
  bool? isDayTime;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      String madeURL = "http://worldtimeapi.org/api/timezone/$url";
      print("Loading ... $madeURL");
      Response response = await get(Uri.parse("$madeURL"));
      // print(response.body);
      Map data = jsonDecode(response.body);
      // Get properties from JSON
      String dateTime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);

      // create Date time Object

      DateTime now = DateTime.parse(dateTime);
      now = now.add(Duration(hours: int.parse(offset)));

      isDayTime = now.hour < 20 && now.hour > 6 ? true : false;
      time = DateFormat.jm().format(now);
      print("time is $time");
    } catch (e) {
      print('exception is $e');
      time = 'could not get time';
    }
  }
}

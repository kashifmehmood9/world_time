import 'package:flutter/material.dart';
import 'package:world_time/pages/ChooseLocation.dart';
import 'package:world_time/pages/Home.dart';
import 'package:world_time/pages/loading.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/home': (context) => Home(),
      '/location': (context) => ChooseLocation(),
      '/loading': (context) => Loading()
    },
  ));
}

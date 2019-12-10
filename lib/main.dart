import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'files/home.dart';

void main() {      
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SF Admin Panel',
      home: Home(),
    ));
  });
}
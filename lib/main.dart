import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'files/home.dart';

void main() {      
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SF Admin Panel',
      home: Home(),
    ));
}
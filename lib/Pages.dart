import 'package:flutter/material.dart';
import 'package:manage_house/humidity.dart';
import 'package:manage_house/Temp/temperature.dart';

final Pages = [
  Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/asset2.jpg'),
        fit: BoxFit.cover,
      ),
    ),
    child: Center(child: temperature()),
  ),
  Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/asset3.jpg'),
        fit: BoxFit.cover,
      ),
    ),
    child: Center(child: humidity()),
  )
];
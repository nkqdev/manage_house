import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator_ns/liquid_progress_indicator.dart';

import 'Services/local_notification_service.dart';

class humidity extends StatefulWidget{
  @override
  State<humidity> createState() => _humidityState();
}

class _humidityState extends State<humidity> {
  String _DisplayHumi = "";
  double _getPercent= 0.0;
  final _database= FirebaseDatabase.instance.reference();

  @override
  void _activateListeners(){
    _database.child('Data/humidity').onValue.listen((event) {
      final Object? HumiText= event.snapshot.value;
      setState(() {
        _DisplayHumi = '$HumiText';
        _getPercent = double.parse('$HumiText')/100;
      });
    });
  }

  void initState(){
    super.initState();
    _activateListeners();
  }
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            child: SizedBox(
                height: 280,
                width: 280,
                child: LiquidCircularProgressIndicator(
                  value: _getPercent,
                  // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(Colors.white38),
                  // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors.white24,
                  // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.grey,
                  borderWidth: 0.0,
                  direction: Axis.vertical,
                  // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          '$_DisplayHumi%',
                          style: GoogleFonts.saira(
                              color: Colors.grey,
                              fontSize: 50)),
                      Text('Humidity',
                          style: GoogleFonts.saira(
                              color: Colors.grey, fontSize: 23)),
                    ],
                  ), //text inside it
                )
            )
        ),
      ],
    );
  }
}
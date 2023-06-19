import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:d_chart/d_chart.dart';
import 'package:manage_house/Temp/tempChart.dart';
import 'package:wi_custom_bar/wi_custom_bar.dart';

class temperature extends StatefulWidget {
  @override
  State<temperature> createState() => _temperatureState();
}

class _temperatureState extends State<temperature> {
  String _DisplayTemp = "0";
  final _database = FirebaseDatabase.instance.reference();

  @override
  void _activateListeners() {
    _database.child('Data/temperature').onValue.listen((event) {
      final Object? TempText = event.snapshot.value;
      setState(() {
        _DisplayTemp = '$TempText';
      });
    });
  }

  void initState() {
    super.initState();
    _activateListeners();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Temperature',
              style: GoogleFonts.saira(color: Colors.grey, fontSize: 23)),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     TemperatureVerticalBar(100,_getPercent!,
          //       barHeight: 180.0,
          //       barWidth: 32.0,
          //       barPointCount: 10,
          //       circleSize: 55,
          //         baseBgColor: Colors.grey,
          //       gradientBottomColor: Color(0xFFFFDCD6),
          //       gradientTopColor: Colors.red,
          //     ),
          //   ],
          // ),
          Text('${double.parse('$_DisplayTemp').toInt()}\u00B0C',
              style: GoogleFonts.saira(color: Colors.grey, fontSize: 80)),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Container(
                child: TempChart(),
            ).asGlass(
              tintColor: Colors.black12,
              clipBorderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ],
      ),
    );
  }
}

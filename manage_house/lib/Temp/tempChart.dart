import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TempChart extends StatefulWidget {


  @override
  State<TempChart> createState() => _TempChartState();
}

class _TempChartState extends State<TempChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  bool showAvg = false;
  String _DisplayTempNow = "10";
  String _DisplayTemp15 = "10";
  String _DisplayTemp30 = "10";
  String _DisplayTemp45 = "10";
  String _DisplayTemp60 = "10";
  final _database = FirebaseDatabase.instance.reference();

  @override
  void _activateListeners() {
    _database.child('Data/temperature').onValue.listen((event) {
      late final Object? TempText = event.snapshot.value;
      setState(() {
        if(TempText== 'NAN'){
          _DisplayTempNow='0';
        }else{
          _DisplayTempNow = '$TempText';
        }
      });
    });
      _database.child('Data/temp45').onValue.listen((event) {
        late final Object? TempText = event.snapshot.value;
        setState(() {
          if(identical(TempText, 'NAN')){
            _DisplayTemp45='0';
          }else{
            _DisplayTemp45 = '$TempText';
          }
        });
      });
    _database.child('Data/temp30').onValue.listen((event) {
      late final Object? TempText = event.snapshot.value;
      setState(() {
        if(identical(TempText, 'NAN')){
          _DisplayTemp30='0';
        }else{
          _DisplayTemp30 = '$TempText';
        }

      });
    });
    _database.child('Data/temp15').onValue.listen((event) {
      late final Object? TempText = event.snapshot.value;
      setState(() {
        if(identical(TempText, 'NAN')){
          _DisplayTemp15='0';
        }else{
          _DisplayTemp15 = '$TempText';
        }
      });
    });
    _database.child('Data/temp60').onValue.listen((event) {
      late final Object? TempText = event.snapshot.value;
      setState(() {
        if(identical(TempText, 'NAN')){
          _DisplayTemp60='0';
        }else{
          _DisplayTemp60 = '$TempText';
        }
      });
    });
  }

  void initState() {
    super.initState();
    _activateListeners();
  }
  Widget build(BuildContext context) {



    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.2,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                showAvg ? avgData() : mainData(),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('60m ago', style: style);
        break;
      case 1:
        text = const Text('45m ago', style: style);
        break;
      case 2:
        text = const Text('30m ago', style: style);
        break;
      case 3:
        text = const Text('15m ago', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 10:
        text = '10';
        break;
      case 30:
        text = '30';
        break;
      case 50:
        text = '50';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.black12,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.black12,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 4,
      minY: 0,
      maxY: 60,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, double.parse('$_DisplayTemp60')),
            FlSpot(1, double.parse('$_DisplayTemp45')),
            FlSpot(2, double.parse('$_DisplayTemp30')),
            FlSpot(3, double.parse('$_DisplayTemp15')),
            FlSpot(4, double.parse('$_DisplayTempNow')),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {

    double AvgTemp=(double.parse('$_DisplayTempNow')+double.parse('$_DisplayTemp15')+double.parse('$_DisplayTemp30')+double.parse('$_DisplayTemp45')+double.parse('$_DisplayTemp60'))/5;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.black12,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.black12,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 4,
      minY: 0,
      maxY: 60,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, AvgTemp),
            FlSpot(1, AvgTemp),
            FlSpot(2, AvgTemp),
            FlSpot(3, AvgTemp),
            FlSpot(4, AvgTemp),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

//points.map((point)=> FlSpot(point.x, point.y)).toList(),

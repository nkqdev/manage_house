import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:manage_house/Pages.dart';
import 'package:manage_house/Services/local_notification_service.dart';


class homescreen extends StatefulWidget{
  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  late final LocalNotificationService service;
  int _alarmco2 = 0;
  int _checkConnect=0;
  final _database= FirebaseDatabase.instance.reference();

  @override
  void _activateListeners(){
    _database.child('Data/alarmco2').onValue.listen((event) {
      final Object? AlarmCheck= event.snapshot.value;
      setState(() {
        _alarmco2 = int.parse('$AlarmCheck');

      });
    });
    _database.child('Data/checkConnect').onValue.listen((event) {
      final Object? ConnectStatus= event.snapshot.value;
      setState(() {
        _checkConnect = int.parse('$ConnectStatus');

      });
    });
  }
  void initState(){
    service = LocalNotificationService();
    service.intialize();
    super.initState();
    _activateListeners();
  }



  Widget build(BuildContext context) {
    int alarmId=1;
    if(_alarmco2 == 1){
      AndroidAlarmManager.periodic(Duration(seconds: 5), alarmId, fireAlarm);
      service.showNotification(id: 0, title: 'Manage House', body: 'Phát hiện có khói');
    }else{
      AndroidAlarmManager.cancel(alarmId);
    }

    if(_checkConnect == 1){
      service.showNotification(id: 0, title: 'Manage House', body: 'Mất kết nối với cảm biến');
    }

    print('Alarm check $_alarmco2');
    return LiquidSwipe(
      //enableSideReveal: true,
      pages: Pages,
      //fullTransitionValue: 300,
      enableLoop: true,
      slideIconWidget: const Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
      waveType: WaveType.circularReveal,
      positionSlideIcon: 0.9,
      onPageChangeCallback: (page)=> pageChangeCallback(page),
      currentUpdateTypeCallback: (updateType) => updateTypeCallback(updateType) ,
    );
  }

  pageChangeCallback(int page){
    print(page);
  }

  updateTypeCallback(UpdateType updateType){
    print(updateType);
  }
}

void fireAlarm(){
  print('Alarm fired at${DateTime.now()}');
}
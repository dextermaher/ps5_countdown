import 'dart:async';
// import 'dart:ffi';
// import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PS5 Launch Countdown',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'PS5 Launch Countdown'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map dropDownList = {
    'New Zealand': DateTime(2020, 11, 11, 3),
    'America': DateTime(2020, 11, 12, 3),
    'EU': DateTime(2020, 11, 19, 3),
    'Japan': DateTime(2020, 11, 12, 12)
  };
  Duration timeTillDrop;
  String timeTillDropInString;
  int timersRunning = 0;
  DateTime timeValue = DateTime(2020, 11, 11, 3);

  void getRemainingTime(DateTime newTime) {
    setState(() {
      timersRunning++;
    });
    int theNumberOfTheTimerInOrderOfCreation = timersRunning;
    print(newTime);
    Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      print(newTime.difference(now));
      setState(() {
        timeTillDrop = newTime.difference(now);
      });
      if (timersRunning > 1 &&
          theNumberOfTheTimerInOrderOfCreation < timersRunning) {
        timer.cancel();
        // timersRunning = 0;
      }
      printDuration();
    });
  }

  void printDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(timeTillDrop.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(timeTillDrop.inSeconds.remainder(60));
    setState(() {
      timeTillDropInString =
          "${twoDigits(timeTillDrop.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'PLAYSTATION 5 COUNTDOWN TIMER',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              timeTillDrop.toString() != 'null'
                  ? timeTillDropInString
                  : 'Choose A Country',
              style: TextStyle(fontSize: 50),
            ),
            DropdownButton(
              items: dropDownList
                  .map((description, value) {
                    return MapEntry(
                        description,
                        DropdownMenuItem<DateTime>(
                          value: value,
                          child: Text(
                            description,
                            style: TextStyle(fontSize: 30),
                          ),
                        ));
                  })
                  .values
                  .toList(),
              value: timeValue,
              iconEnabledColor: Colors.blue,
              dropdownColor: Colors.lightBlue[100],
              onChanged: (newValue) {
                getRemainingTime(newValue);
                setState(() {
                  timeValue = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

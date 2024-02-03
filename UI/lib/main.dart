import 'dart:io';

import 'package:car_app_2/Screens/CarDetection.dart';
import 'package:car_app_2/Screens/CarPrediction.dart';
import 'package:car_app_2/Services/Cars.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import "package:car_app_2/constants.dart";
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  int _selectedIndex = 0;
  Cars car = Cars();

  void setupCars() async {
    await car.getData();
  }
  void initState(){
    setupCars();
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    List<Widget> _widgetOptions = <Widget>[
      CarDetection(car: car),
      CarPrediction(car: car)
    ];

    return MaterialApp(
      title: 'Carhabti',
      theme: ThemeData(
        fontFamily: "Rakkas"
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomInset: true,
        body:Container(
          width: double.infinity, height: double.infinity,
          decoration: BoxDecoration(
              image:DecorationImage(
              image:AssetImage("assets/images/background.jpg"),
              fit : BoxFit.cover
            )
          ),
            child: Container(
              width: double.infinity,
                height: double.infinity,
                color: BLUE20,
                child: _widgetOptions.elementAt(_selectedIndex))),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: BLUE,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.car_repair),label: "Scanner voiture"),
            BottomNavigationBarItem(icon: Icon(Icons.monetization_on),label: "Calculer prix"),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
        ),
      )
    );
  }
}



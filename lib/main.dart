import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

var fsConnect = FirebaseFirestore.instance;
var currentPosition;
void locatePosition() async {
  try {
    print('my current location is:- \n');
    /* Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    print(position.latitude.toString() + ',' + position.longitude.toString()); */
    Position position;
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen((position) {
      print(position == null? 'Unknown': position.latitude.toString() + ', ' +position.longitude.toString());
      fsConnect.collection('locations').doc('TsCzEaOSvNzhh09kY0NX').update(
        {'latitude': position.latitude, 'longitude': position.longitude}); 
    });
     
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("location sender"),
          backgroundColor: Colors.red,
        ),
        body: Column(
          children: [
            RaisedButton(
              onPressed: locatePosition,
              child: Text("start transmitting"),
            ),
            RaisedButton(
              onPressed: () async {
                Query q = FirebaseFirestore.instance.collection('locations');
                await q.get().then((value) => print(value));
              },
              child: Text('firebase test'),
            )
          ],
        ),
      ),
    );
  }
}

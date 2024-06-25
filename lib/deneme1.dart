import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class deneme1 extends StatefulWidget {
  const deneme1({Key? key}) : super(key: key);

  @override
  State<deneme1> createState() => _deneme1aState();
}

class _deneme1aState extends State<deneme1> {
  final DatabaseReference userRef = FirebaseDatabase.instance.ref('Users');

  double hourlyRate = 20.0; // Saatlik ücret TL
  double get minuteRate => hourlyRate / 60; // Dakikalık ücret TL

  late Timer _timer;
  DateTime? checkInTime;
  double payment = 0.0;

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    checkInTime = DateTime.now();
    await userRef.child(userId).update({'checkIn': checkInTime!.toIso8601String()});

    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _updatePayment();
    });
  }

  void _updatePayment() async {
    final now = DateTime.now();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final duration = now.difference(checkInTime!);
    final minutesWorked = duration.inMinutes;
    payment = minutesWorked * minuteRate;

    await userRef.child(userId).update({
      'checkOut': now.toIso8601String(),
      'minutesWorked': minutesWorked,
      'payment': payment
    });

    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canlı Saat ve Ödeme'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<DateTime>(
              stream: _clockStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final now = snapshot.data!;
                  final formattedTime = "${now.hour}:${now.minute}:${now.second}";
                  return Text(
                    formattedTime,
                    style: TextStyle(fontSize: 48),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Text(
                'Ödeme: ${payment.toStringAsFixed(2)} TL',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<DateTime> _clockStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield DateTime.now();
    }
  }
}
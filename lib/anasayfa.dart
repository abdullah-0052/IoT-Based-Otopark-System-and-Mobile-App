import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uygulamaflutter/PaymentPage2.dart';
import 'package:uygulamaflutter/PaymentPage.dart';
import 'package:uygulamaflutter/PaymentPage3.dart';
import 'package:uygulamaflutter/PaymentPage4.dart';
import 'dart:async';


class anasayfa extends StatefulWidget {
  const anasayfa({Key? key}) : super(key: key);

  @override
  State<anasayfa> createState() => _anasayfaState();
}

class _anasayfaState extends State<anasayfa> {
  final ref1 = FirebaseDatabase.instance.ref('Sensor/Park1');
  final ref2 = FirebaseDatabase.instance.ref('Sensor2/Park2');
  final ref3 = FirebaseDatabase.instance.ref('Sensor3/Park3');
  final ref4 = FirebaseDatabase.instance.ref('Sensor4/Park4');

  String alan1Value = '';
  String alan2Value = '';
  String alan3Value = '';
  String alan4Value = '';

  @override
  void initState() {
    super.initState();
    ref1.child('Alan 1').onValue.listen((event) {
      final value = event.snapshot.value.toString();
      setState(() {
        alan1Value = value;
      });
    });

    ref2.child('Alan 2').onValue.listen((event) {
      final value = event.snapshot.value.toString();
      setState(() {
        alan2Value = value;
      });
    });

    ref3.child('Alan 3').onValue.listen((event) {
      final value = event.snapshot.value.toString();
      setState(() {
        alan3Value = value;
      });
    });

    ref4.child('Alan 4').onValue.listen((event) {
      final value = event.snapshot.value.toString();
      setState(() {
        alan4Value = value;
      });
    });

  }
  double hourlyRate = 40.0; // Saatlik ücret TL
  double get minuteRate => hourlyRate / 60; // Dakikalık ücret TL



  late Timer _timer;
  DateTime? checkInTime;
  double payment = 0.0;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState1() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_selectedIndex == 0) {
        _updatePayment();
      }
    });
  }

  void _updatePayment() {
    final now = DateTime.now();
    final duration = now.difference(checkInTime!);
    final minutesWorked = duration.inMinutes;
    payment = minutesWorked * minuteRate;

    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  String getCurrentTimeWithSeconds() {
    DateTime now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = getCurrentDate();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[600],
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 40), // Adjust spacing
              Text(
                ' Araba Park Alanı',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
              },
              icon: const Icon(Icons.exit_to_app,
                color: Colors.purple
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Card(
                                  color: Colors.blue[600],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        height: MediaQuery.of(context).size.height * 0.15,
                                        child: FirebaseAnimatedList(
                                          query: ref1,
                                          itemBuilder: (context, snapshot, animation, index) {
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "P1",
                                                    style: TextStyle(
                                                      height: 3,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    snapshot.child('Alan 1').value.toString(),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20.0), // Sadece alt kenardan uzaklık
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (alan1Value == 'BOS') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const PaymentPage(info: 'P1')),
                                              );
                                            } else {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.warning,
                                                animType: AnimType.topSlide,
                                                title: 'Uyarı',
                                                desc: 'Bu Alan Dolu, Lütfen Başka Alan seçiniz.',
                                                btnOkOnPress: () {},
                                              ).show();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.purple[500],
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            minimumSize: const Size(30, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Tıklayınız',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Card(
                                  color: Colors.blue[600],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        height: MediaQuery.of(context).size.height * 0.15,
                                        child: FirebaseAnimatedList(
                                          query: ref2,
                                          itemBuilder: (context, snapshot, animation, index) {
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "P2",
                                                    style: TextStyle(
                                                      height: 3,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    snapshot.child('Alan 2').value.toString(),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20.0), // Sadece alt kenardan uzaklık
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (alan2Value == 'BOS') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const PaymentPage2(info: 'P2')),
                                              );
                                            } else {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.warning,
                                                animType: AnimType.topSlide,
                                                title: 'Uyarı',
                                                desc: 'Bu Alan Dolu, Lütfen Başka Alan seçiniz.',
                                                btnOkOnPress: () {},
                                              ).show();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.purple[500],
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            minimumSize: const Size(30, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Tıklayınız',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Card(
                                  color: Colors.blue[600],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        height: MediaQuery.of(context).size.height * 0.15,
                                        child: FirebaseAnimatedList(
                                          query: ref3,
                                          itemBuilder: (context, snapshot, animation, index) {
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "P3",
                                                    style: TextStyle(
                                                      height: 3,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    snapshot.child('Alan 3').value.toString(),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20.0), // Sadece alt kenardan uzaklık
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (alan3Value == 'BOS') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const PaymentPage3(info: 'P3')),
                                              );
                                            } else {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.warning,
                                                animType: AnimType.topSlide,
                                                title: 'Uyarı',
                                                desc: 'Bu Alan Dolu, Lütfen Başka Alan seçiniz.',
                                                btnOkOnPress: () {},
                                              ).show();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.purple[500],
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            minimumSize: const Size(30, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Tıklayınız',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Card(
                                  color: Colors.blue[600],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        height: MediaQuery.of(context).size.height * 0.15,
                                        child: FirebaseAnimatedList(
                                          query: ref4,
                                          itemBuilder: (context, snapshot, animation, index) {
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "P4",
                                                    style: TextStyle(
                                                      height: 3,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    snapshot.child('Alan 4').value.toString(),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20.0), // Sadece alt kenardan uzaklık
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (alan4Value == 'BOS') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const PaymentPage4(info: 'P4')),
                                              );
                                            } else {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.warning,
                                                animType: AnimType.topSlide,
                                                title: 'Uyarı',
                                                desc: 'Bu Alan Dolu, Lütfen Başka Alan seçiniz.',
                                                btnOkOnPress: () {},
                                              ).show();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.purple[500],
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            minimumSize: const Size(30, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Tıklayınız',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.20,
                  decoration: BoxDecoration(
                    color:  Colors.blue[600],
                    borderRadius: BorderRadius.circular(10), // İç kenar yuvarlaklığı
                    border: Border.all(color: Colors.black, width: 2), // Dış border rengi ve kalınlığı
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Daha Önceden Park Alanı rezervasyonu için:",
                          style: TextStyle(
                            height: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Text(
                          "Park Alanı Seçiniz",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        StreamBuilder<String>(
                          stream: Stream.periodic(const Duration(seconds: 1), (_) => getCurrentTimeWithSeconds()),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? getCurrentTimeWithSeconds(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          currentDate,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

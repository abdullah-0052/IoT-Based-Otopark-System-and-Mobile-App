import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';

class PaymentPage4 extends StatefulWidget {
  const PaymentPage4({super.key, required String info});

  @override
  State<PaymentPage4> createState() => _PaymentPage4State();
}

class _PaymentPage4State extends State<PaymentPage4> {
  final ref4 = FirebaseDatabase.instance.ref('Sensor4');
  final TextEditingController _plateController = TextEditingController();

  String plateNumber = '';
  bool isPaymentStarted = false; // Ödeme başlatıldı mı kontrolü eklendi

  double hourlyRate = 20.0;
  double get minuteRate => hourlyRate / 60;

  late Timer _timer;
  DateTime? checkInTime;
  double payment = 0.0;

  @override
  void initState() {
    super.initState();
  }

  void _startClock() {
    checkInTime = DateTime.now();
    isPaymentStarted = true; // Ödeme başlatıldı olarak işaretle

    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _updatePayment();
    });
  }

  void _updatePayment() {
    final now = DateTime.now();
    final duration = now.difference(checkInTime!);
    final minutesWorked = duration.inMinutes;
    payment = minutesWorked * minuteRate;

    setState(() {});
  }

  void _saveData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final plateNumber = _plateController.text;

    if (plateNumber.isNotEmpty) {
      await FirebaseFirestore.instance.collection('p4').add({
        'Plaka': plateNumber,
        'Ucret': payment,
      });

      // Update the Realtime Database value to 'DOLU' instead of 'null'
      await ref4.child('Park4').set({'Alan 4': 'DOLU'});

      setState(() {
        this.plateNumber = plateNumber;
      });

      _startClock(); // Zamanlayıcıyı başlat
      _plateController.clear();
    } else {
      // Kullanıcı plaka numarası girmeden kaydedemez
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        title: 'Uyarı',
        desc: 'Lütfen plaka numarasını girin.',
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _plateController.dispose();
    super.dispose();
  }

  Stream<bool> _parkingLotStatusStream() {
    return FirebaseDatabase.instance
        .ref('Sensor4')
        .child('Alan 4')
        .onValue
        .map((event) => event.snapshot.value != null);
  }

  Stream<DateTime> _clockStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
                      home: Scaffold(
                      appBar: AppBar(
                      backgroundColor: Colors.blue[600],
                      title: const Text(
                      'Ödeme Bilgileri',
                      style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                  ),
                  ),
                          centerTitle: true,
                          ),
                          body: StreamBuilder<bool>(
                          stream: _parkingLotStatusStream(),
                          builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data == true) {
                          _startClock();
                          }
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Column(
                                  children: [
                                    Row(
                                      children: [
                                      Expanded(
                                        child: Column(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.all(0.0),
                                              child: Container(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                    child: Card(
                                                    color: Colors.blue[600],
                                                      margin: EdgeInsets.zero,
                                                      child: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.80,
                                                        height: 592,
                                                        child: FirebaseAnimatedList(
                                                            query: ref4,
                                                            itemBuilder: (context, snapshot, animation, index) {
                                                            return Center(
                                                              child: Column(
                                                               children: [
                                                                const Text(
                                                                "P4 Alanın Borcu ",
                                                                style: TextStyle(
                                                                height: 3,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20,
                                                                color: Colors.white,
                                                                ),
                                                                 ),

                                                                  const SizedBox(height: 8),
                                                                  SizedBox(
                                                                      width: 250,
                                                                      height: 50,
                                                                    child: TextFormField(
                                                                controller: _plateController,
                                                                    onChanged: (value) {
                                                                    setState(() {
                                                                    plateNumber = value;
                                                                    });
                                                                },
                                                                  decoration: InputDecoration(
                                                                  border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                  ),
                                                                    filled: true,
                                                                    fillColor: Colors.white,
                                                                    hintText: 'Plakanızı giriniz',
                                                                  hintStyle: TextStyle(color: Colors.purple[300]),
                                                                  ),
                                                                  style: const TextStyle(color: Colors.black),
                                                                  ),
                                                                  ),
                                                                  const SizedBox(height: 25),
                                                                  ElevatedButton(
                                                                      onPressed: _saveData,
                                                                      style: ElevatedButton.styleFrom(
                                                                      foregroundColor: Colors.white,
                                                                      backgroundColor: Colors.purple[500],
                                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                    minimumSize: Size(50, 50),
                                                                    shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    ),
                                                                    child: const Text(
                                                                    'Kaydet',
                                                                    style: TextStyle(fontSize: 18),
                                                                    ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(right: 0.0),
                                                                      child: Align(
                                                                      alignment: Alignment.center,
                                                                        child: Text(
                                                                        "Plaka: $plateNumber",
                                                                        style: const TextStyle(
                                                                        height: 3,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 20,
                                                                        color: Colors.white,
                                                                        ),
                                                                        ),
                                                                        ),
                                                                        ),
                                                                        const SizedBox(height: 150),
                                                                        const Text(
                                                                          "Geçirilen Süre ve Borç",
                                                                          style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 20,
                                                                          color: Colors.white,
                                                                        ),
                                                                        ),
                                                                        Container(
                                                                          padding: EdgeInsets.all(16.0),
                                                                          child: Text(
                                                                          'Tutar: ${payment.toStringAsFixed(2)} TL',
                                                                        style: const TextStyle(
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.w700,
                                                                        ),
                                                                        ),
                                                                        ),
                                                                        StreamBuilder<DateTime>(
                                                                          stream: _clockStream(),
                                                                          builder: (context, snapshot) {
                                                                          if (snapshot.hasData) {
                                                                          final now = snapshot.data!;
                                                                          final formattedTime =
                                                                          "${now.hour}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
                                                                          return Text(
                                                                            formattedTime,
                                                                          style: const TextStyle(
                                                                            fontSize: 20,
                                                                            fontWeight: FontWeight.w700,
                                                                          ),
                                                                        );
                                                                        } else {
                                                                          return CircularProgressIndicator();
                                }
                                                                        },
                                                                        ),
                                                                          const SizedBox(height: 2),
                                                                        ],
                                                                        ),
                                                                );
                                                             },
                                                   ),
                                                 ),
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
      ],
    ),
    ),
    );
    },
    ),
                        bottomNavigationBar: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: ClipRRect(
                              child: SizedBox(
                                width: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 110,
                                        decoration: const BoxDecoration(
                                          color: Colors.purple,
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(10),
                                                bottom: Radius.circular(10),
                                              ),
                                            ),

                                            child: IconButton(
                                              icon: const Icon(Icons.directions_car),
                                              color: Colors.black,
                                              iconSize: 26,
                                              onPressed: () async {
                                                if (isPaymentStarted) {
                                                  // Show AwesomeDialog with payment amount
                                                  AwesomeDialog(
                                                    context: context,
                                                  dialogType: DialogType.warning,
                                                      animType: AnimType.topSlide,
                                                      title: 'Uyarı',
                                                      desc: 'Lütfen Çıkış Yaparke Ödeme yapınız.: ${payment.toStringAsFixed(2)} TL.',
                                                      btnOkOnPress: () async {
                                                        // Reset the Realtime Database value
                                                        await ref4.child('Park4').update({'Alan 4': 'BOS'});
                                                        Navigator.of(context).pushNamedAndRemoveUntil("anasayfa", (route) => false);
                                                      },
                                                      btnCancelOnPress: () {},
                                                    ).show();
                                                  } else {
                                                    // Kullanıcı plaka numarası girmeden menü düğmesine basarsa uyarı gösterme
                                                    if (plateNumber.isNotEmpty) {
                                                      // Kullanıcı plaka numarası girdi, ancak ödeme sürecini başlatmadı
                                                  AwesomeDialog(
                                                    context: context,
                                                    dialogType: DialogType.warning,
                                                    animType: AnimType.topSlide,
                                                    title: 'Uyarı',
                                                    desc: 'Lütfen ödeme sürecini başlatın.',
                                                    btnOkOnPress: () {},
                                                  ).show();
                                                } else {
                                                  // Kullanıcı plaka numarası girmeden menü düğmesine bastı
                                                  Navigator.pop(context);
                                                  }
                                                  }
                                                },
                                              ),
                                            ),

                                        ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
        ),
    );
  }
}

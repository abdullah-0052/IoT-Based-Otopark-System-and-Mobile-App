// ignore_for_file: prefer_const_constructors, unnecessary_import, camel_case_types, use_super_parameters, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uygulamaflutter/auth/login_screen.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 58, 55, 227),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(70),
                    ),
                  ),
                  child: Center(
                     child: Image.asset(
                      'images/logo.png',
                      width: 270,
                      height: 270,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.666,
                padding: EdgeInsets.only(top: 40, bottom: 30),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 58, 55, 227),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.666,
                padding: EdgeInsets.only(top: 40, bottom: 30),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "OtoParka Hoş Geldiniz",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        wordSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Devam etmek için tıklayınız.....",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 90), // Ayrı bir boşluk ekledim
                    ElevatedButton(
                      onPressed: () {
                        // İkinci sayfaya geçiş için Navigator'ı kullanın
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 58, 55, 227),
                        textStyle: TextStyle(
                          color: Colors.white, // Buton metin rengi
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5,
                        ),
                        minimumSize: Size(350, 40), // Minimum genişlik ve yükseklik
                        padding: EdgeInsets.all(15), // Dikey iç boşluk
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Border radius 15
                        ),
                      ),

                      child: Text("Devam Et"), // Butonun üzerindeki yazı
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

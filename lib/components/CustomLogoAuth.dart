
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomLogoAuth extends StatelessWidget {
  const CustomLogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Container(
          alignment: Alignment.center,
          width: 250,
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30)),
          child : Image.asset(
            'images/logo2.png',
          ),
        )
    );
  }
}
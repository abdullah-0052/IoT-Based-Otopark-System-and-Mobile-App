
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Custombuttonauth extends StatelessWidget {
  final void Function()? onPressed;
  final String title;

  const Custombuttonauth({super.key, this.onPressed, required this.title, required Null Function() onTap});

  @override
  Widget build(BuildContext context) {
    return     MaterialButton(
      height: 55,
      shape: RoundedRectangleBorder(
        borderRadius:BorderRadius.circular(20),
      ),

      color: const Color.fromARGB(255, 58, 55, 227),
      textColor: Colors.white,
      onPressed: onPressed,
      child:Text(title ,style: const TextStyle(fontSize: 20,wordSpacing: 1),),
    );
  }
}
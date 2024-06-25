import 'package:flutter/material.dart';

class CustomTextFrom extends StatelessWidget {

  final String hintText;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  final bool obscureText; // Yeni eklenen özellik
  const CustomTextFrom({super.key, required this.hintText, required this.mycontroller, required this.validator, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      obscureText: obscureText, // Yeni eklenen özellik
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 18, color:Colors.grey,),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 15 ,horizontal: 20),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color.fromARGB(255, 3, 60, 107),),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color.fromARGB(255, 7, 54, 93)),
        ),
      ),
    );
  }
}

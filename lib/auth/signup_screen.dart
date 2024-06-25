// ignore_for_file: use_build_context_synchronously, duplicate_ignore, body_might_complete_normally_nullable, unused_import, avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uygulamaflutter/auth/login_screen.dart';
import 'package:uygulamaflutter/components/CustomLogoAuth.dart';
import 'package:uygulamaflutter/components/Custombuttonauth.dart';
import 'package:uygulamaflutter/components/textfromfield.dart';

// ignore: camel_case_types
class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

// ignore: camel_case_types
class _signupState extends State<signup> {

  // ignore: non_constant_identifier_names
  TextEditingController email =TextEditingController() ;
  // ignore: non_constant_identifier_names
  TextEditingController password =TextEditingController() ;
  TextEditingController username =TextEditingController() ;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomLogoAuth(),
                const Text("Üye olmak",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)) ,
                Container(height: 5,),
                const Text("Devam Etmek İçin Kaydolun" ,
                  style: TextStyle(color: Color.fromARGB(255, 145, 145, 145),fontSize: 18,fontWeight: FontWeight.w500),),
                Container(height: 5),
                const Text(
                    "Kullanıcı Adı",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                Container(height: 10),
                CustomTextFrom(
                  hintText: "Kullanıcı adınızı giriniz", mycontroller : username, validator: (val) {
                  if(val == ""){
                    return"Boş Geçilmez";
                  }

                },),
                Container(height: 15),
                const Text(
                    "Email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),

                Container(height: 10),
                CustomTextFrom(
                    hintText: "E-postanızı giriniz", mycontroller : email ,validator: (val){
                  if(val == ""){
                    return"Boş Geçilmez";
                  }
                }),
                Container(height: 10),
                const Text("Şifre",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,fontFamily: 'RobotoMono')
                ),
                Container(height: 10),

                CustomTextFrom(
                    hintText: "Şifrenizi girin",
                    mycontroller : password,
                    obscureText: true,
                    validator: (val){
                      if(val == ""){
                        return "Boş Geçilemez";
                      } else if (val!.length < 8) {
                        return "Şifre en az 8 karakter olmalıdır";
                      } else if (!val.contains(new RegExp(r'[a-z]'))) {
                        return "Şifrede en az bir küçük harf olmalıdır";
                      } else if (!val.contains(new RegExp(r'[0-9]'))) {
                        return "Şifrede en az bir rakam olmalıdır";
                      }

                      return null; // Geçerli şifre
                    }
                ),

                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  alignment: Alignment.topRight,
                ),
              ],
            ),
          ),


          Custombuttonauth(title:"SignUp",onPressed:() async{

            if(formState.currentState!.validate()){
              try {
                // ignore: unused_local_variable
                final credential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                  email: email.text,
                  password: password.text ,
                );
                FirebaseAuth.instance.currentUser!.sendEmailVerification();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacementNamed("login");
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print("Girdiğiniz Şifre Zayif");
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.topSlide,
                    title: 'Hata',
                    desc: 'Girdiğiniz Şifre Zayif',
                  ).show();
                } else if (e.code == 'email-already-in-use') {
                  print("Bu Email daha Önce Kayıtlı");
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.topSlide,
                    title: 'Hata',
                    desc: 'Bu Email adresi daha Önce Kayıtlı',
                  ).show();
                }
              } catch (e) {
                print(e);
              }
            }

          }, onTap: () {  }, ),
          Container(height: 20),
          // Text("Don't Have An Account ? Register" ,textAlign: TextAlign.center,),

          InkWell(

            onTap: (){
              // ignore: prefer_const_constructors
              Navigator.of(context).pushNamed("login");
            },
            child: const Center(
              child: Text.rich( TextSpan(children: [
                TextSpan(
                    text:"Hesabınız Var mı?  ",
                    style: TextStyle(color: Colors.black, fontSize: 18,)
                ),

                TextSpan(
                  text: "Giriş yapmak",
                  style: TextStyle(color:Color.fromARGB(255, 81, 79, 230), fontWeight: FontWeight.bold,fontSize: 18),
                ),
              ])),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
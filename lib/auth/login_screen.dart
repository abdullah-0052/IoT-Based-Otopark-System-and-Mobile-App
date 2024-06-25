//import 'package:awesome_dialog/awesome_dialog.dart';
// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names, body_might_complete_normally_nullable, unnecessary_nullable_for_final_variable_declarations

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:uygulamaflutter/components/CustomLogoAuth.dart';
import 'package:uygulamaflutter/components/Custombuttonauth.dart';
import 'package:uygulamaflutter/components/textfromfield.dart';
import 'package:google_sign_in/google_sign_in.dart';




// ignore: camel_case_types
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {

  TextEditingController Email =TextEditingController() ;
  TextEditingController Password =TextEditingController() ;

  GlobalKey<FormState> formState = GlobalKey<FormState>();


  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null){
      return ;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("anasayfa", (route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(children: [
            Form(
              key: formState,
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                   Center(
                     child: Container(
                       alignment: Alignment.center,
                       width: 250,
                       height: 200,
                       padding: const EdgeInsets.all(20),
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(30)),
                       child: Image.asset(
                           'images/logo3.png'

                       ),
                     ),
                   ),

                  const Text("Giriş yapmak ",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)) ,
                  Container(height: 10,),
                  const Text(" Devam  Etmek İçin Giriş Yapın" ,
                    style: TextStyle(color: Color.fromARGB(255, 145, 145, 145),fontSize: 18,fontWeight: FontWeight.w500),),
                  Container(height: 15),

                  const Text("Email",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                  ),

                  Container(height: 10),
                  CustomTextFrom(hintText: "E-postanızı giriniz", mycontroller : Email, validator: (val) {
                    if(val == ""){
                      return "Bos Geçilmez";
                    }
                  }),
                  Container(height: 10),
                  const Text("Şifre",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,fontFamily: 'RobotoMono')
                  ),

                  Container(height: 10),
                  CustomTextFrom(hintText: "Şifrenizi girin", mycontroller : Password, obscureText: true ,validator: (val)
                  {
                    if(val == ""){
                      return "Bos Geçilmez";
                    }
                  }),

                  InkWell(
                    onTap: () async{
                      if(Email.text ==""){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.topSlide,
                          title: 'Uyarı',
                          desc: 'lütfen Önce Email adresinizi giriniz.',
                        ).show();
                        return ;
                      }

                      try{
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: Email.text);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'Uyarı',
                          desc: 'Şifre Yinelemek için email adresinize link gönderildi',
                        ).show();

                      }catch(e){

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                          title: 'Uyarı',
                          desc: 'Lütfen Girdiğiniz Email adresini kontrol edin ve tekrar deneyin',
                        ).show();
                      }

                    },
                    child: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        alignment: Alignment.topRight,
                        child: const Text(
                          "Parolanızı mı unuttunuz ?",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 16,),
                        )
                    ),
                  )
                ],
              ),
            ),

            Custombuttonauth(
              title:"Login",
              onPressed:() async {
                if (formState.currentState!.validate()){
                  try {
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: Email.text,
                      password: Password.text,
                    );

                    if(credential.user!.emailVerified){
                      Navigator.of(context).pushReplacementNamed("anasayfa");
                    }else{
                      FirebaseAuth.instance.currentUser!.sendEmailVerification();
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Uyarı',
                        desc: 'Hseabı Aktif Etmek için Lütfen Mail adresinizie Gönderilen Linki Doğrulayın.',
                      ).show();
                    }

                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'Kullanıcı bUlunmadı ') {
                      print('Bu e-posta için kullanıcı bulunamadı.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Hata',
                        desc: 'Girdiğiniz Şifre Zayif',
                      ).show();

                    } else if (e.code == 'Yanlış şifre') {
                      print('Bu kullanıcı için yanlış şifre girildi.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Hata',
                        desc: 'Girdiğiniz Şifre Zayif',
                      ).show();
                    }
                  }
                }else{
                  print(' Bos Alan Bırakılmaz!');
                }

              }, onTap: () {

            }, ),
            Container(height: 20),
            MaterialButton(
                height: 55,
                shape: RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(20),
                ),
                // ignore: prefer_const_constructors
                color: Color.fromARGB(255, 58, 55, 227),

                textColor: Colors.white,
                onPressed: (){
                  signInWithGoogle();
                },

                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Google ile Giriş Yapın ",style: TextStyle(fontSize: 18),),

                    //Image.asset('images/google.png'),

                  ],)
            ),
            Container(height: 20),
            // Text("Don't Have An Account ? Register" ,textAlign: TextAlign.center,),

            InkWell(

              onTap: (){
                Navigator.of(context).pushReplacementNamed("signup");
              },
              child: const Center(
                child: Text.rich( TextSpan(children: [
                  TextSpan(
                      text:"Hesabınız Yok mu? ",
                      style: TextStyle(color: Colors.black, fontSize: 18,)
                  ),

                  TextSpan(
                    text: "Kayıt olmak",
                    style: TextStyle( color: Color.fromARGB(255, 58, 55, 227), fontWeight: FontWeight.bold,fontSize: 18),
                  ),
                ])),
              ),
            )

          ],),
        )
    );
  }
}

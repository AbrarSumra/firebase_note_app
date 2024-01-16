import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wscube_firebase/screens/home_screen.dart';

import '../widget_constant/text_field.dart';
import 'sign_up_page.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static const String LOGIN_PREFS_KEY = "isLogin";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image:
                AssetImage("assets/images/Login Screen BackGround Image.avif"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 150, left: 30),
                  height: 270,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedTextKit(
                        repeatForever: true,
                        isRepeatingAnimation: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "Welcome",
                            speed: const Duration(milliseconds: 250),
                            textStyle: GoogleFonts.damion(
                              fontSize: 35,
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        ],
                      ),
                      AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          WavyAnimatedText(
                            "Back to our App",
                            textStyle: GoogleFonts.habibi(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CstmTextField(
                  hintText: "Enter your email",
                  controller: emailController,
                ),
                const SizedBox(height: 21),
                CstmTextField(
                  hintText: "Enter your pass",
                  controller: passController,
                ),
                const SizedBox(height: 11),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (emailController.text.isNotEmpty &&
                          passController.text.isNotEmpty) {
                        var auth = FirebaseAuth.instance;

                        try {
                          var userCred = await auth.signInWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passController.text.toString());

                          var prefs = await SharedPreferences.getInstance();
                          prefs.setBool(LOGIN_PREFS_KEY, true);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => HomeScreen(
                                        userId: userCred.user!.uid,
                                      )));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("No user found for that email.")));
                          } else if (e.code == 'wrong-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Wrong password provided for that user.")));
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 11),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "You have not an account ?",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => SignupScreen()));
                      },
                      child: const Text(
                        "Create account",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

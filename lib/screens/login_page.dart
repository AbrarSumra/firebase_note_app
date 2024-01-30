import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wscube_firebase/screens/home_screen.dart';
import 'package:wscube_firebase/widget_constant/button.dart';

import '../widget_constant/text_field.dart';
import 'on_boarding/mobile_number_screen.dart';
import 'sign_up_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String LOGIN_PREFS_KEY = "isLogin";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  bool isCheck = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "assets/images/Login Screen BackGround Image.jpg"),
                fit: BoxFit.fill),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 150, left: 30),
                      height: 300,
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
                                  fontSize: 50,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 21),
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
                    CustomTextField(
                      hintText: "Enter your email",
                      controller: emailController,
                    ),
                    const SizedBox(height: 21),
                    CustomTextField(
                      hintText: "Enter your pass",
                      obscureText: isCheck,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isCheck = !isCheck;
                            });
                          },
                          icon: isCheck
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)),
                      controller: passController,
                    ),
                    const SizedBox(height: 21),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        label: "Login",
                        onTap: () async {
                          if (emailController.text.isNotEmpty &&
                              passController.text.isNotEmpty) {
                            var auth = FirebaseAuth.instance;

                            try {
                              var userCred =
                                  await auth.signInWithEmailAndPassword(
                                      email: emailController.text.toString(),
                                      password: passController.text.toString());

                              var prefs = await SharedPreferences.getInstance();
                              prefs.setString(LoginScreen.LOGIN_PREFS_KEY,
                                  userCred.user!.uid);

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => const HomeScreen()));
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "No user found for that email.")));
                              } else if (e.code == 'wrong-password') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Wrong password provided for that user.")));
                              }
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 11),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account yet?",
                          style: TextStyle(
                              fontSize: 14,
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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: const Divider(
                            endIndent: 10,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          "OR",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: const Divider(
                            indent: 10,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 21),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        containerButton(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => MobileNumberScreen()));
                          },
                          imagePath: "assets/png/cell-phone.png",
                        ),
                        containerButton(
                          onTap: () {},
                          imagePath: "assets/png/google.png",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget containerButton({VoidCallback? onTap, String? imagePath}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 120,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Image.asset(imagePath!),
      ),
    );
  }
}

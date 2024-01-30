import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wscube_firebase/widget_constant/button.dart';

import '../widget_constant/text_field.dart';
import 'login_page.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

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
                fit: BoxFit.cover),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 21),
                  Container(
                    padding: const EdgeInsets.only(top: 150, left: 30),
                    height: 200,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedTextKit(
                          repeatForever: true,
                          isRepeatingAnimation: true,
                          animatedTexts: [
                            WavyAnimatedText(
                              "Create your account",
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
                  const SizedBox(height: 21),
                  CustomTextField(
                    hintText: "Enter your name",
                    controller: nameController,
                  ),
                  const SizedBox(height: 21),
                  CustomTextField(
                    hintText: "Enter your email",
                    controller: emailController,
                  ),
                  const SizedBox(height: 21),
                  CustomTextField(
                    hintText: "Enter your pass",
                    controller: passController,
                  ),
                  const SizedBox(height: 21),
                  CustomTextField(
                    hintText: "Confirm your pass",
                    controller: confirmPassController,
                  ),
                  const SizedBox(height: 21),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                        label: "Sign up",
                        onTap: () async {
                          if (nameController.text.isNotEmpty &&
                              emailController.text.isNotEmpty &&
                              passController.text.isNotEmpty &&
                              confirmPassController.text.isNotEmpty) {
                            if (passController.text.toString() ==
                                confirmPassController.text.toString()) {
                              var auth = FirebaseAuth.instance;
                              var fireStore = FirebaseFirestore.instance;
                              try {
                                var userCred =
                                    await auth.createUserWithEmailAndPassword(
                                        email: emailController.text.toString(),
                                        password:
                                            passController.text.toString());

                                var UUID = userCred.user!.uid;
                                var createdAt =
                                    DateTime.now().millisecondsSinceEpoch;

                                fireStore.collection("users").doc(UUID).set({
                                  "name": nameController.text.toString(),
                                  "email": userCred.user!.email,
                                  "createdAt": createdAt,
                                });

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => const LoginScreen()));
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("email-already-in-use")));
                                } else if (e.code == 'email-already-in-use') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "The account already exists for that email.")));
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("$e")));
                              }
                            }
                          }
                        }),
                  ),
                  const SizedBox(height: 11),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "You have already an account ?",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const LoginScreen()));
                        },
                        child: const Text(
                          "Login",
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
      ),
    );
  }
}

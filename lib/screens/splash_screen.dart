import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6), () async {
      var prefs = await SharedPreferences.getInstance();
      bool? checkLogin = prefs.getBool(LoginScreen.LOGIN_PREFS_KEY);
      Widget navigateTo = LoginScreen();

      if (checkLogin != null && checkLogin) {
        navigateTo = HomeScreen();
      }

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => navigateTo));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextLiquidFill(
              boxWidth: 300,
              boxHeight: 130,
              text: "Welcome",
              textStyle: GoogleFonts.habibi(
                fontSize: 60,
                color: Colors.blue,
                fontWeight: FontWeight.w900,
              ),
            ),
            TextLiquidFill(
              boxWidth: 300,
              boxHeight: 130,
              text: "To our app",
              textStyle: GoogleFonts.habibi(
                fontSize: 40,
                color: Colors.orange,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

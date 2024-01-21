import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wscube_firebase/screens/home_screen.dart';
import 'package:wscube_firebase/screens/login_page.dart';
import 'package:wscube_firebase/widget_constant/button.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen(
      {super.key, required this.moNumber, required this.mVerificationId});

  final int moNumber;
  final String mVerificationId;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otp1 = TextEditingController();
  TextEditingController otp2 = TextEditingController();
  TextEditingController otp3 = TextEditingController();
  TextEditingController otp4 = TextEditingController();
  TextEditingController otp5 = TextEditingController();
  TextEditingController otp6 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.back,
            size: 40,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/3763926.webp", height: 280),
              const Text(
                "OTP Verification",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 11),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Enter the OTP sent to ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "+91-${widget.moNumber}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 21),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      mTextField(controller: otp1, mFocus: true),
                      mTextField(controller: otp2, mFocus: false),
                      mTextField(controller: otp3, mFocus: false),
                      mTextField(controller: otp4, mFocus: false),
                      mTextField(controller: otp5, mFocus: false),
                      mTextField(controller: otp6, mFocus: false),
                    ]),
              ),
              const SizedBox(height: 11),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't received the OTP ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "RESEND OTP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 11),
              CustomButton(
                label: "VERIFY & PROCEED",
                onTap: () async {
                  if (otp1.text.isNotEmpty &&
                      otp2.text.isNotEmpty &&
                      otp3.text.isNotEmpty &&
                      otp4.text.isNotEmpty &&
                      otp5.text.isNotEmpty &&
                      otp6.text.isNotEmpty) {
                    var otpCode =
                        "${otp1.text.toString()}${otp2.text.toString()}${otp3.text.toString()}${otp4.text.toString()}${otp5.text.toString()}${otp6.text.toString()}";
                    var credential = PhoneAuthProvider.credential(
                        verificationId: widget.mVerificationId,
                        smsCode: otpCode);
                    var auth = FirebaseAuth.instance;
                    var userCred = await auth.signInWithCredential(credential);

                    var prefs = await SharedPreferences.getInstance();
                    prefs.setString(
                        LoginScreen.LOGIN_PREFS_KEY, userCred.user!.uid);

                    if (!mounted) {
                      return;
                    }
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mTextField(
      {required TextEditingController controller, required bool mFocus}) {
    return SizedBox(
      width: 40,
      height: 55,
      child: TextFormField(
        controller: controller,
        maxLength: 1,
        autofocus: mFocus,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
        style: const TextStyle(
          fontSize: 22,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          counterText: '',
        ),
      ),
    );
  }
}

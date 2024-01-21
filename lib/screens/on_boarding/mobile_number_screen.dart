import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wscube_firebase/widget_constant/button.dart';
import 'package:wscube_firebase/screens/on_boarding/otp_screen.dart';

class MobileNumberScreen extends StatelessWidget {
  MobileNumberScreen({super.key});

  final TextEditingController mobileController = TextEditingController();

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
          child: Center(
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
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "We will send you an ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: "One Time Password",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "on this mobile number",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 41),
                const Text(
                  "Enter Mobile Number",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    maxLength: 10,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      prefix: Text(
                        "+91-",
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                      counterText: "",
                    ),
                  ),
                ),
                const SizedBox(height: 41),
                CustomButton(
                  label: "Get OTP",
                  onTap: () async {
                    if (mobileController.text.isNotEmpty) {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: "+91${mobileController.text.toString()}",
                        verificationCompleted:
                            (PhoneAuthCredential credential) {
                          print("Verification Completed");
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          print("Verification Failed");
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                        codeSent: (String verificationId, int? resendToken) {
                          // navigate to next screen (OTP)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => OTPScreen(
                                        moNumber:
                                            int.parse(mobileController.text),
                                        mVerificationId: verificationId,
                                      )));
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

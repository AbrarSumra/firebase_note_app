import 'package:flutter/material.dart';

class OtpTextField extends StatelessWidget {
  const OtpTextField({
    super.key,
    this.controller,
  });

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 50,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 18),
        autofocus: true,
        maxLength: 1,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          counterText: "",
        ),
      ),
    );
  }
}

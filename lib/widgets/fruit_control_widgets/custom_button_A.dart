import 'package:flutter/material.dart';

class CustomButtonA extends StatelessWidget {
  const CustomButtonA(
      {super.key, required this.buttonText, required this.onPressed});

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 20),
      height: MediaQuery.of(context).size.height * 0.065,
      child: InkWell(
        onTap: () => onPressed.call(),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

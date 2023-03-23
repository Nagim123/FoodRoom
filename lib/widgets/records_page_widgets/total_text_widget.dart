import 'package:flutter/material.dart';

class TotalTextWidget extends StatelessWidget {
  const TotalTextWidget(
      {super.key, required this.upperText, required this.bottomText});

  final String upperText;
  final String bottomText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          upperText,
          style: const TextStyle(
              fontSize: 13, fontFamily: "Saira", fontWeight: FontWeight.w900),
        ),
        Text(
          bottomText,
          style: const TextStyle(
            fontSize: 10,
            color: Color.fromARGB(255, 61, 58, 91),
          ),
        )
      ],
    );
  }
}

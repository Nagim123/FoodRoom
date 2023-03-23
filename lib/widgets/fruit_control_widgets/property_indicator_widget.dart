import 'package:flutter/material.dart';

class PropertyIndicatorWidget extends StatelessWidget {
  const PropertyIndicatorWidget(
      {super.key, required this.mainText, required this.extraText});

  final String mainText;
  final String extraText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(children: [
          RichText(
            text: TextSpan(
              text: mainText.split(' ')[0],
              style: const TextStyle(
                fontSize: 21,
                color: Colors.white,
                fontFamily: "Saira",
                fontWeight: FontWeight.w900,
              ),
              children: [
                TextSpan(
                  text: " ${mainText.split(' ')[1]}",
                  style: const TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
          ),
          Text(
            extraText,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ]),
      ),
    );
  }
}

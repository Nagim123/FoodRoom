import 'package:flutter/material.dart';

class CameraControlWidget extends StatelessWidget {
  const CameraControlWidget({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text(
        "Сфотографируйте продукт",
        style: TextStyle(
            fontSize: 17,
            color: Color.fromARGB(255, 97, 99, 106),
            fontFamily: "Raleway",
            fontWeight: FontWeight.w900),
      ),
      Expanded(
          child: ElevatedButton(
        onPressed: () => onPressed.call(),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(75, 75),
          shape: const CircleBorder(
              side: BorderSide(color: Colors.white, width: 1)),
          backgroundColor: const Color.fromARGB(255, 107, 86, 120),
        ),
        child: const Icon(
          Icons.camera_enhance_rounded,
          size: 36,
          color: Colors.white,
        ),
      ))
    ]);
  }
}

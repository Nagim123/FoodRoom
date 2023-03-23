import 'package:flutter/material.dart';

class MealChoicerController {
  late int currentChoice;
}

class MealChoicerWidget extends StatefulWidget {
  const MealChoicerWidget({super.key, required this.controller});

  final MealChoicerController controller;

  @override
  State<MealChoicerWidget> createState() => _MealChoicerWidget();
}

class _MealChoicerWidget extends State<MealChoicerWidget> {
  int currentChoice = 1;

  @override
  void initState() {
    widget.controller.currentChoice = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: ElevatedButton(
            onPressed: () {
              currentChoice = 0;
              widget.controller.currentChoice = currentChoice;
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 45),
              backgroundColor: currentChoice == 0
                  ? const Color.fromARGB(255, 97, 78, 110)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23),
                side: const BorderSide(
                  width: 2.0,
                  color: Colors.white,
                ),
              ),
            ),
            child: const Text(
              "Завтрак",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 4,
          child: ElevatedButton(
            onPressed: () {
              currentChoice = 1;
              widget.controller.currentChoice = currentChoice;
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 45),
              backgroundColor: currentChoice == 1
                  ? const Color.fromARGB(255, 97, 78, 110)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23),
                side: const BorderSide(
                  width: 2.0,
                  color: Colors.white,
                ),
              ),
            ),
            child: const Text(
              "Обед",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 4,
          child: ElevatedButton(
            onPressed: () {
              currentChoice = 2;
              widget.controller.currentChoice = currentChoice;
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 45),
              backgroundColor: currentChoice == 2
                  ? const Color.fromARGB(255, 97, 78, 110)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23),
                side: const BorderSide(
                  width: 2.0,
                  color: Colors.white,
                ),
              ),
            ),
            child: const Text(
              "Ужин",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

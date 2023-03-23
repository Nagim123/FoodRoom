import 'package:flutter/material.dart';
import 'package:food_ai/containers/food_recording.dart';
import 'package:food_ai/widgets/dialogues/record_preview_dialogue.dart';

class FoodRecordWidget extends StatelessWidget {
  const FoodRecordWidget({super.key, required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                foodRecord.foodName,
                style: const TextStyle(
                    fontSize: 11, color: Color.fromARGB(255, 61, 58, 91)),
              ),
            ),
          ),
          Expanded(flex: 1, child: Container()),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                foodRecord.calories.toString(),
                style: const TextStyle(
                    fontSize: 13,
                    fontFamily: "Saira",
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
          Expanded(flex: 2, child: Container()),
          Expanded(
              flex: 1,
              child: SizedBox(
                height: 32,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    splashColor: const Color.fromARGB(50, 115, 91, 237),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    ),
                    onTap: () => showFoodPreview(context, foodRecord),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

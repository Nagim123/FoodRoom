import 'package:flutter/material.dart';
import 'package:food_ai/containers/food_recording.dart';
import 'package:food_ai/pages/record_preview_page.dart';

Future<void> showFoodPreview(
    BuildContext context, FoodRecord foodToShow) async {
  showDialog(
    barrierColor: const Color.fromARGB(200, 0, 0, 0),
    context: context,
    builder: (BuildContext context) =>
        RecordPreviewPage(foodRecord: foodToShow),
  );
}

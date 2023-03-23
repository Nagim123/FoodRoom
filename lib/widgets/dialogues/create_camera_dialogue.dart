import 'package:flutter/material.dart';
import 'package:food_ai/containers/food_recording.dart';
import 'package:food_ai/pages/camera_page.dart';

Future<void> showCameraPage(
    BuildContext context, Function(FoodRecord) onFoodCreateSuccess) async {
  showDialog(
      barrierColor: Colors.black,
      context: context,
      builder: (BuildContext context) => CameraPage(
            onRecordMakeSucess: onFoodCreateSuccess,
          ));
}

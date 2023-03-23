import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_ai/containers/food_recording.dart';
import 'package:food_ai/widgets/custom_calendar/custom_calendar_widget.dart';
import 'package:food_ai/widgets/dialogues/create_camera_dialogue.dart';
import 'package:food_ai/widgets/records_page_widgets/meal_choicer/meal_choicer_widget.dart';

Future<void> showCustomDataPicker(
    BuildContext context,
    CustomCalendarController customCalendarController,
    MealChoicerController mealChoicerController,
    Function(FoodRecord) onFoodCreateSuccess) async {
  showGeneralDialog(
    transitionDuration: const Duration(milliseconds: 500),
    context: context,
    pageBuilder: (ctx, anim1, anim2) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomCalendar(controller: customCalendarController),
                  Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: MealChoicerWidget(controller: mealChoicerController),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text("Добавить продукт",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  showCameraPage(context, onFoodCreateSuccess);
                },
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: 12 * anim1.value, sigmaY: 12 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
  );
}

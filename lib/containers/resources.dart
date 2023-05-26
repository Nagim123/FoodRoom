import 'dart:ui';

import 'package:food_ai/containers/food.dart';
import 'package:food_ai/utils/hive_food_manager.dart';
import 'package:food_ai/utils/isolated_model.dart';

class Resources {
  final List<Food> food;
  final HiveFoodManager hiveFoodManager;
  final Size screenSize;
  final double screenRatio;
  final double focalLength;
  final IsolatedModel model;

  Resources(
      {required this.food,
      required this.hiveFoodManager,
      required this.screenSize,
      required this.screenRatio,
      required this.focalLength,
      required this.model});
}

late Resources resources;

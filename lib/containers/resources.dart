import 'package:camera/camera.dart';
import 'package:food_ai/containers/food.dart';
import 'package:food_ai/containers/neural_model.dart';
import 'package:food_ai/utils/hive_food_manager.dart';

class Resources {
  final CameraDescription camera;
  final List<Food> food;
  final NeuralModel neuralModel;
  final HiveFoodManager hiveFoodManager;

  Resources(
      {required this.camera,
      required this.food,
      required this.neuralModel,
      required this.hiveFoodManager});
}

late Resources resources;

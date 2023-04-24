import 'package:flutter/material.dart';

class Prediction {
  final String foodName;
  final double mass;

  Prediction(this.foodName, this.mass);
}

class NeuralModel {
  Prediction predictByImage(Image image, double distance, double focalLength) {
    print("GOT DISTANCE:$distance and focallll ${focalLength}");
    return Prediction("Помидор", 100);
  }
}

import 'package:flutter/material.dart';

class Prediction {
  final String foodName;
  final double mass;

  Prediction(this.foodName, this.mass);
}

class NeuralModel {
  Prediction predictByImage(Image image, double distance) {
    print("GOT DISTANCE:$distance");
    return Prediction("Помидор", 100);
  }
}

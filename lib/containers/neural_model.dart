class Prediction {
  final String foodName;
  final double mass;

  Prediction(this.foodName, this.mass);
}

class NeuralModel {
  Prediction predictByImage(String pathToImage) {
    return Prediction("Помидор", 100);
  }
}

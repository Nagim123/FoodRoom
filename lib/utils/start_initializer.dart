import '../containers/food.dart';
import '../containers/neural_model.dart';

List<Food> initializeAllFood() {
  List<Food> availableFood = [];

  availableFood.add(Food('Апельсин', 0.315, 0.0092, 0.002, 0.11));
  availableFood.add(Food('Яблоко', 0.522, 0.004, 0.004, 0.116));
  availableFood.add(Food('Капуста', 0.28, 0.018, 0.001, 0.047));
  availableFood.add(Food('Лимон', 0.346, 0.0082, 0.0025, 0.042));
  availableFood.add(Food('Персик', 0.456, 0.009, 0.0013, 0.101));
  availableFood.add(Food('Груша', 0.4844, 0.0049, 0.00325, 0.1136));
  availableFood.add(Food('Картошка', 0.7875, 0.0194, 0.0025, 0.1712));
  availableFood.add(Food('Тыква', 0.22, 0.01, 0.001, 0.044));
  availableFood.add(Food('Помидор', 0.21, 0.00925, 0.002, 0.039));
  availableFood.add(Food('Арбуз', 0.28, 0.00617, 0.00157, 0.0647));
  availableFood.add(Food('Авокадо', 1.83, 0.02, 0.1734, 0.0731));
  availableFood.add(Food('Лук', 0.4339, 0.0148, 0.0022, 0.0926));

  availableFood.sort((a, b) => a.name.compareTo(b.name));

  return availableFood;
}

NeuralModel initilizeNeuralModel() {
  return NeuralModel();
}

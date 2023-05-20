class Food {
  final String name;
  final double _caloriesCoefficient;
  final double _proteinCoefficient;
  final double _fatCoefficient;
  final double _carbohydratesCoefficient;
  final double _density_g_cm3;

  Food(
      this.name,
      this._caloriesCoefficient,
      this._proteinCoefficient,
      this._fatCoefficient,
      this._carbohydratesCoefficient,
      this._density_g_cm3);

  double resolveMass(double volume_cm3) {
    print("Mass: ${volume_cm3 * _density_g_cm3}g");
    return (volume_cm3 * _density_g_cm3).roundToDouble();
  }

  String getCalories(double mass) {
    return (mass * _caloriesCoefficient).toStringAsFixed(2);
  }

  String getProteins(double mass) {
    return (mass * _proteinCoefficient).toStringAsFixed(2);
  }

  String getFats(double mass) {
    return (mass * _fatCoefficient).toStringAsFixed(2);
  }

  String getCarbohydrates(double mass) {
    return (mass * _carbohydratesCoefficient).toStringAsFixed(2);
  }

  double getCaloriesDouble(double mass) {
    return double.parse((mass * _caloriesCoefficient).toStringAsFixed(2));
  }

  double getProteinsDouble(double mass) {
    return double.parse((mass * _proteinCoefficient).toStringAsFixed(2));
  }

  double getFatsDouble(double mass) {
    return double.parse((mass * _fatCoefficient).toStringAsFixed(2));
  }

  double getCarbohydratesDouble(double mass) {
    return double.parse((mass * _carbohydratesCoefficient).toStringAsFixed(2));
  }
}

import 'package:food_ai/containers/food.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class FoodRecord {
  @HiveField(0)
  final String foodName;
  @HiveField(1)
  final double calories;
  @HiveField(2)
  final double proteins;
  @HiveField(3)
  final double fats;
  @HiveField(4)
  final double carbohydrates;
  @HiveField(5)
  final double mass;

  FoodRecord.create(this.foodName, this.calories, this.proteins, this.fats,
      this.carbohydrates, this.mass);

  factory FoodRecord(Food food, double mass) {
    return FoodRecord.create(
        food.name,
        food.getCaloriesDouble(mass),
        food.getProteinsDouble(mass),
        food.getFatsDouble(mass),
        food.getCarbohydratesDouble(mass),
        mass);
  }
}

@HiveType(typeId: 2)
class RecordCluster {
  @HiveField(0)
  final List<FoodRecord> _records;

  static const int maxValue = 999;

  RecordCluster(this._records);

  void addNewRecord(FoodRecord foodRecord) {
    _records.add(foodRecord);
  }

  List<FoodRecord> getAllRecords() {
    return _records;
  }

  bool isEmpty() {
    return _records.isEmpty;
  }

  String calculateTotalCalories() {
    double result = 0;
    for (int i = 0; i < _records.length; i++) {
      result += _records[i].calories;
    }
    if (result > maxValue) {
      return "999+";
    }
    return result.toStringAsFixed(2);
  }

  String calculateTotalProteins() {
    double result = 0;
    for (int i = 0; i < _records.length; i++) {
      result += _records[i].proteins;
    }
    if (result > maxValue) {
      return "999+";
    }
    return result.toStringAsFixed(2);
  }

  String calculateTotalFats() {
    double result = 0;
    for (int i = 0; i < _records.length; i++) {
      result += _records[i].fats;
    }
    if (result > maxValue) {
      return "999+";
    }
    return result.toStringAsFixed(2);
  }

  String calculateTotalCarbohydrates() {
    double result = 0;
    for (int i = 0; i < _records.length; i++) {
      result += _records[i].carbohydrates;
    }
    if (result > maxValue) {
      return "999+";
    }
    return result.toStringAsFixed(2);
  }
}

@HiveType(typeId: 3)
class DayRecording {
  @HiveField(0)
  final RecordCluster breakfast;
  @HiveField(1)
  final RecordCluster lunch;
  @HiveField(2)
  final RecordCluster dinner;
  @HiveField(3)
  final DateTime dayDate;

  String getDayDateInRussian() {
    Map monthNames = {
      1: "Января",
      2: "Февраля",
      3: "Марта",
      4: "Апреля",
      5: "Мая",
      6: "Июня",
      7: "Июля",
      8: "Августа",
      9: "Сентября",
      10: "Октября",
      11: "Ноября",
      12: "Декабря"
    };

    DateTime curDate = DateTime.now();
    if (dayDate.day == curDate.day &&
        dayDate.year == curDate.year &&
        dayDate.month == curDate.month) {
      return "Сегодня, ${dayDate.day} ${monthNames[dayDate.month]}";
    }

    return "${dayDate.day} ${monthNames[dayDate.month]}";
  }

  String getId() {
    return "${dayDate.year}-${dayDate.month}-${dayDate.day}";
  }

  bool hasEqualDate(DateTime dateTime) {
    return dateTime.year == dayDate.year &&
        dateTime.month == dayDate.month &&
        dateTime.day == dayDate.day;
  }

  DayRecording(this.breakfast, this.lunch, this.dinner, this.dayDate);
}

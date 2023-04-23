import 'package:flutter/material.dart';
import 'package:food_ai/containers/food_recording.dart';
import 'package:food_ai/containers/resources.dart';
import 'package:food_ai/widgets/dialogues/success_safe_dialogue.dart';
import 'package:food_ai/widgets/fruit_control_widgets/custom_button_A.dart';
import 'package:food_ai/widgets/fruit_control_widgets/drop_down_menu_widget.dart';
import 'package:food_ai/widgets/fruit_control_widgets/fruit_mass_input_widget.dart';
import 'package:food_ai/widgets/fruit_control_widgets/property_indicator_widget.dart';

import '../../containers/food.dart';
import '../dialogues/ask_for_delete_dialogue.dart';

class FruitControlController {
  late VoidCallback forceExitFunction;

  void forceExit() {
    forceExitFunction.call();
  }
}

class FruitControlWidget extends StatefulWidget {
  const FruitControlWidget(
      {super.key,
      required this.currentFoodName,
      required this.initialMass,
      required this.onFoodSaveSuccess,
      required this.controller});

  final Function(FoodRecord) onFoodSaveSuccess;
  final String currentFoodName;
  final double initialMass;
  final FruitControlController controller;

  @override
  State<FruitControlWidget> createState() => _FruitControlWidget();
}

class _FruitControlWidget extends State<FruitControlWidget> {
  late List<Food> availableFood;
  late List<String> foodName;

  late Food currentFood;
  late double currentMass;

  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    availableFood = resources.food;
    foodName = List<String>.generate(
        availableFood.length, (index) => availableFood[index].name);

    currentFood = availableFood[foodName.indexOf(widget.currentFoodName)];
    currentMass = widget.initialMass;

    widget.controller.forceExitFunction = () {
      isVisible = false;
      setState(() {});
      showDeleteQuestion(context, "Вы уверены, что хотите отменить действие?",
          () {
        Navigator.of(context).pop();
      }, () {
        isVisible = true;
        setState(() {});
      }, () {
        isVisible = true;
        setState(() {});
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isVisible == false) {
      return Container();
    }
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Align(
            child: DropDownMenu(
              initialValue: currentFood.name,
              onChanged: (value) {
                for (int i = 0; i < availableFood.length; i++) {
                  if (availableFood[i].name == value) {
                    currentFood = availableFood[i];
                    break;
                  }
                }
                setState(() {});
              },
              list: foodName,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FruitMassInputWidget(
              initialValue: currentMass.toString(),
              onChanged: (newText) {
                if (newText.isEmpty) {
                  currentMass = 0;
                  setState(() {});
                  return;
                }

                currentMass = double.parse(newText);
                setState(() {});
              },
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PropertyIndicatorWidget(
                        mainText:
                            '${currentFood.getCalories(currentMass)} ккал',
                        extraText: 'Калории'),
                    PropertyIndicatorWidget(
                        mainText: '${currentFood.getProteins(currentMass)} г',
                        extraText: 'Белки')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PropertyIndicatorWidget(
                        mainText: '${currentFood.getFats(currentMass)} г',
                        extraText: 'Жиры'),
                    PropertyIndicatorWidget(
                        mainText:
                            '${currentFood.getCarbohydrates(currentMass)} г',
                        extraText: 'Углеводы')
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomButtonA(
                    buttonText: "Отменить",
                    onPressed: () {
                      isVisible = false;
                      setState(() {});
                      showDeleteQuestion(
                          context,
                          "Вы уверены, что хотите отменить действие?",
                          () => Navigator.of(context).pop(), () {
                        isVisible = true;
                        setState(() {});
                      }, () {
                        isVisible = true;
                        setState(() {});
                      });
                    },
                  ),
                ),
                Expanded(
                  child: CustomButtonA(
                    buttonText: "Сохранить",
                    onPressed: () {
                      //Save record
                      FoodRecord foodRecord =
                          FoodRecord(currentFood, currentMass);
                      widget.onFoodSaveSuccess(foodRecord);
                      isVisible = false;
                      setState(() {});
                      showSuccessSafe(context);
                      //Go back
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

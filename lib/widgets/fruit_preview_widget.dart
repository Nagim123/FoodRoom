import 'package:flutter/material.dart';
import 'package:food_ai/containers/food_recording.dart';
import 'package:food_ai/containers/resources.dart';
import 'package:food_ai/widgets/dialogues/success_safe_dialogue.dart';
import 'package:food_ai/widgets/fruit_control_widgets/custom_button_A.dart';
import 'package:food_ai/widgets/fruit_control_widgets/drop_down_menu_widget.dart';
import 'package:food_ai/widgets/fruit_control_widgets/fruit_mass_input_widget.dart';
import 'package:food_ai/widgets/fruit_control_widgets/property_indicator_widget.dart';

import '../../containers/food.dart';

class FruitPreviewWidget extends StatefulWidget {
  const FruitPreviewWidget({super.key, required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  State<FruitPreviewWidget> createState() => _FruitPreviewWidget();
}

class _FruitPreviewWidget extends State<FruitPreviewWidget> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isVisible == false) {
      return Container();
    }
    return Column(
      children: [
        Expanded(flex: 2, child: Container()),
        Container(
          margin:
              const EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 20),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  widget.foodRecord.foodName,
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FruitMassInputWidget(
              disableEdit: true,
              initialValue: widget.foodRecord.mass.toStringAsFixed(2),
              onChanged: (value) {},
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
                        mainText: '${widget.foodRecord.calories} ккал',
                        extraText: 'Калории'),
                    PropertyIndicatorWidget(
                        mainText: '${widget.foodRecord.proteins} г',
                        extraText: 'Белки')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PropertyIndicatorWidget(
                        mainText: '${widget.foodRecord.fats} г',
                        extraText: 'Жиры'),
                    PropertyIndicatorWidget(
                        mainText: '${widget.foodRecord.carbohydrates} г',
                        extraText: 'Углеводы')
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(flex: 2, child: Container()),
      ],
    );
  }
}

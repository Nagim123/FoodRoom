import 'package:flutter/material.dart';
import 'package:food_ai/containers/food_recording.dart';
import 'package:food_ai/widgets/records_page_widgets/food_record_widget.dart';
import 'package:food_ai/widgets/records_page_widgets/total_text_widget.dart';

class FoodClusterWidget extends StatelessWidget {
  const FoodClusterWidget(
      {super.key, required this.recordCluster, required this.mealName});

  final RecordCluster recordCluster;
  final String mealName;

  List<Widget> generateRecordingsList() {
    List<Widget> recordings = [];

    for (int i = 0; i < recordCluster.getAllRecords().length; i++) {
      recordings
          .add(FoodRecordWidget(foodRecord: recordCluster.getAllRecords()[i]));
    }

    return recordings;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
          margin: const EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    mealName,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 1,
                child: TotalTextWidget(
                  bottomText: "Калории",
                  upperText: recordCluster.calculateTotalCalories(),
                ),
              ),
              Expanded(
                flex: 1,
                child: TotalTextWidget(
                  bottomText: "Белки",
                  upperText: recordCluster.calculateTotalProteins(),
                ),
              ),
              Expanded(
                flex: 1,
                child: TotalTextWidget(
                    bottomText: "Жиры",
                    upperText: recordCluster.calculateTotalFats()),
              ),
              Expanded(
                flex: 1,
                child: TotalTextWidget(
                    bottomText: "Углеводы",
                    upperText: recordCluster.calculateTotalCarbohydrates()),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          child: Column(children: generateRecordingsList()),
        )
      ]),
    );
  }
}

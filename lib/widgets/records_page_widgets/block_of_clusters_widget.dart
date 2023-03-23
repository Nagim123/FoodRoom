import 'package:flutter/material.dart';
import 'package:food_ai/containers/food_recording.dart';
import 'package:food_ai/widgets/records_page_widgets/food_cluster_widget.dart';

class BlockOfClustersWidget extends StatelessWidget {
  const BlockOfClustersWidget({super.key, required this.dayRecording});

  final DayRecording dayRecording;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.only(left: 24),
          margin: const EdgeInsets.only(bottom: 5),
          alignment: Alignment.topLeft,
          child: Text(
            dayRecording.getDayDateInRussian(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(23)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(199, 165, 158, 197),
              ),
              BoxShadow(
                color: Color.fromARGB(255, 182, 176, 211),
                spreadRadius: -12.0,
                blurRadius: 12.0,
              ),
            ],
          ),
          child: Column(children: [
            dayRecording.breakfast.isEmpty()
                ? Container()
                : FoodClusterWidget(
                    recordCluster: dayRecording.breakfast, mealName: "Завтрак"),
            dayRecording.breakfast.isEmpty() ||
                    (dayRecording.dinner.isEmpty() &&
                        dayRecording.lunch.isEmpty())
                ? Container()
                : const Divider(height: 5),
            dayRecording.lunch.isEmpty()
                ? Container()
                : FoodClusterWidget(
                    recordCluster: dayRecording.lunch, mealName: "Обед"),
            dayRecording.lunch.isEmpty() || dayRecording.dinner.isEmpty()
                ? Container()
                : const Divider(height: 5),
            dayRecording.dinner.isEmpty()
                ? Container()
                : FoodClusterWidget(
                    recordCluster: dayRecording.dinner, mealName: "Ужин"),
          ]),
        )
      ]),
    );
  }
}

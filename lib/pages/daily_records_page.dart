import 'package:flutter/material.dart';
import 'package:food_ai/containers/food_recording.dart';
import 'package:food_ai/containers/resources.dart';
import 'package:food_ai/widgets/custom_calendar/custom_calendar_widget.dart';
import 'package:food_ai/widgets/decoration/beautiful_circle.dart';
import 'package:food_ai/widgets/dialogues/create_day_record_dialogue.dart';
import 'package:food_ai/widgets/records_page_widgets/block_of_clusters_widget.dart';
import 'package:food_ai/widgets/records_page_widgets/meal_choicer/meal_choicer_widget.dart';

class DailyRecordsPage extends StatefulWidget {
  const DailyRecordsPage({super.key});

  @override
  State<DailyRecordsPage> createState() => _DailyRecordsPage();
}

class _DailyRecordsPage extends State<DailyRecordsPage> {
  CustomCalendarController customCalendarController =
      CustomCalendarController();
  MealChoicerController mealChoicerController = MealChoicerController();
  late List<DayRecording> dayRecordingList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 61, 58, 91),
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0.5, 0.6),
            child: Transform.scale(
              scale: 8,
              child: BeautifulCircle(
                circleRadius: MediaQuery.of(context).size.width / 4,
                mainColor: const Color.fromARGB(15, 241, 73, 133),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.5, -0.6),
            child: Transform.scale(
              scale: 8,
              child: BeautifulCircle(
                circleRadius: MediaQuery.of(context).size.width / 4,
                mainColor: const Color.fromARGB(50, 115, 91, 237),
              ),
            ),
          ),
          FutureBuilder(
              future: resources.hiveFoodManager.loadAllDayRecordings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != null) {
                    dayRecordingList = snapshot.data!;
                  }
                  if (dayRecordingList.isEmpty) {
                    return const Center(
                      child: Text(
                        "Вы еще не добавили ни одного приема пищи",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: dayRecordingList.length + 1,
                      itemBuilder: (_, i) {
                        if (i == dayRecordingList.length) {
                          return Container(
                            height: 200,
                          );
                        } else {
                          return BlockOfClustersWidget(
                            dayRecording: dayRecordingList[i],
                          );
                        }
                      },
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 97, 79, 110),
        shape: const StadiumBorder(
          side: BorderSide(color: Colors.white, width: 1),
        ),
        child: const Icon(
          Icons.add,
          size: 32,
        ),
        onPressed: () {
          showCustomDataPicker(
              context, customCalendarController, mealChoicerController,
              (foodRecord) async {
            DayRecording? newDayRecording;
            for (int rId = 0; rId < dayRecordingList.length; rId++) {
              if (dayRecordingList[rId]
                  .hasEqualDate(customCalendarController.savedDateTime)) {
                newDayRecording = dayRecordingList[rId];
              }
            }
            if (newDayRecording == null) {
              if (mealChoicerController.currentChoice == 0) {
                newDayRecording = DayRecording(
                    RecordCluster([foodRecord]),
                    RecordCluster([]),
                    RecordCluster([]),
                    customCalendarController.savedDateTime);
                dayRecordingList.add(newDayRecording);
              } else if (mealChoicerController.currentChoice == 1) {
                newDayRecording = DayRecording(
                    RecordCluster([]),
                    RecordCluster([foodRecord]),
                    RecordCluster([]),
                    customCalendarController.savedDateTime);
                dayRecordingList.add(newDayRecording);
              } else if (mealChoicerController.currentChoice == 2) {
                newDayRecording = DayRecording(
                    RecordCluster([]),
                    RecordCluster([]),
                    RecordCluster([foodRecord]),
                    customCalendarController.savedDateTime);
                dayRecordingList.add(newDayRecording);
              }
            } else {
              if (mealChoicerController.currentChoice == 0) {
                newDayRecording.breakfast.addNewRecord(foodRecord);
              } else if (mealChoicerController.currentChoice == 1) {
                newDayRecording.lunch.addNewRecord(foodRecord);
              } else if (mealChoicerController.currentChoice == 2) {
                newDayRecording.dinner.addNewRecord(foodRecord);
              }
            }
            await resources.hiveFoodManager.saveDayRecording(newDayRecording!);
            setState(() {});
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

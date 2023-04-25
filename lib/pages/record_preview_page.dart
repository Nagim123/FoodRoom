import 'package:flutter/material.dart';
import 'package:food_ai/containers/food_recording.dart';
import 'package:food_ai/containers/resources.dart';
import 'package:food_ai/pages/daily_records_page.dart';
import 'package:food_ai/widgets/fruit_control_widgets/fruit_control_widget.dart';
import 'package:food_ai/widgets/fruit_preview_widget.dart';

import '../widgets/decoration/beautiful_circle.dart';
import '../widgets/dialogues/ask_for_delete_dialogue.dart';
import '../widgets/fruit_control_widgets/custom_button_A.dart';

class RecordPreviewPage extends StatefulWidget {
  const RecordPreviewPage(
      {super.key,
      required this.foodRecord,
      required this.recordCluster,
      required this.dayRecording});

  final FoodRecord foodRecord;
  final RecordCluster recordCluster;
  final DayRecording dayRecording;

  @override
  State<RecordPreviewPage> createState() => _RecordPreviewPage();
}

class _RecordPreviewPage extends State<RecordPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 61, 58, 91),
      appBar: AppBar(
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
          Container(
            color: const Color.fromARGB(150, 0, 0, 0),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: FruitPreviewWidget(
              foodRecord: widget.foodRecord,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: CustomButtonA(
              buttonText: "Удалить",
              onPressed: () {
                showDeleteQuestion(
                    context, "Вы уверены, что хотите удалить продукт?",
                    () async {
                  Navigator.of(context).pop();
                  widget.recordCluster.deleteOneRecord(widget.foodRecord);
                  await resources.hiveFoodManager
                      .saveDayRecording(widget.dayRecording);
                  globalFunctionToUpdateDays();
                }, () {}, () {});
              },
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:food_ai/containers/record_pointers.dart';
import 'package:food_ai/pages/daily_records_page.dart';
import 'package:food_ai/utils/hive_food_manager.dart';
import 'package:food_ai/utils/start_initializer.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'containers/food_adapters.dart';
import 'containers/resources.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  resources = Resources(
    camera: cameras.first,
    food: await initializeAllFood(),
    neuralModel: initilizeNeuralModel(),
    hiveFoodManager: HiveFoodManager(),
  );

  Directory dir = await getApplicationDocumentsDirectory();

  Hive.init(dir.path);
  Hive.registerAdapter(DayRecordingAdapter());
  Hive.registerAdapter(RecordPointersAdapter());
  //await resources.hiveFoodManager.deleteSavedData();
  await resources.hiveFoodManager.checkAndInitPointersBox();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food AI app',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: const Color.fromARGB(50, 115, 91, 237))),
      home: const DailyRecordsPage(),
    );
  }
}

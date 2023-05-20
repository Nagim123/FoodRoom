import 'dart:isolate';

import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:food_ai/containers/neural_model.dart';

void _modelIsolatedHandler(SendPort sendPort) {
  NeuralModel neuralModel = NeuralModel();

  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((message) async {
    List<dynamic> args = message as List<dynamic>;
    String imgPath = args[0] as String;
    double foodDistance = args[1] as double;
    double focalLength = args[2] as double;
    Prediction prediction =
        await neuralModel.predictByImage(imgPath, foodDistance, focalLength);
    List<dynamic> results = [prediction.foodName, prediction.volume_cm3];
    sendPort.send(results);
  });
}

class IsolatedModel {
  SendPort? _portToIsolate;
  ReceivePort? _portFromIsolate;
  Function(Prediction)? _currentOnSuccess;

  IsolatedModel() {
    _initIsolate();
  }

  void _initIsolate() async {
    _portFromIsolate = ReceivePort();

    await FlutterIsolate.spawn(
        _modelIsolatedHandler, _portFromIsolate!.sendPort);

    _portFromIsolate!.listen((message) {
      if (_portToIsolate == null) {
        _portToIsolate = message;
      } else {
        final args = message as List<dynamic>;
        _currentOnSuccess!
            .call(Prediction(args[0] as String, args[1] as double));
      }
    });
  }

  void getPrediction(Function(Prediction) onSuccess, String imgPath,
      double foodDistance, double focalLength) {
    List<dynamic> arguments = [imgPath, foodDistance, focalLength];
    _currentOnSuccess = onSuccess;
    _portToIsolate!.send(arguments);
  }
}

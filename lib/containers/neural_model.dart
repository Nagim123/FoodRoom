import 'dart:ffi';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:food_ai/utils/start_initializer.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imlb;

class Prediction {
  final String foodName;
  final double volume_cm3;

  Prediction(this.foodName, this.volume_cm3);
}

class Detector {
  late Interpreter _interpreter;

  late List<String> _labels;

  static const String MODEL_FILE_NAME = "FoodRoomYOLOv5s_12.tflite";
  static const String LABEL_FILE_NAME = "assets/labels.txt";
  static const int INPUT_SIZE = 1024;

  late List<List<int>> _outputShapes;
  // late int _outputSize;

  // late List<TfLiteType> _outputTypes;

  // initializer in such a form
  Detector() {
    loadModel();
    loadLabels();
  }

  Future<void> loadModel() async {
    try {
      print("Start loading model");
      _interpreter = await Interpreter.fromAsset(
        MODEL_FILE_NAME,
        options: InterpreterOptions()..threads = 4,
      );

      var outputTensors = _interpreter.getOutputTensors();
      _outputShapes = [];
      // _outputTypes = [];
      outputTensors.forEach((tensor) {
        _outputShapes.add(tensor.shape);
        // _outputTypes.add(tensor.type);
      });
      print("Model loaded successfully");
      var inputTensors = _interpreter.getInputTensors();
      print("Model input tensors: $inputTensors");
      print("Model output tensors: $outputTensors");
    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }

  Future<void> loadLabels() async {
    try {
      print("Start loading labels");
      _labels = [];
      await rootBundle.loadString(LABEL_FILE_NAME).then((String content) {
        _labels = content.split('\r\n');
      });
      print(_labels);
      print("Labels loaded successfully");
    } catch (e) {
      print("Error while loading labels: $e");
    }
  }

  Interpreter? get interpreter => _interpreter;

  List<String>? get labels => _labels;

  static List<List<List<double>>> imageToInput(imlb.Image image) {
    List<List<List<double>>> tensor = List.filled(INPUT_SIZE, []);
    for (int i = 0; i < INPUT_SIZE; i++) {
      tensor[i] = List.filled(INPUT_SIZE, [.0, .0, .0]);
    }

    imlb.Image resized =
        imlb.copyResize(image, width: INPUT_SIZE, height: INPUT_SIZE);

    int r, g, b;
    for (int i = 0; i < INPUT_SIZE; i++) {
      for (int j = 0; j < INPUT_SIZE; j++) {
        imlb.Pixel pixel = resized.getPixel(j, i);
        r = pixel.r.toInt();
        g = pixel.g.toInt();
        b = pixel.b.toInt();

        tensor[i][j] = [
          r.toDouble() / 255.0,
          g.toDouble() / 255.0,
          b.toDouble() / 255.0
        ];
      }
    }

    return tensor;
  }

  List<int> parsePrediction(List<double> prediction, int height, int width) {
    int x, y, w, h, cls;
    x = (width * prediction[0]).toInt();
    y = (height * prediction[1]).toInt();
    w = (width * prediction[2]).toInt();
    h = (height * prediction[2]).toInt();

    cls = 0;
    var max_cls = 0.0;
    for (int i = 0 + 5; i < 12 + 5; i++) {
      if (prediction[i] > max_cls) {
        max_cls = prediction[i];
        cls = i - 5;
      }
    }

    return <int>[x, y, w, h, cls];
  }

  List<int> predict(imlb.Image image) {
    // [1, 64512, 17] x y w h conf, class1, class2, class3, ..., class 12 = 4 + 1 + 12 = 17 Пиздец
    var inputTensor = imageToInput(image);
    int width, height;
    width = image.width;
    height = image.height;
    List<List<List<double>>> output =
        List.filled(1, List.filled(64512, List.filled(17, 0.0)));

    _interpreter.run([inputTensor], output);
    List<List<double>> listOutputs = output[0];
    List<List<double>> filteredOutputs = [];
    listOutputs.forEach((element) {
      if (element[4] > 0.5 && element[4] <= 1.0) {
        filteredOutputs.add(element);
      }
    });

    // TODO: check for empty list
    filteredOutputs.sort((a, b) => b[4].compareTo(a[4]));

    int x, y, w, h, cls;
    List<int> parsedOutput = parsePrediction(filteredOutputs[0], height, width);
    x = parsedOutput[0];
    y = parsedOutput[1];
    w = parsedOutput[2];
    h = parsedOutput[3];
    cls = parsedOutput[4];

    print(
        "Predicted class: ${_labels[cls]}, pos: ($x, $y), width: $w px, height: $h px, confidence: ${listOutputs[0][4]}");

    return <int>[w, h, cls];
  }
}

class NeuralModel {
  final Detector _detector = Detector();
  // late List<dynamic> classesData;

  // NeuralModel (){
  //   initializeAllFood();
  // }

  double calculateElipsoidVolume(double a, double b) {
    // assume our shape is elipsoid with major axes a, b, c = (a + b) / 2
    double c = (a + b) / 2;
    double volume = 4.0 / 3.0 * pi * a * b * c;

    return volume;
  }

  Future<Prediction> predictByImage(
      String imagePath, double distance, double focalLength) async {
    print("GOT DISTANCE:$distance and focallll ${focalLength}");
    imlb.Image? image = await imlb.decodeImageFile(imagePath);

    if (image == null) {
      print("Failed to load image :(");
      return Prediction("Помидор", 100);
    }

    List<int> prediction = _detector.predict(image);
    int obj_w, obj_h, img_w, img_h, cls;
    obj_w = prediction[0];
    obj_h = prediction[1];
    cls = prediction[2];

    img_w = image.width;
    img_h = image.height;

    double diagonal_fov_halfed = atan(35.0 / (2.0 * focalLength));
    double diagonal_pixel_halfed = sqrt(img_h * img_h + img_w * img_w) / 2;
    double distance_cm = distance * 100;
    double diagonal_real_halfed = distance_cm * tan(diagonal_fov_halfed);
    double cm_per_px = diagonal_real_halfed / diagonal_pixel_halfed;

    print("halfed fov: $diagonal_fov_halfed");
    print("halfed pixel diagonal: $diagonal_pixel_halfed");
    print("distance cm: $distance_cm");
    print("halfed real diagonal: $diagonal_real_halfed");
    print("cm per pixel ratio: $cm_per_px");

    double obj_w_cm = obj_w * cm_per_px;
    double obj_h_cm = obj_h * cm_per_px;
    print("Object real-world dimentions: ${obj_h_cm}x${obj_w_cm}");

    double volume_cm3 = calculateElipsoidVolume(obj_w_cm, obj_h_cm);

    return Prediction(_detector._labels[cls], volume_cm3);
  }
}

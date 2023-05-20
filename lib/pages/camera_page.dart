import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_ai/containers/food_recording.dart';
import 'package:food_ai/containers/neural_model.dart';
import 'package:food_ai/utils/isolated_model.dart';
import 'package:food_ai/widgets/dialogues/custom_alert_dialogue.dart';
import 'package:food_ai/widgets/fruit_control_widgets/fruit_control_widget.dart';
import 'package:food_ai/widgets/camera_control_widgets/ar_core_widget.dart';

import '../painters/hole_painter.dart';
import '../widgets/camera_control_widgets/camera_control_widget.dart';
import '../widgets/image_preview_widget.dart';
import '../containers/resources.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.onRecordMakeSucess});

  final Function(FoodRecord foodRecord) onRecordMakeSucess;

  @override
  State<CameraPage> createState() => _CameraPage();
}

class _CameraPage extends State<CameraPage> {
  late ArCoreWidgetController arCoreWidgetController;
  final FruitControlController fruitControlController =
      FruitControlController();
  late File _currentImage;
  late double _foodDistance;
  late bool _planeScanned;
  late bool _isPictureMade;

  Prediction? modelPrediction;

  bool isVisibleMagic = false;

  @override
  void initState() {
    super.initState();
    _isPictureMade = false;
    _planeScanned = false;
    arCoreWidgetController = ArCoreWidgetController();
  }

  Widget _getTopWidget() {
    if (_isPictureMade) {
      return ImagePreviewWidget(file: _currentImage);
    } else {
      return ArCoreWidget(
        controller: arCoreWidgetController,
        onPlaneDetected: () {
          if (_planeScanned == false) {
            _planeScanned = true;
            setState(() {});
          }
        },
        onDistanceReady: (distance) async {
          _currentImage = File(await arCoreWidgetController.takePhoto());
          _isPictureMade = true;
          _foodDistance = distance;
          setState(() {});
        },
        onDistanceFailed: () {
          showCustomAlert(context,
              "Убедитесь, что продукт находиться по центру отсканированной поверхности");
        },
      );
    }
  }

  Widget _getFilterWidget() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        alignment: Alignment.center,
        color: Colors.black.withOpacity(0.7),
        child: _isPictureMade
            ? Container()
            : Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.2 + 30,
                    top: MediaQuery.of(context).size.height * 0.1),
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width * 0.85,
                      MediaQuery.of(context).size.height),
                  painter: Hole(),
                ),
              ),
      ),
    );
  }

  Widget _getBottomWidget() {
    //Scanning logic
    if (modelPrediction != null) {
      return FruitControlWidget(
        onFoodSaveSuccess: (foodRecord) =>
            widget.onRecordMakeSucess(foodRecord),
        currentFoodName: modelPrediction!.foodName,
        initialVolume: modelPrediction!.volume_cm3,
        controller: fruitControlController,
      );
    }

    if (_isPictureMade) {
      resources.model.getPrediction((prediction) {
        modelPrediction = prediction;
        setState(() {});
      }, _currentImage.path, _foodDistance, resources.focalLength);
      return const Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
              color: Color.fromARGB(255, 107, 86, 120)),
        ),
      );
    }
    if (_planeScanned) {
      return CameraControlWidget(onPressed: () async {
        arCoreWidgetController.forceTap();
      });
    }

    return const Text(
      "Обработка поверхности...",
      style: TextStyle(
          fontSize: 17,
          color: Color.fromARGB(255, 97, 99, 106),
          fontFamily: "Raleway",
          fontWeight: FontWeight.w900),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.black,
          appBar: _isPictureMade
              ? AppBar(
                  leading: Container(),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                )
              : AppBar(
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
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: _getTopWidget(),
              ),
              _getFilterWidget(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      (_isPictureMade ? 1 : 0.2),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: _getBottomWidget(),
                ),
              )
            ],
          ),
        ),
        onWillPop: () => _willPopScopeCall(context));
  }

  Future<bool> _willPopScopeCall(BuildContext context) async {
    if (_isPictureMade) {
      fruitControlController.forceExitFunction();
      return false;
    }
    return true;
  }
}

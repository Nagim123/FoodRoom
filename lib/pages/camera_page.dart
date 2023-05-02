import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:food_ai/containers/food_recording.dart';
import 'package:food_ai/containers/neural_model.dart';
import 'package:food_ai/containers/resources.dart';
import 'package:food_ai/utils/focal_len_getter.dart';
import 'package:food_ai/widgets/camera_control_widgets/camera_preview_widget.dart';
import 'package:food_ai/widgets/fruit_control_widgets/fruit_control_widget.dart';
import 'package:food_ai/widgets/camera_control_widgets/ar_core_widget.dart';

import '../painters/hole_painter.dart';
import '../widgets/camera_control_widgets/camera_control_widget.dart';
import '../widgets/image_preview_widget.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.onRecordMakeSucess});

  final Function(FoodRecord foodRecord) onRecordMakeSucess;

  @override
  State<CameraPage> createState() => _CameraPage();
}

class _CameraPage extends State<CameraPage> {
  late CameraPreviewWidgetController cameraPreviewWidgetController;
  final FruitControlController fruitControlController =
      FruitControlController();
  late XFile _currentImage;
  late double _foodDistance;

  late bool _isPictureMade;
  late bool _wasTapped;
  late double _focalLength;

  bool isVisibleMagic = false;

  @override
  void initState() {
    super.initState();
    _isPictureMade = false;
    _wasTapped = false;
    _focalLength = 0;
    cameraPreviewWidgetController = CameraPreviewWidgetController();
  }

  Widget _getTopWidget() {
    if (_wasTapped == false) {
      return ArCoreWidget(onDistanceReady: (distance) {
        _wasTapped = true;
        _foodDistance = distance;
        setState(() {});
      });
    }

    if (_isPictureMade) {
      return ImagePreviewWidget(file: _currentImage);
    }
    return CameraPreviewWidget(
      controller: cameraPreviewWidgetController,
      onPhotoReady: (XFile image) async {
        _focalLength = await get_focal_length(image.path);
        _currentImage = image;
        _isPictureMade = true;
        setState(() {});
      },
    );
  }

  Widget _getFilterWidget() {
    if (_wasTapped == false) {
      return const SizedBox(
        width: 1,
        height: 1,
      );
    }

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

  Future<Widget> _getBottomWidget() async {
    if (_wasTapped == false) {
      return const SizedBox(
        width: 1,
        height: 1,
      );
    }

    if (_isPictureMade) {
      Image imageFile = Image.file(File(_currentImage.path));

      Prediction prediction = await resources.neuralModel
          .predictByImage(_currentImage.path, _foodDistance, _focalLength);
      return FruitControlWidget(
        onFoodSaveSuccess: (foodRecord) =>
            widget.onRecordMakeSucess(foodRecord),
        currentFoodName: prediction.foodName,
        initialVolume: prediction.volume_cm3,
        controller: fruitControlController,
      );
    }

    return Container();
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
              // BackdropFilter(
              //   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              //   child: Container(
              //     alignment: Alignment.center,
              //     color: Colors.black.withOpacity(0.7),
              //     child: _isPictureMade
              //         ? Container()
              //         : Container(
              //             alignment: Alignment.bottomCenter,
              //             margin: EdgeInsets.only(
              //                 bottom:
              //                     MediaQuery.of(context).size.height * 0.2 + 30,
              //                 top: MediaQuery.of(context).size.height * 0.1),
              //             child: CustomPaint(
              //               size: Size(MediaQuery.of(context).size.width * 0.85,
              //                   MediaQuery.of(context).size.height),
              //               painter: Hole(),
              //             ),
              //           ),
              //   ),
              // ),
              _getFilterWidget(),
              FutureBuilder(
                  future: _getBottomWidget(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: MediaQuery.of(context).size.height *
                            (_isPictureMade ? 1 : 0.2),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: snapshot.data,
                      ),
                    );
                  })
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

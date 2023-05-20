import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_ai/containers/resources.dart';
import 'package:path_provider/path_provider.dart';

class ArCoreWidgetController {
  /// Future function that makes photo using ArCoreView
  late Function takePhoto;

  /// Force tap on center of ArCoreView
  late Function forceTap;
}

class ArCoreWidget extends StatefulWidget {
  const ArCoreWidget(
      {super.key,
      required this.onDistanceReady,
      required this.onPlaneDetected,
      required this.onDistanceFailed,
      required this.controller});

  final Function(double) onDistanceReady;
  final Function() onDistanceFailed;

  /// Callback called when plane is detected
  final VoidCallback onPlaneDetected;

  final ArCoreWidgetController controller;

  @override
  State<ArCoreWidget> createState() => _ArCoreWidget();
}

class _ArCoreWidget extends State<ArCoreWidget> {
  static GlobalKey previewContainer = GlobalKey();

  ArCoreController? _arCoreController;

  @override
  void initState() {
    super.initState();
    widget.controller.takePhoto = takeScreenShot;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: previewContainer,
      child: ArCoreView(
        enableTapRecognizer: true,
        enableUpdateListener: true,
        enablePlaneRenderer: true,
        debug: false,
        onArCoreViewCreated: (ArCoreController arCoreController) {
          _arCoreController = arCoreController;
          arCoreController.onPlaneTap = (hits) async {
            if (hits.isEmpty) {
              widget.onDistanceFailed.call();
              return;
            }
            final planeTap = hits.first;
            widget.onDistanceReady(planeTap.distance);
          };
          arCoreController.onPlaneDetected = (plane) async {
            widget.onPlaneDetected.call();
          };
          widget.controller.forceTap = () {
            arCoreController.simulateTap(resources.screenSize.width / 2,
                resources.screenSize.height / 2);
          };
        },
      ),
    );
  }

  Future<String> takeScreenShot() async {
    RenderRepaintBoundary boundary = previewContainer.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;

    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    File imgFile = File('$directory/temp_picture.png');
    await imgFile.writeAsBytes(pngBytes);
    return imgFile.path;
  }

  @override
  void dispose() {
    if (_arCoreController != null) {
      _arCoreController!.dispose();
    }
    super.dispose();
  }
}

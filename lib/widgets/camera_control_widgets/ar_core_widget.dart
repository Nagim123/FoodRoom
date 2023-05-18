import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class ArCoreWidgetController {
  /// IT IS A FUTURE FUNCTION!!! Call photo taking ;) (pseudo taking...)
  late Function takePhoto;
}

class ArCoreWidget extends StatefulWidget {
  ArCoreWidget(
      {super.key, required this.onDistanceReady, required this.controller});
  final Function(double) onDistanceReady;

  ArCoreWidgetController controller;

  @override
  State<ArCoreWidget> createState() => _ArCoreWidget();
}

class _ArCoreWidget extends State<ArCoreWidget> {
  static GlobalKey previewContainer = GlobalKey();

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
        enableUpdateListener: false,
        enablePlaneRenderer: true,
        debug: false,
        onArCoreViewCreated: (ArCoreController arCoreController) {
          arCoreController.onPlaneTap = (hits) async {
            final planeTap = hits.first;
            widget.onDistanceReady(planeTap.distance);
          };
          arCoreController.onPlaneDetected = (ArCorePlane plane) {
            print("SEX! Compromised");
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
    print(pngBytes);
    File imgFile = new File('$directory/screenshot.png');
    imgFile.writeAsBytes(pngBytes);
    return imgFile.path;
  }
}

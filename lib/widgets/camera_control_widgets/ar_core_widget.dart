import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';

class ArCoreWidget extends StatefulWidget {
  const ArCoreWidget({super.key, required this.onDistanceReady});
  final Function(double) onDistanceReady;

  @override
  State<ArCoreWidget> createState() => _ArCoreWidget();
}

class _ArCoreWidget extends State<ArCoreWidget> {
  @override
  Widget build(BuildContext context) {
    return ArCoreView(
      enableTapRecognizer: true,
      enableUpdateListener: true,
      enablePlaneRenderer: true,
      debug: false,
      onArCoreViewCreated: (ArCoreController arCoreController) {
        arCoreController.onPlaneTap = (hits) async {
          final planeTap = hits.first;
          widget.onDistanceReady(planeTap.distance);
        };
      },
    );
  }
}

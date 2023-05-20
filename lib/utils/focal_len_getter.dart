import 'package:flutter/services.dart';

Future<double> getFocalLength() async {
  MethodChannel focalGetterChannel = const MethodChannel("focalLengthGetter");
  double focalLength = await focalGetterChannel.invokeMethod("getFocalLength");
  return focalLength;
}

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  const ImagePreviewWidget({super.key, required this.file});

  final XFile file;

  @override
  Widget build(BuildContext context) {
    return Image.file(File(file.path), fit: BoxFit.cover);
  }
}

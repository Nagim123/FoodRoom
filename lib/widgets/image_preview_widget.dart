import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  const ImagePreviewWidget({super.key, required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return Image.file(file, fit: BoxFit.cover);
  }
}

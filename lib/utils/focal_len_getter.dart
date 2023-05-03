import 'dart:io';

import 'package:exif/exif.dart';

Future<double> get_focal_length(String path) async {
  final fileBytes = File(path).readAsBytesSync();
  final data = await readExifFromBytes(fileBytes);

  for (final entry in data.entries) {
    // print(entry);
    // if (entry.key == "EXIF FocalLength") {
    //   List<Ratio> values = entry.value.values.toList() as List<Ratio>;
    //   return values[0].numerator / values[0].denominator;
    // }
    if (entry.key == "EXIF FocalLengthIn35mmFilm") {
      // print(entry.value.values.toList());
      List<int> values = entry.value.values.toList() as List<int>;
      // print(values);
      return values[0].toDouble();
    }
  }

  for (final entry in data.entries) {
    print("${entry.key}:${entry.value}");
  }
  return 0;
}

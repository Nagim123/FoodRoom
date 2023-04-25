import 'package:food_ai/containers/food_recording.dart';
import 'package:food_ai/containers/record_pointers.dart';
import 'package:hive/hive.dart';

class HiveFoodManager {
  Future<void> saveDayRecording(DayRecording dayRecording) async {
    final pointersBox = await Hive.openBox<RecordPointers>("PointersBox");
    RecordPointers? pointers = pointersBox.get('pointers');

    if (pointers == null) return;

    final recordingBox = await Hive.openBox<DayRecording>("Recordings");
    if (recordingBox.get(dayRecording.getId()) == null) {
      pointers.recordPointers.add(dayRecording.getId());
    }

    if (recordingBox.get(dayRecording.getId()) != null &&
        dayRecording.isEmpty()) {
      recordingBox.delete(dayRecording.getId());
      pointers.recordPointers.remove(dayRecording.getId());
    } else {
      recordingBox.put(dayRecording.getId(), dayRecording);
    }

    await recordingBox.close();
    pointers.recordPointers.sort((b, a) => a.compareTo(b));
    pointersBox.put('pointers', pointers);
    await pointersBox.close();
  }

  Future<List<DayRecording>> loadAllDayRecordings() async {
    final pointersBox = await Hive.openBox<RecordPointers>("PointersBox");
    final recordingBox = await Hive.openBox<DayRecording>("Recordings");
    RecordPointers? pointers = pointersBox.get('pointers');
    List<DayRecording> dayRecordings = [];
    pointers!.recordPointers.sort((b, a) => a.compareTo(b));

    for (int i = 0; i < pointers.recordPointers.length; i++) {
      DayRecording? dayRecording = recordingBox.get(pointers.recordPointers[i]);
      if (dayRecording != null) {
        dayRecordings.add(dayRecording);
      }
    }

    await recordingBox.close();
    await pointersBox.close();
    return dayRecordings;
  }

  Future<void> checkAndInitPointersBox() async {
    final pointersBox = await Hive.openBox<RecordPointers>("PointersBox");
    if (pointersBox.get('pointers') == null) {
      pointersBox.put('pointers', RecordPointers([]));
    }
  }

  Future<void> deleteSavedData() async {
    if (await Hive.boxExists("PointersBox")) {
      await Hive.deleteBoxFromDisk("PointersBox");
    }
    if (await Hive.boxExists("Recordings")) {
      await Hive.deleteBoxFromDisk("Recordings");
    }
  }
}

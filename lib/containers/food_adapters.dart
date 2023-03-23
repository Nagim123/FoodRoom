import 'package:food_ai/containers/food_recording.dart';
import 'package:hive/hive.dart';

class FoodRecordAdapter extends TypeAdapter<FoodRecord> {
  @override
  FoodRecord read(BinaryReader reader) {
    return FoodRecord.create(
        reader.readString(),
        reader.readDouble(),
        reader.readDouble(),
        reader.readDouble(),
        reader.readDouble(),
        reader.readDouble());
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, FoodRecord obj) {
    writer.writeString(obj.foodName);
    writer.writeDouble(obj.calories);
    writer.writeDouble(obj.proteins);
    writer.writeDouble(obj.fats);
    writer.writeDouble(obj.carbohydrates);
    writer.writeDouble(obj.mass);
  }
}

class RecordClusterAdapter extends TypeAdapter<RecordCluster> {
  @override
  RecordCluster read(BinaryReader reader) {
    int listSize = reader.readInt32();
    List<FoodRecord> records = [];

    FoodRecordAdapter foodRecordAdapter = FoodRecordAdapter();
    for (int i = 0; i < listSize; i++) {
      records.add(foodRecordAdapter.read(reader));
    }

    return RecordCluster(records);
  }

  @override
  int get typeId => 2;

  @override
  void write(BinaryWriter writer, RecordCluster obj) {
    List<FoodRecord> records = obj.getAllRecords();
    writer.writeInt32(records.length);
    FoodRecordAdapter foodRecordAdapter = FoodRecordAdapter();
    for (int i = 0; i < records.length; i++) {
      foodRecordAdapter.write(writer, records[i]);
    }
  }
}

class DayRecordingAdapter extends TypeAdapter<DayRecording> {
  @override
  DayRecording read(BinaryReader reader) {
    RecordClusterAdapter recordClusterAdapter = RecordClusterAdapter();

    return DayRecording(
        recordClusterAdapter.read(reader),
        recordClusterAdapter.read(reader),
        recordClusterAdapter.read(reader),
        DateTime(reader.readInt32(), reader.readInt32(), reader.readInt32()));
  }

  @override
  int get typeId => 3;

  @override
  void write(BinaryWriter writer, DayRecording obj) {
    RecordClusterAdapter recordClusterAdapter = RecordClusterAdapter();
    recordClusterAdapter.write(writer, obj.breakfast);
    recordClusterAdapter.write(writer, obj.lunch);
    recordClusterAdapter.write(writer, obj.dinner);
    writer.writeInt32(obj.dayDate.year);
    writer.writeInt32(obj.dayDate.month);
    writer.writeInt32(obj.dayDate.day);
  }
}

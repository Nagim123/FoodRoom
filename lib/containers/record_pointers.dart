import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class RecordPointers {
  @HiveField(0)
  final List<String> recordPointers;

  RecordPointers(this.recordPointers);
}

class RecordPointersAdapter extends TypeAdapter<RecordPointers> {
  @override
  RecordPointers read(BinaryReader reader) {
    int n = reader.readInt32();
    List<String> result = [];
    for (int i = 0; i < n; i++) {
      result.add(reader.readString());
    }
    return RecordPointers(result);
  }

  @override
  int get typeId => 4;

  @override
  void write(BinaryWriter writer, RecordPointers obj) {
    writer.writeInt32(obj.recordPointers.length);
    for (int i = 0; i < obj.recordPointers.length; i++) {
      writer.writeString(obj.recordPointers[i]);
    }
  }
}

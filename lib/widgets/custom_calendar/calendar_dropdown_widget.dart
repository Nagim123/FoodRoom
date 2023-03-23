import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CalendarDropDown extends StatefulWidget {
  const CalendarDropDown(
      {super.key,
      required this.list,
      required this.onChanged,
      required this.initialValue});
  final List<String> list;
  final Function(String) onChanged;
  final String initialValue;

  @override
  State<CalendarDropDown> createState() => _CalendarDropDown();
}

class _CalendarDropDown extends State<CalendarDropDown> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: dropdownValue,
        isExpanded: true,
        customButton: Container(
          margin: const EdgeInsets.only(top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dropdownValue,
                style: const TextStyle(fontSize: 14),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
                size: 20,
              ),
            ],
          ),
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 250,
        ),
        onChanged: (String? value) {
          widget.onChanged.call(value!);
          setState(() {
            dropdownValue = value;
          });
        },
        items: widget.list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                )),
          );
        }).toList(),
      ),
    );
  }
}

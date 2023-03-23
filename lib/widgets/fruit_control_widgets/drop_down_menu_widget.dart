import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class DropDownMenu extends StatefulWidget {
  const DropDownMenu(
      {super.key,
      required this.list,
      required this.onChanged,
      required this.initialValue});
  final List<String> list;
  final Function(String) onChanged;
  final String initialValue;

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: const Text(
              'Ваш продукт',
              style: TextStyle(color: Colors.white),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: dropdownValue,
              isExpanded: true,
              alignment: Alignment.topCenter,
              customButton: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        dropdownValue,
                        style:
                            const TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 7),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 150,
                decoration: BoxDecoration(
                  color: Color.fromARGB(200, 0, 0, 0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
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
                        style: const TextStyle(color: Colors.white),
                      )),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/decimal_text_input_formatter.dart';

class FruitMassInputWidget extends StatelessWidget {
  const FruitMassInputWidget(
      {super.key,
      required this.initialValue,
      required this.onChanged,
      this.disableEdit = false});

  final String initialValue;
  final Function(String) onChanged;
  final bool disableEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
              'Масса',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 90,
            height: 25,
            child: TextFormField(
              enabled: !disableEdit,
              initialValue: initialValue,
              onChanged: (inputText) => onChanged.call(inputText),
              inputFormatters: <TextInputFormatter>[
                DecimalTextInputFormatter(decimalRange: 2)
              ],
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 12, left: 10),
                suffix: Text(
                  'г',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
              ),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: "Saira",
                  fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AimWidget extends StatelessWidget {
  final aimColor = const Color.fromARGB(255, 0, 0, 0);

  const AimWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 30,
        height: 80,
        //color: Colors.red,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                color: aimColor,
                height: 4,
                width: 30,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: aimColor,
                height: 38,
                width: 4,
              ),
            ),
          ],
        ));
  }
}

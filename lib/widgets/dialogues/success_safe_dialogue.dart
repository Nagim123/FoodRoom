import 'package:flutter/material.dart';

Future<void> showSuccessSafe(BuildContext context) async {
  Dialog fancyDialog = Dialog(
    backgroundColor: Colors.transparent,
    alignment: Alignment.center,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: MediaQuery.of(context).size.height * 0.15,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const Center(
            child: Text(
              "Продукт сохранен",
              style: TextStyle(fontSize: 21, color: Colors.white),
            ),
          ),
          Align(
            // These values are based on trial & error method
            alignment: const Alignment(0.88, -0.75),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
  showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => fancyDialog);
}

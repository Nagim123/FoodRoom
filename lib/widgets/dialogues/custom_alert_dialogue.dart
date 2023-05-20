import 'package:flutter/material.dart';

Future<void> showCustomAlert(BuildContext context, String alertText) async {
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
          Container(
            alignment: Alignment.bottomCenter,
            padding:
                const EdgeInsets.only(top: 0, bottom: 15, left: 15, right: 15),
            child: Text(
              alertText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          Align(
            // These values are based on trial & error method
            alignment: const Alignment(0.88, -0.75),
            child: InkWell(
              onTap: () {
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
      barrierColor: const Color.fromARGB(100, 0, 0, 0),
      builder: (BuildContext context) => fancyDialog);
}

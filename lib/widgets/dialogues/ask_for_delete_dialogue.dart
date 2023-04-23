import 'package:flutter/material.dart';

Future<void> showDeleteQuestion(
    BuildContext context,
    String textDialog,
    VoidCallback exitCallback,
    VoidCallback cancelCallback,
    VoidCallback onPopped) async {
  Dialog fancyDialog = Dialog(
    alignment: Alignment.center,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: MediaQuery.of(context).size.height * 0.2,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                textDialog,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 21, color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: IconButton(
                      iconSize: 30,
                      color: Colors.white,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                        cancelCallback.call();
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: IconButton(
                      iconSize: 30,
                      color: Colors.white,
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        exitCallback.call();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
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
          builder: (BuildContext context) => fancyDialog)
      .then((value) => onPopped.call());
}

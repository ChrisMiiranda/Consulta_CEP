import 'package:flutter/material.dart';

alertOK(BuildContext context, String msg) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                content: Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                actions: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: MaterialButton(
                        child: const Text('OK',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            )),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  )
                ]));
      });
}

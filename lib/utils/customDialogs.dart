import 'package:flutter/material.dart';
class CustomDialogs {
  static void alertDialog(
      {@required BuildContext context,
      @required String title,
      @required String message}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  static void progressDialog(
      {@required BuildContext context, @required String message}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(2.0),
                        child: CircularProgressIndicator()),
                    SizedBox(width: 10.0),
                    Text(
                      message,
                    )
                  ],
                )),
          );
        });
  }
}

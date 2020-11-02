import 'package:flutter/material.dart';

class ErrorAlert extends StatelessWidget {
  final String errorTitle;
  final String errorMessage;

  ErrorAlert(this.errorTitle, this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        (this.errorTitle == null || this.errorTitle.isEmpty) ? 'Unknown Error' : this.errorTitle,
      ),

      content: Text(
        this.errorMessage,
      ),

      actions: [
        RaisedButton(
          child: Text(
            'Close',
          ),

          color: Colors.blueAccent,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

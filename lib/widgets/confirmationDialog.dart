import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm'),
      content: Text('Do you wish to use this ticket?'),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel')),
        FlatButton(
          child: Text('Ok'),
          onPressed: () => Navigator.pop(context, true),
        )
      ],
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry({this.title, this.isChecked: false, this.description, this.id});
  String title;
  String description;
  bool isChecked;
  String id;
}

class ActivityIndicatorMixin {
  BuildContext _context;

  void showIndicator(context) {
    _context = context;
    new Future.delayed(new Duration(seconds: 0), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new Center(
            child: new CircularProgressIndicator(),
          );
        },
      );
    });
  }

  void onLodingCompleted() {
    Navigator.pop(_context); //pop dialog
  }
}

/// CTSE Final Flutter Project - Suzuki Automobile
///
/// This file contains the loading screen which increases the usability of the
/// application.
///
/// @Author : IT17009096 | Wellala S.S.

import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
        width: 200,
        height: 100,
        child: Center(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/loading.gif"),
            ],
          ),
        ),
      ),
    );
  }
}

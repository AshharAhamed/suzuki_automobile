/// CTSE Final Flutter Project - Suzuki Automobile
///
/// This [CarDetailHeader] is created in order to create the stack of the main image when the image
/// is loaded with the Downloadable URL from the Firebase Storage.
///
/// @Author : IT17009096 | Wellala S.S.

import 'package:flutter/material.dart';
import 'MainArcImage.dart';

class CarDetailHeader extends StatelessWidget {
  // Holds the car model name
  final String car;

  CarDetailHeader(this.car);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainArcImage(car),
      ],
    );
  }
}

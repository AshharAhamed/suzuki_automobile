/// CTSE Final Flutter Project - Suzuki Automobile
///
/// This file will load the Arc Image from the File selected from the Gallery.
///
/// @Author : IT17009096 | Wellala S.S.

import 'package:flutter/material.dart';
import 'package:suzukiautomobile/widgets/MainArcFileImage.dart';
import 'dart:io';

class CarDetailFileHeader extends StatelessWidget {
  final File imagePath;

  CarDetailFileHeader(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainArcFileImage(imagePath),
      ],
    );
  }
}

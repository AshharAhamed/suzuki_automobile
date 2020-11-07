/// CTSE Final Flutter Project - Suzuki Automobile
///
/// This file was created in order to show arc image from a File from the gallery.
///
/// @Author : IT17009096 | Wellala S.S.

import 'package:flutter/material.dart';
import 'dart:io';

import 'MainArcImage.dart';

class MainArcFileImage extends StatelessWidget {
  // Holds the file reference from the gallery.
  final File image;

  MainArcFileImage(this.image);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return ClipPath(
      clipper: ArcClipper(),
      child: Image.file(image,
          width: screenWidth, height: 230.0, fit: BoxFit.cover),
    );
  }
}

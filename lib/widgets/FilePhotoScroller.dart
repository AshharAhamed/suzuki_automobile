/// CTSE Final Flutter Project - Suzuki Automobile
///
/// This is created to make a horizontal scroll view of the photographs from the
/// Gallery.
///
/// @Author : IT17009096 | Wellala S.S.

import 'package:flutter/material.dart';
import 'dart:io';

class FilePhotoScroller extends StatelessWidget {
  final List<File> photoList;

  FilePhotoScroller(this.photoList);

  Widget _buildPhoto(BuildContext context, int index) {
    var photo = photoList[index];

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Image.file(
          photo,
          width: 160.0,
          height: 120.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox.fromSize(
          size: const Size.fromHeight(100.0),
          child: ListView.builder(
            itemCount: photoList.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 8.0, left: 20.0),
            itemBuilder: _buildPhoto,
          ),
        ),
      ],
    );
  }
}

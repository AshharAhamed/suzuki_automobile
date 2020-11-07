/// CTSE Final Flutter Project - Suzuki Automobile
///
/// This [Description.dart] contains the description widget which is build to show case the long
/// description of the car model.
///
/// @Author : IT17009096 | Wellala S.S.

import 'package:flutter/material.dart';

class Description extends StatefulWidget {
  final String description;

  Description(this.description);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: textTheme.subhead.copyWith(fontSize: 18.0),
        ),
        SizedBox(height: 8.0),
        Text(
          widget.description,
          style: textTheme.body1.copyWith(
            color: Colors.black45,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}

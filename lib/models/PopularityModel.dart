/// CTSE Final Flutter Project - Suzuki Automobile
///
/// This model class holds the information needed for the chart.
///
/// @Author : IT17009096 | Wellala S.S.

import 'package:flutter/material.dart';

class PopularityModel {
  String model; // Car model name
  double value; // Model Popularity value
  Color colorVal; // Colour for the chart

  // Constructor
  PopularityModel(this.model, this.value, this.colorVal);
}

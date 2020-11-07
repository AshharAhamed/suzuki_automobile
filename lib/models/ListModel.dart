/// CTSE Final Flutter Project - Suzuki Automobile
///
/// [ListModel] is the model class of a ListItem that is used in the application.
/// This defines the attributes which are there in a list item.
///
/// @Author : IT17009096 | Wellala S.S.

import 'package:cloud_firestore/cloud_firestore.dart';

class ListModel {
  String model;
  String description;
  String image;
  List<String> gallery;
  DocumentReference reference;

  /// Constructor
  ListModel(this.model, this.description, this.image, this.gallery);

  /// Method to initialize the class variables from Firebase
  ListModel.fromMap(Map<dynamic, dynamic> map, {this.reference}) {
    model = map["model"];
    description = map["description"];
    image = map["image"];
    var parsedGallery = map["gallery"];
    gallery = new List<String>.from(parsedGallery);
  }

  /// Method to initialize from the [snapshot]
  ListModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  /// Method used to convert class attributes to JSON format
  toJson() {
    return {
      'model': model,
      'description': description,
      'image': image,
      'gallery': gallery
    };
  }
}

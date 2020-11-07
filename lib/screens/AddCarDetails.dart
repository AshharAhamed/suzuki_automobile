/*
 AddCarDetails.dart is a screen which facilitates the user to add details 
 of the cars to the system.
 */

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:suzukiautomobile/api/ItemService.dart';
import 'package:suzukiautomobile/models/ListModel.dart';
import 'package:suzukiautomobile/widgets/FilePhotoScroller.dart';
import 'package:suzukiautomobile/widgets/LoadingDialog.dart';

import '../widgets/BaseAppBar.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCarDetails extends StatefulWidget {
  @override
  _AddCarDetailsState createState() => _AddCarDetailsState();
}

class _AddCarDetailsState extends State<AddCarDetails> {
  // To hold the main image reference
  File _image;

  // To hold the sub images
  List<File> _subImgList = List();
  final _formKey = GlobalKey<FormState>();

  //Input Controllers
  final modelInputController = TextEditingController();
  final descriptionInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /// This method is to get the main image
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print("image Path: $_image");
      });
    }

    /// This method is to get the sub images
    Future getSubImages() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _subImgList.add(image);
        print("image Path: $_image");
      });
    }

    /// Function to handle loading
    _loading(context) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return LoadingDialog();
          });
    }

    /// Function to clear fields after adding a record
    clearFields() {
      modelInputController.clear();
      descriptionInputController.clear();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _image = null;
      _subImgList.clear();
    }

    // Upload all details
    Future uploadDetails(BuildContext context) async {
      _loading(context);

      // Temp variables to hold the required fields
      String model = modelInputController.text;
      String description = descriptionInputController.text;
      String image = "";
      List<String> subImages = List();

      //Uploading Main Image
      image = await ItemService.uploadImage(_image, model);

      //Uploading Sub Images
      if (_subImgList.length > 0) {
        for (File img in _subImgList) {
          String tempImage = await ItemService.uploadImage(img, model);
          subImages.add(tempImage);
        }
      }
      // Creating the new ListModel object
      ListModel listItem = ListModel(model, description, image, subImages);
      // Adding the newly created item to the Firebase
      ItemService.addListItem(listItem);

      // Showing the SnackBar with the successfully completion message
      Navigator.of(context).pop();
      clearFields();
      setState(() {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Details added successfully !'),
        ));
      });
    }

    var textTheme = Theme.of(context).hintColor;
    // Here contains all the elements that are used in the screen
    return Scaffold(
      appBar: BaseAppBar(
        title: Text('Manage Cars'),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add_photo_alternate,
                            color: textTheme,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Select main image',
                              style:
                                  TextStyle(color: textTheme, fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: IconButton(
                          icon: (_image != null)
                              ? Image.file(
                                  _image,
                                )
                              : Image.asset("assets/images/add_image.png"),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add_to_photos,
                            color: textTheme,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Select Sub images',
                              style:
                                  TextStyle(color: textTheme, fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _subImgList.length > 0
                        ? FilePhotoScroller(_subImgList)
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: IconButton(
                          icon: Image.asset("assets/images/add_image.png"),
                          onPressed: () {
                            getSubImages();
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: modelInputController,
                        decoration: InputDecoration(
                            labelText: 'Enter car model',
                            icon: Icon(Icons.directions_car)),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter car model';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: descriptionInputController,
                        decoration: InputDecoration(
                          labelText: 'Enter description',
                          icon: Icon(Icons.description),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter car description';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Container(
                        height: 40.0,
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              uploadDetails(context);
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFEF7A85),
                                    Color(0xFFFFC2E2)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 320.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Add details",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])),
            ),
          ),
        ),
      ),
    );
  }
}

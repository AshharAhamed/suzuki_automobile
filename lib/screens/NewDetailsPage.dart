/// CTSE Final Flutter Project - Suzuki Automobile
///
/// This [NewDetailsPage] file contains the details screen. when a user taps on a item from the
/// main screen, the more details are appearing with relevant to that specific car model
///
/// @Author : IT17009096 | Wellala S.S.

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:suzukiautomobile/api/ItemService.dart';
import 'package:suzukiautomobile/models/ListModel.dart';
import 'package:suzukiautomobile/widgets/BaseAppBar.dart';
import 'package:suzukiautomobile/widgets/CarDetailFileHeader.dart';
import 'package:suzukiautomobile/widgets/CarDetailHeader.dart';
import 'package:suzukiautomobile/widgets/Description.dart';
import 'package:suzukiautomobile/widgets/FilePhotoScroller.dart';
import 'package:suzukiautomobile/widgets/LoadingDialog.dart';
import 'package:suzukiautomobile/widgets/PhotoScroller.dart';
import 'package:image_picker/image_picker.dart';

class NewDetailsPage extends StatefulWidget {
  final DocumentSnapshot post;

  NewDetailsPage({this.post});

  @override
  _NewDetailsPageState createState() => _NewDetailsPageState();
}

class _NewDetailsPageState extends State<NewDetailsPage> {
  // Local variables to hold information temporarily
  // Holds is editing state
  bool isEditing = false;
  File _tempMainImage;
  List<File> _tempSubImageList = new List();
  ListModel item;
  TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // This method calls when user tap on the edit action button.
  handleEditAction() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  // This method calls when user taps on the delete action button.
  handleDelete(context) {
    _showDeleteDialog(context);
  }

  // This will how dialog menu which advice on whether to delete the item or not
  Future _showDeleteDialog(context) {
    // flutter defined function
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete Item ?"),
          content: new Text("This will delete the car details from the sytem."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("Delete"),
              onPressed: () async {
                Navigator.of(context).pop();
                _loading(context);
                await deleteItem(context);
                Navigator.of(context).pop();
                _scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text("Item Deleted Successfully !")));
              },
            ),
            FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// This method will be called when the item is begin deleted. This will call
  /// the deleteItem function from the ItemService.
  Future deleteItem(context) async {
    await ItemService.deleteItem(item);
  }

  /// This method is to get the main image when updating
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _tempMainImage = image;
      print("image Path: $_tempMainImage");
    });
  }

  /// This method is to get the sub images
  Future getSubImages() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _tempSubImageList.add(image);
      print("image Path: $image");
    });
  }

  @override
  void initState() {
    super.initState();
    item = ListModel.fromSnapshot(widget.post);
    _descriptionController.text = item.description;
  }

  /// Function to handle loading
  Future _loading(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog();
        });
  }

  /// This function is calls when update button clicked
  Future updateDetails(context) async {
    //Getting the current value from the description Controller.
    String newDescription = _descriptionController.text;
    String newImage = "";
    List<String> newSubImages = List();

    // To be more user friendly this will show case a loading screen while
    // detail updating process is over.
    _loading(context);

    // Getting the current snapshot from Firebase and converting it to a model.
    ListModel tempModel = ListModel.fromSnapshot(widget.post);

    // Making sure that the user has selected a new main image for editing.
    if (_tempMainImage != null) {
      // First need to remove the existing images from the storage. This will
      // optimize the Firebase Storage usage.
      await ItemService.deleteImage(tempModel.image);

      //Uploading the new main Image
      newImage = await ItemService.uploadImage(_tempMainImage, item.model);
      item.image = newImage;
    }
    //Setting the new Values
    if (newDescription != null && newDescription != "") {
      item.description = newDescription;
    }

    // Making sure that the user has selected the sub images.
    if (_tempSubImageList.length > 0) {
      // Deleting the old Sub Images. This will optimize the Firebase storage usage.
      for (String img in tempModel.gallery) {
        await ItemService.deleteImage(img);
      }
      //Uploading the new Gallery Images
      for (File img in _tempSubImageList) {
        String temp = await ItemService.uploadImage(img, item.model);
        newSubImages.add(temp);
      }
      item.gallery = newSubImages;
    }

    // Finally updating the item details
    await ItemService.editItem(item);
    Navigator.of(context).pop();
    setState(() {
      isEditing = false;
    });
    // After the editing completes, user will be notified with a Snack Bar showing
    // that the process is successful.
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text("Details Updated Successfully !")));
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      key: _scaffoldKey,
      appBar: BaseAppBar(
        title: Text(item.model),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                handleEditAction();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                handleDelete(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            this.isEditing
                ? _tempMainImage != null
                    ? Stack(
                        children: <Widget>[
                          CarDetailFileHeader(_tempMainImage),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                color: Colors.white,
                                width: 80,
                                height: 80,
                                child: IconButton(
                                  icon: Image.asset(
                                      "assets/images/edit_photo.png"),
                                  onPressed: () {
                                    getImage();
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : Stack(
                        children: <Widget>[
                          CarDetailHeader(item.image),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                color: Colors.white,
                                width: 80,
                                height: 80,
                                child: IconButton(
                                  icon: Image.asset(
                                      "assets/images/edit_photo.png"),
                                  onPressed: () {
                                    getImage();
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                : CarDetailHeader(item.image),
            isEditing
                ? Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                          child: Text(
                            'Description',
                            style: textTheme.subhead.copyWith(fontSize: 18.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _descriptionController,
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Description(item.description),
                  ),
            isEditing
                ? item.gallery != null
                    ? _tempSubImageList.length > 0
                        ? Stack(
                            children: <Widget>[
                              FilePhotoScroller(_tempSubImageList),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    color: Colors.white,
                                    width: 50,
                                    height: 50,
                                    child: IconButton(
                                      icon: Image.asset(
                                          "assets/images/edit_photo.png"),
                                      onPressed: () {
                                        getSubImages();
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Stack(
                            children: <Widget>[
                              PhotoScroller(List.from(item.gallery)),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    color: Colors.white,
                                    width: 50,
                                    height: 50,
                                    child: IconButton(
                                      icon: Image.asset(
                                          "assets/images/edit_photo.png"),
                                      onPressed: () {
                                        getSubImages();
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                    : Container()
                : item.gallery != null
                    ? PhotoScroller(List.from(item.gallery))
                    : Container(),
            SizedBox(height: 20.0),
            isEditing
                ? Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      height: 40.0,
                      child: RaisedButton(
                        onPressed: () {
                          updateDetails(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFEF7A85), Color(0xFFFFC2E2)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 320.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Update Details",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            //ActorScroller(movie.actors),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}

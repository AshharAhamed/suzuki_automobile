/**
 * CTSE Final Flutter Project - Suzuki Automobile
 *
 * [ItemService.dart] file contains all the service methods used in the application.
 * This class deals with FirebaseStorage when accessing data
 *
 * @Author : IT17009096 | Wellala S.S.
 *
 */

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:suzukiautomobile/configs/Constants.dart';
import 'package:suzukiautomobile/models/ListModel.dart';

class ItemService {
  /// This method will upload the File at [image] to the Firebase Storage by
  /// creating a separate folder with name [model].
  /// After uploading the image this function will return the `imageDownloadURL`
  /// which can be used to access the uploaded image.
  static Future uploadImage(File image, String model) async {
    String imageDownloadURL = "";
    String fileName = basename(image.path);

    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child(STORAGE_FOLDER)
        .child(model)
        .child(fileName);
    StorageUploadTask uploadTask = reference.putFile(image);

    imageDownloadURL = await (await uploadTask.onComplete).ref.getDownloadURL();
    return imageDownloadURL;
  }

  /// This will delete the image in the given [imgUrl] from Firebase Storage
  static Future deleteImage(String imgUrl) async {
    StorageReference photoRef =
        await FirebaseStorage.instance.getReferenceFromUrl(imgUrl);
    photoRef.delete().then((onSuccess) => {print('File Deleted ')});
  }

  static Future getPosts() async {
    var fireStore = Firestore.instance;
    QuerySnapshot querySnapshot =
        await fireStore.collection(COLLECTION_NAME).getDocuments();
    return querySnapshot.documents;
  }

  /// This method will add the [listItem] to the Firebase Database collection
  static addListItem(ListModel listItem) {
    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        await Firestore.instance
            .collection(COLLECTION_NAME)
            .document()
            .setData(listItem.toJson());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  /// This method updates the details of the [item]
  static editItem(ListModel item) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(item.reference, item.toJson());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  /// This method deletes the [item] from Firebase Storage and Firebase Database
  static deleteItem(ListModel item) async {
    await deleteImage(item.image);
    for (String imgUrl in item.gallery) {
      await deleteImage(imgUrl);
    }
    Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.delete(item.reference);
    });
  }
}

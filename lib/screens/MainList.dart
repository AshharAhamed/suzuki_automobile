/// CTSE Final Flutter Project - Suzuki Automobile
///
/// MainList.dart file contains main screen which contains a list of the car models
/// with the model, a short description and an image.
///
/// @Author : IT17009096 | Wellala S.S.

import 'dart:math';
import 'package:suzukiautomobile/api/ItemService.dart';
import 'package:suzukiautomobile/configs/Constants.dart' as Constants;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suzukiautomobile/screens/NewDetailsPage.dart';
import 'package:suzukiautomobile/widgets/MainListItem.dart';

class AutomobileList extends StatefulWidget {
  @override
  _AutomobileListState createState() => _AutomobileListState();
}

class _AutomobileListState extends State<AutomobileList> {
  navigateToDetails(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewDetailsPage(
                  post: post,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FutureBuilder(
            future: ItemService.getPosts(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Image.asset("assets/images/loading.gif"),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0.0),
                  scrollDirection: Axis.vertical,
                  primary: true,
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () => navigateToDetails(snapshot.data[index]),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MainListItem(
                            image: snapshot.data[index].data["image"],
                            title: snapshot.data[index].data["model"],
                            color: Constants.COLORS[new Random().nextInt(5)],
                            content: snapshot.data[index].data["description"],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
      ],
    );
  }
}

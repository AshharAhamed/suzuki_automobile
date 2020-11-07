/// CTSE Final Flutter Project - Suzuki Automobile
///
/// This file contains the the structure of a one main list item in the main page.
///
/// @Author : IT17009096 | Wellala S.S.

import 'package:flutter/material.dart';

class MainListItem extends StatefulWidget {
  final String title;
  final String content;
  final Color color;
  final String image;

  const MainListItem(
      {Key key, this.title, this.content, this.color, this.image})
      : super(key: key);

  @override
  _MainListItemState createState() => _MainListItemState();
}

class _MainListItemState extends State<MainListItem> {
  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Container(width: 10.0, height: 190.0, color: widget.color),
        new Expanded(
          child: new Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: new Text(
                    widget.content,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        new Container(
          height: 150.0,
          width: 150.0,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              new Transform.translate(
                offset: new Offset(50.0, 0.0),
                child: new Container(
                  height: 100.0,
                  width: 100.0,
                  color: widget.color,
                ),
              ),
              new Transform.translate(
                offset: Offset(10.0, 20.0),
                child: new Card(
                  elevation: 20.0,
                  child: new Container(
                    height: 120.0,
                    width: 120.0,
                    child: Image.network(
                      widget.image,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Image.asset("assets/images/loading.gif"),
                        );
                      },
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 10.0,
                          color: Colors.white,
                          style: BorderStyle.solid),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// CTSE Final Flutter Project - Suzuki Automobile
///
/// [BaseAppBar] widget was created in order to maintain a uniform
/// AppBar through out the application. This makes it easier to do the changes
/// when necessary in one place.
///
/// @Author : IT17009096 | Wellala S.S.

import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final AppBar appBar;

  const BaseAppBar({Key key, this.title, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: appBar.actions,
      elevation: 6,
      backgroundColor: Color(0xFFEF7A85),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

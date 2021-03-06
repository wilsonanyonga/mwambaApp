import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mwamba_app/constants.dart';

import 'components/body.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: kPrimaryColor,
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: Text('Mwamba Building Plans'),
      // actions: <Widget>[
      //   IconButton(
      //     icon: SvgPicture.asset("assets/icons/notification.svg"),
      //     onPressed: () {},
      //   ),
      // ],
    );
  }
}

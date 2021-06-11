import 'package:flutter/cupertino.dart';
import 'package:mwamba_app/constants.dart';
import 'package:provider/provider.dart';

class MobileMoney extends StatefulWidget {
  @override
  _MobileState createState() => _MobileState();
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   throw UnimplementedError();
  // }

}

class _MobileState extends State<MobileMoney> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    return Container(
      margin: EdgeInsets.all(kDefaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFFCBF1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text("Click to Buy Plan (PDF) - Ksh 700"),
      ),
      // child: Row(
      //   children: <Widget>[
      //     SvgPicture.asset(
      //       "assets/icons/chat.svg",
      //       height: 18,
      //     ),
      //     SizedBox(width: kDefaultPadding / 2),
      //     Text(
      //       "Chat",
      //       style: TextStyle(color: Colors.white),
      //     ),
      //     // it will cover all available spaces
      //     Spacer(),
      //     FlatButton.icon(
      //       onPressed: () {},
      //       icon: SvgPicture.asset(
      //         "assets/icons/shopping-bag.svg",
      //         height: 18,
      //       ),
      //       label: Text(
      //         "Add to Cart",
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

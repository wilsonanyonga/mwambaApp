import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniture_app/components/search_box.dart';
import 'package:furniture_app/constants.dart';
import 'package:furniture_app/models/HomeModel.dart';
import 'package:furniture_app/models/product.dart';
import 'package:furniture_app/requests/HomeReq.dart';
import 'package:furniture_app/screens/details/details_screen.dart';

// for pull down to refresh
// import 'package:pull_to_refresh/pull_to_refresh.dart';


// import 'category_list.dart';
import 'product_card.dart';

class Body extends StatefulWidget {
  @override
  _MyBodyState createState() => _MyBodyState();
}
class _MyBodyState extends State<Body> {

  List<Result> resultsMod;
  List<Result> searchMod = [];

  TextEditingController _controllerSearch = TextEditingController();

  // ------------for refreshing the page--------------------------------

  // RefreshController _refreshController = RefreshController(initialRefresh: false);

  // void _onRefresh() async{
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use refreshFailed()
  //   _refreshController.refreshCompleted();
  // }

  // void _onLoading() async{
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   // items.add((items.length+1).toString());
  //   if(mounted)
  //   setState(() {

  //   });
  //   _refreshController.loadComplete();
  // }
  
  // -------------refresh end---------------------------------------


  onSearchTextChanged(String text) async {
    searchMod.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    resultsMod.forEach((userDetail) {
      if (userDetail.name.contains(text) || userDetail.description.contains(text))
        searchMod.add(userDetail);
    });

    setState(() {});
  }
  @override
  initState() {
    // TODO: implement initState
    HomeReq().homeReq().then((following) {
      // final result = json.decode(following.body)['trucks'];
      print(following.body);
      // // print(result['trucks']);
      // Iterable list = result;
      Iterable list = jsonDecode(following.body)['result'];
      // print(list);
      setState(() {
        print(list);
        // HomeModel users = HomeModel.fromJson(json.decode(following.body));
        resultsMod = list.map((model) => Result.fromJson(model)).toList();
        // users = list;
        print(resultsMod.length);
      });
    });
    super.initState();
  }

  void fetchUsers() async {
    HomeReq().homeReq().then((following) {
      // final result = json.decode(following.body)['trucks'];
      print(following.body);
      // // print(result['trucks']);
      // Iterable list = result;
      Iterable list = jsonDecode(following.body)['result'];
      // print(list);
      setState(() {
        print(list);
        // HomeModel users = HomeModel.fromJson(json.decode(following.body));
        resultsMod = list.map((model) => Result.fromJson(model)).toList();
        // users = list;
        print(resultsMod.length);
      });
    });
  }

  Future<void> _getData() async {
    setState(() {
      fetchUsers();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          // SearchBox(onChanged: (value) {}),
          Container(
            margin: EdgeInsets.all(kDefaultPadding),
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 4, // 5 top and bottom
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              
            ),
            
            child: TextField(
              controller: _controllerSearch,
              onChanged: onSearchTextChanged,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                icon: SvgPicture.asset("assets/icons/search.svg"),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            
            
          ),
          // CategoryList(),
          SizedBox(height: kDefaultPadding / 2),
          Expanded(
            child: Stack(
              children: <Widget>[
                // Our background
                Container(
                  margin: EdgeInsets.only(top: 70),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                RefreshIndicator(
                  child: searchMod.length != 0 || _controllerSearch.text.isNotEmpty ? Container(
                  child: searchMod != null ? ListView.builder(
                    // here we use our demo procuts list
                    itemCount: searchMod.length,
                    itemBuilder: (context, i) => ProductCard(
                      itemIndex: i,
                      product: searchMod[i],
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(
                              product: searchMod[i],
                            ),
                          ),
                        );
                      },
                    ),
                  ): Container(child: Align(child: Text('Data is loading ...'))),
                ) : Container(
                  child: resultsMod != null ? ListView.builder(
                    // here we use our demo procuts list
                    itemCount: resultsMod.length,
                    itemBuilder: (context, index) => ProductCard(
                      itemIndex: index,
                      product: resultsMod[index],
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(
                              product: resultsMod[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ): Container(child: Align(child: Text('Data is loading ...'))),
                ), 
                  onRefresh: _getData
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}

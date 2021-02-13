import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductPoster extends StatelessWidget {
  const ProductPoster({
    Key key,
    @required this.size,
    this.image,
  }) : super(key: key);

  final Size size;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
      // the height of this container is 80% of our width
      height: size.width * 0.8,

      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            height: size.width * 0.7,
            width: size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          // CachedNetworkImage(

          //     imageUrl: "https://mwambaapp.mwambabuilders.com/mwambaApp/api/uploads/$image",

          //     placeholder: (context, url) => CircularProgressIndicator(),
          //     errorWidget: (context, url, error) => Icon(Icons.error),
          // ),
          Image(

            image: NetworkImage("https://mwambaapp.mwambabuilders.com/mwambaApp/api/uploads/$image"),

            fit: BoxFit.cover,
            height: size.width * 0.75,
            width: size.width * 0.75,),
          // Image.asset(
          //   image,
          //   height: size.width * 0.75,
          //   width: size.width * 0.75,
          //   fit: BoxFit.cover,
          // ),
        ],
      ),
    );
  }
}

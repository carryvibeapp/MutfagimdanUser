import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProductShimmer extends StatelessWidget {
  final bool isEnabled;
  ProductShimmer({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(
          color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
          blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
          spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
        )],
      ),
      child: Shimmer(
        duration: Duration(seconds: 2),
        enabled: isEnabled,
        child: Row(children: [
          Container(
            height: 70, width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(height: 15, width: double.maxFinite, color: Colors.grey[300]),
            SizedBox(height: 5),
            RatingBar(rating: 0.0, size: 12),
            SizedBox(height: 10),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ])),
          SizedBox(width: 10),

          Column(children: [
            Icon(Icons.favorite_border, color: Colors.grey),
            Expanded(child: SizedBox()),
            Icon(Icons.add, color: ColorResources.COLOR_BLACK),
          ]),

        ]),
      ),
    );
  }
}

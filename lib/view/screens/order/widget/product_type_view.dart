import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class ProductTypeView extends StatelessWidget {
  final productType;
  const ProductTypeView({Key key, this.productType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return productType == null ? SizedBox() : Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
        color: Theme.of(context).primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0 ,vertical: 2),
        child: Text(getTranslated(productType, context,
        ), style: robotoRegular.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
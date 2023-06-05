import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';
class AddButtonView extends StatelessWidget {
  final Function onTap;
  const AddButtonView({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: OnHover(
        builder: (onHover) {
          return InkWell(
            onTap: onTap,
            hoverColor: Colors.transparent,
            child: Container(
              width: 110.0,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(30.0)),
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Row(
                children: [
                  Icon(Icons.add_circle, color: ColorResources.COLOR_WHITE),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Text(getTranslated('add_new', context), style: rubikRegular.copyWith(color: ColorResources.COLOR_WHITE))
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
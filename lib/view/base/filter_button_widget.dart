import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';


class FilterButtonWidget extends StatelessWidget {
  final String type;
  final List<String> items;
  final bool isBorder;
  final bool isSmall;
  final Function(String value) onSelected;

  FilterButtonWidget({
    @required this.type, @required this.onSelected, @required this.items,  this.isBorder = false, this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool _ltr = Provider.of<LocalizationProvider>(context) .isLtr;
    bool _isVegFilter = Provider.of<ProductProvider>(context).productTypeList == items;

    return  Align(alignment: Alignment.center, child: Container(
      height: ResponsiveHelper.isMobile(context) ? 35 : 40,
      margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
      decoration: isBorder ? null : BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => onSelected(items[index]),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              margin: isBorder ? EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL) : EdgeInsets.zero,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: isBorder ? BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)) : BorderRadius.horizontal(
                  left: Radius.circular(
                    _ltr ? index == 0 && items[index] != type ? Dimensions.RADIUS_SMALL : 0
                        : index == items.length-1
                        ? Dimensions.RADIUS_SMALL : 0,
                  ),
                  right: Radius.circular(
                    _ltr ? index == items.length-1 &&  items[index] != type
                        ? Dimensions.RADIUS_SMALL : 0 : index == 0
                        ? Dimensions.RADIUS_SMALL : 0,
                  ),
                ),
                color: items[index] == type ? Theme.of(context).primaryColor
                    : Theme.of(context).canvasColor,

              border: isBorder ?  Border.all(width: 1.3, color: Theme.of(context).primaryColor.withOpacity(0.4)) : null ,
              ),
              child: Row(
                children: [
                  items[index] != items[0] && _isVegFilter ? Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Image.asset(
                      Images.getImageUrl(items[index]),
                    ),
                  ) : SizedBox(),
                  Text(
                    getTranslated(items[index], context),
                    style: items[index] == type
                        ? robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.white)
                        : robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).hintColor),
                  ),

                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}


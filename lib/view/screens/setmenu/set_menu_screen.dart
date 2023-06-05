import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/set_menu_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';


class SetMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<SetMenuProvider>(context, listen: false).getSetMenuList(context, true,Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);

    return Scaffold(
      appBar: CustomAppBar(context: context, title: getTranslated('set_menu', context)),
      body: Consumer<SetMenuProvider>(
        builder: (context, setMenu, child) {
          return setMenu.setMenuList != null ? setMenu.setMenuList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<SetMenuProvider>(context, listen: false).getSetMenuList(context, true,Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: setMenu.setMenuList.length,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 13,
                          mainAxisSpacing: 13,
                          childAspectRatio:  1/1.2,
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 4 : 2),
                      itemBuilder: (context, index) {
                        double _startingPrice;
                        double _endingPrice;
                        // if(setMenu.setMenuList[index].choiceOptions.length != 0) {
                        //   List<double> _priceList = [];
                        //   setMenu.setMenuList[index].variations.forEach((variation) => _priceList.add(variation.price));
                        //   _priceList.sort((a, b) => a.compareTo(b));
                        //   _startingPrice = _priceList[0];
                        //   if(_priceList[0] < _priceList[_priceList.length-1]) {
                        //     _endingPrice = _priceList[_priceList.length-1];
                        //   }
                        // }else {
                        //   _startingPrice = setMenu.setMenuList[index].price;
                        // }
                        _startingPrice = setMenu.setMenuList[index].price;

                        double _discount = setMenu.setMenuList[index].price - PriceConverter.convertWithDiscount(context,
                            setMenu.setMenuList[index].price, setMenu.setMenuList[index].discount, setMenu.setMenuList[index].discountType);

                        bool _isAvailable = DateConverter.isAvailable(setMenu.setMenuList[index].availableTimeStarts, setMenu.setMenuList[index].availableTimeEnds, context);

                        return Consumer<CartProvider>(
                            builder: (context, _cartProvider, child) {
                              int _cartIndex =   _cartProvider.getCartIndex(setMenu.setMenuList[index]);
                            return InkWell(
                              onTap: () {
                               ResponsiveHelper.isMobile(context) ? showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => CartBottomSheet(
                                 product: setMenu.setMenuList[index], fromSetMenu: true,
                                 cart:  _cartIndex == null || _cartIndex == -1 ? null : _cartProvider.cartList[_cartIndex],
                                 callback: (CartModel cartModel) {
                                   showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                                 },
                               )
                               ): showDialog(context: context, builder: (con) => Dialog(
                                 child: CartBottomSheet(
                                   product: setMenu.setMenuList[index], fromSetMenu: true,
                                   cart:  _cartIndex == null || _cartIndex == -1 ? null : _cartProvider.cartList[_cartIndex],
                                   callback: (CartModel cartModel) {
                                     showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                                   },
                                 ),
                               ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(
                                      color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                                      blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                                      spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                                    )]
                                ),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholder_rectangle, height: 110, width: MediaQuery.of(context).size.width/2, fit: BoxFit.cover,
                                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${setMenu.setMenuList[index].image}',
                                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_rectangle, height: 110, width: MediaQuery.of(context).size.width/2, fit: BoxFit.cover),
                                        ),
                                      ),
                                      _isAvailable ? SizedBox() : Positioned(
                                        top: 0, left: 0, bottom: 0, right: 0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                            color: Colors.black.withOpacity(0.6),
                                          ),
                                          child: Text(getTranslated('not_available_now', context), textAlign: TextAlign.center, style: rubikRegular.copyWith(
                                            color: Colors.white, fontSize: Dimensions.FONT_SIZE_SMALL,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                        Text(
                                          setMenu.setMenuList[index].name,
                                          style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2, overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                        RatingBar(
                                          rating: setMenu.setMenuList[index].rating.length > 0 ? double.parse(setMenu.setMenuList[index].rating[0].average) : 0.0,
                                          size: 12,
                                        ),
                                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${PriceConverter.convertPrice(context, _startingPrice, discount: setMenu.setMenuList[index].discount,
                                                  discountType: setMenu.setMenuList[index].discountType)}''${_endingPrice!= null
                                                  ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: setMenu.setMenuList[index].discount,
                                                  discountType: setMenu.setMenuList[index].discountType)}' : ''}',
                                              style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                            ),
                                            _discount > 0 ? SizedBox() : Icon(Icons.add, color: Theme.of(context).textTheme.bodyLarge.color),
                                          ],
                                        ),
                                        _discount > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Text(
                                            '${PriceConverter.convertPrice(context, _startingPrice)}'
                                                '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                            style: rubikBold.copyWith(
                                              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                              color: ColorResources.getGreyColor(context),
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                          Icon(Icons.add, color: Theme.of(context).textTheme.bodyLarge.color),
                                        ]) : SizedBox(),
                                      ]),
                                    ),
                                  ),

                                ]),
                              ),
                            );
                          }
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ) : NoDataScreen() : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}

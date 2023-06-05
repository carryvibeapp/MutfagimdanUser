import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/set_menu_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SetMenuPageView extends StatelessWidget {
  final SetMenuProvider setMenuProvider;
  final PageController pageController;
  const SetMenuPageView({Key key, @required this.setMenuProvider, @required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _totalPage = (setMenuProvider.setMenuList.length / 4).ceil();

    return Container(
      child: PageView.builder(
        controller: pageController,
        itemCount: _totalPage,
        onPageChanged: (index) {
          setMenuProvider.updateSetMenuCurrentIndex(index, _totalPage);
        },
        itemBuilder: (context, index) {
          int _initialLength = 4;
          int currentIndex = 4 * index;


          // ignore: unnecessary_statements
          (index + 1 == _totalPage) ? _initialLength = setMenuProvider.setMenuList.length - (index * 4)  : 4;
          return ListView.builder(
              itemCount: _initialLength, scrollDirection: Axis.horizontal, physics: NeverScrollableScrollPhysics(), shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL,vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              itemBuilder: (context, item) {
                int _currentIndex = item  + currentIndex;
                String _name = '';
                setMenuProvider.setMenuList[_currentIndex].name.length > 20 ? _name = setMenuProvider.setMenuList[_currentIndex].name.substring(0, 20)+' ...' : _name = setMenuProvider.setMenuList[_currentIndex].name;
                double _startingPrice;
                double _endingPrice;
                _startingPrice = setMenuProvider.setMenuList[_currentIndex].price;

                double _discount = setMenuProvider.setMenuList[_currentIndex].price - PriceConverter.convertWithDiscount(context,
                    setMenuProvider.setMenuList[_currentIndex].price, setMenuProvider.setMenuList[_currentIndex].discount, setMenuProvider.setMenuList[_currentIndex].discountType);

                bool _isAvailable = DateConverter.isAvailable(setMenuProvider.setMenuList[_currentIndex].availableTimeStarts, setMenuProvider.setMenuList[_currentIndex].availableTimeEnds, context);

                return OnHover(
                    builder: (isHover) {
                      return Consumer<CartProvider>(
                          builder: (context, _cartProvider, child) {
                            int _cartIndex =   _cartProvider.getCartIndex(setMenuProvider.setMenuList[_currentIndex]);
                          return InkWell(
                            hoverColor: Colors.transparent,
                            onTap: () {
                              showDialog(context: context, builder: (con) => Dialog(
                                child: CartBottomSheet(
                                  product: setMenuProvider.setMenuList[_currentIndex], fromSetMenu: true,
                                  cart:  _cartIndex == null || _cartIndex == -1 ? null : _cartProvider.cartList[_cartIndex],
                                  callback: (CartModel cartModel) {
                                    showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                                  },
                                ),
                              ));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_DEFAULT),
                              child: Container(
                                width: 278,
                                decoration: BoxDecoration(
                                    color: ColorResources.getCartColor(context),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(
                                      color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 300],
                                      blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                                      spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                                    )]
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                            child: FadeInImage.assetNetwork(
                                              placeholder: Images.placeholder_rectangle, height: 225.0, width: 368, fit: BoxFit.cover,
                                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${setMenuProvider.setMenuList[_currentIndex].image}',
                                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_rectangle, height: 225.0, width: 368, fit: BoxFit.cover),
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
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Text(_name, style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: ColorResources.getCartTitleColor(context)), maxLines: 2, overflow: TextOverflow.ellipsis),
                                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                            RatingBar(rating: setMenuProvider.setMenuList[_currentIndex].rating.length > 0 ? double.parse(setMenuProvider.setMenuList[_currentIndex].rating[0].average) : 0.0, size: Dimensions.PADDING_SIZE_DEFAULT),
                                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                            FittedBox(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  _discount > 0 ? Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                    child: Text(
                                                        '${PriceConverter.convertPrice(context, _startingPrice)}'
                                                            '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style:rubikBold.copyWith(
                                                        fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, decoration: TextDecoration.lineThrough,
                                                      )
                                                    ),
                                                  ) : SizedBox(),

                                                  Text(
                                                    '${PriceConverter.convertPrice(context, _startingPrice, discount: setMenuProvider.setMenuList[_currentIndex].discount,
                                                        discountType: setMenuProvider.setMenuList[_currentIndex].discountType)}''${_endingPrice!= null
                                                        ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: setMenuProvider.setMenuList[_currentIndex].discount,
                                                        discountType: setMenuProvider.setMenuList[_currentIndex].discountType)}' : ''}',
                                                    style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: ColorResources.APPBAR_HEADER_COL0R, overflow: TextOverflow.ellipsis),
                                                    maxLines: 1,
                                                  ),

                                                ],
                                              ),
                                            ),
                                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                            ElevatedButton(
                                                style : ElevatedButton.styleFrom(primary: ColorResources.APPBAR_HEADER_COL0R),
                                                onPressed: (){
                                                  showDialog(context: context, builder: (con) => Dialog(
                                                    child: CartBottomSheet(
                                                      cart:  _cartIndex == null || _cartIndex == -1 ? null : _cartProvider.cartList[_cartIndex],
                                                      product: setMenuProvider.setMenuList[_currentIndex], fromSetMenu: true,
                                                      callback: (CartModel cartModel) {
                                                        showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                                                      },
                                                    ),
                                                  ));
                                                }, child: Padding(
                                              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                Text(getTranslated('quick_view', context),style: robotoRegular), SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              ]),
                                            ))
                                          ]),
                                        ),
                                      ),

                                    ]),
                              ),
                            ),
                          );
                        }
                      );
                    }
                );
              }
          );
        },
      ),
    );
  }
}

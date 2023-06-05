import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';


class ProductWidgetWeb extends StatelessWidget {
  final bool fromPopularItem;
  final Product product;

  ProductWidgetWeb({@required this.product, this.fromPopularItem = false});

  @override
  Widget build(BuildContext context) {
    double _startingPrice;
    double _endingPrice;
    _startingPrice = product.price;


    double priceDiscount = PriceConverter.convertDiscount(context, product.price, product.discount, product.discountType);

    bool _isAvailable = product.availableTimeStarts != null && product.availableTimeEnds != null
        ? DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds, context) : false;

    return ResponsiveHelper.isMobilePhone() ? _itemView(_isAvailable, priceDiscount, _startingPrice, _endingPrice)
        : OnHover(builder: (isHover) {
          return _itemView(_isAvailable, priceDiscount, _startingPrice, _endingPrice);
        });
  }

  void _addToCart(BuildContext context, int _cartIndex, ) {
    print('here is cart index ----$_cartIndex');
    ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (con) => CartBottomSheet(
        product: product,
        cart: _cartIndex == null || _cartIndex == -1 ? null : Provider.of<CartProvider>(context, listen: false).cartList[_cartIndex],
        callback: (CartModel cartModel) {
          showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
        },
      ),
    ) : showDialog(context: context, builder: (con) => Dialog(
      child: CartBottomSheet(
        product: product,
        fromSetMenu: true,
        cart: _cartIndex == null || _cartIndex == -1 ? null : Provider.of<CartProvider>(context, listen: false).cartList[_cartIndex],
        callback: (CartModel cartModel) {
          showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
        },
      ),
    ));
  }

  Consumer<CartProvider> _itemView(bool _isAvailable, double priceDiscount, double _startingPrice, double _endingPrice) {
    return Consumer<CartProvider>(
        builder: (context, _cartProvider, child) {
          int _cartIndex =   _cartProvider.getCartIndex(product);
          String _productImage = '';
          try{
            _productImage =  '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}';
          }catch(e) {

          }

          return InkWell(
            onTap: () => _addToCart(context, _cartIndex),
            child: Stack(
              children: [
                Container(
                  // height: 220,
                  // width: 170,
                  decoration: BoxDecoration(
                      color: ColorResources.getCartColor(context), borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 300],
                          blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                          spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1)
                      ]),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholder_rectangle, fit: BoxFit.cover, height: 105, width: 195,
                                image: _productImage,
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_rectangle,  fit: BoxFit.cover,  height: 105, width: 195),
                              ),
                            ),
                            _isAvailable ? SizedBox() : Positioned(
                              top: 0, left: 0, bottom: 0, right: 0,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(10)), color: Colors.black.withOpacity(0.6)),
                                child: Text(getTranslated('not_available_now', context), textAlign: TextAlign.center,
                                    style: rubikRegular.copyWith(color: Colors.white, fontSize: Dimensions.FONT_SIZE_SMALL)
                                ),
                              ),
                            ),
                          ],
                        ),

                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(product.name, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getCartTitleColor(context)), maxLines: 2, overflow: TextOverflow.ellipsis,textAlign: TextAlign.center),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                              RatingBar(rating: product.rating.length > 0 ? double.parse(product.rating[0].average) : 0.0, size: Dimensions.PADDING_SIZE_DEFAULT),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                              FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    priceDiscount > 0 ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        child: Text('${PriceConverter.convertPrice(context, _startingPrice)}''${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                            style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, decoration: TextDecoration.lineThrough))) : SizedBox(),
                                    Text('${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType)}''${_endingPrice!= null
                                        ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount, discountType: product.discountType)}' : ''}',
                                        style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.APPBAR_HEADER_COL0R))
                                  ],
                                ),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 100,
                                  child: FittedBox(
                                      child: ElevatedButton(
                                          style : ElevatedButton.styleFrom(backgroundColor: ColorResources.APPBAR_HEADER_COL0R, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                                          onPressed:() => _addToCart(context, _cartIndex),
                                          child: Text(getTranslated('quick_view', context),style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL))
                                      )),
                                ),
                              ),
                            ]),
                          ),
                        ),

                      ]),
                ),
                Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: WishButton(product: product),
                      ),
                    )
                )
              ],
            ),
          );
        }
    );
  }
}




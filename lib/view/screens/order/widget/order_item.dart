import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/checkout/checkout_screen.dart';
import 'package:provider/provider.dart';

import '../order_details_screen.dart';

class OrderItem extends StatelessWidget {
  final OrderModel orderItem;
  final bool isRunning;
  final OrderProvider orderProvider;
  const OrderItem({Key key, @required this.orderProvider, @required this.isRunning, @required this.orderItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(
          color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
          spreadRadius: 1, blurRadius: 5,
        )],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [

        Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              Images.placeholder_image,
              height: 70, width: 80, fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('${getTranslated('order_id', context)}:', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(orderItem.id.toString(), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Expanded(child: orderItem.orderType == 'take_away' || orderItem.orderType == 'dine_in' ? Text(
                  '(${getTranslated(orderItem.orderType, context)})',
                  style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                ) : SizedBox()),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Text(
                '${orderItem.detailsCount} ${getTranslated(orderItem.detailsCount > 1 ? 'items' : 'item', context)}',
                style: rubikRegular.copyWith(color: ColorResources.COLOR_GREY),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Row(children: [
                Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 15),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text('${getTranslated('${orderItem.orderStatus}', context)}', style: rubikRegular.copyWith(color: Theme.of(context).primaryColor)),
              ]),
            ]),
          ),
        ]),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

        SizedBox(
          height: 50,
          child: Row(children: [
            Expanded(child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(width: 2, color: ColorResources.DISABLE_COLOR),
                ),
                minimumSize: Size(1, 50),
                padding: EdgeInsets.all(0),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.getOrderDetailsRoute(orderItem.id),
                  arguments: OrderDetailsScreen(orderModel: orderItem, orderId: orderItem.id),
                );
              },
              child: Text(getTranslated('details', context), style: Theme.of(context).textTheme.headline3.copyWith(
                color: ColorResources.DISABLE_COLOR,
                fontSize: Dimensions.FONT_SIZE_LARGE,
              )),
            )),
            SizedBox(width: 20),
            Expanded(child: orderItem.orderType != 'pos' && orderItem.orderType != 'take_away' ? CustomButton(
              btnTxt: getTranslated(isRunning ? 'track_order' : 'reorder', context),
              onTap: () async {
                if(isRunning) {
                  Navigator.pushNamed(context, Routes.getOrderTrackingRoute(orderItem.id));
                }
                else {
                  List<OrderDetailsModel> orderDetails = await orderProvider.getOrderDetails(orderItem.id.toString(), context);
                  List<CartModel> _cartList = [];
                  List<bool> _availableList = [];
                  orderDetails.forEach((orderDetail) {

                    // Variation xyz = orderDetail.variation;
                    List<AddOn> _addOnList = [];
                    List<Variation> _variationList = [];
                    for(int i = 0; i < orderDetail.addOnIds.length; i++) {
                      _addOnList.add(AddOn(id: orderDetail.addOnIds[i], quantity: orderDetail.addOnQtys[i]));
                    }

                    _cartList.add(CartModel(
                        orderDetail.price, PriceConverter.convertWithDiscount(context, orderDetail.price, orderDetail.discountOnProduct, 'amount'),
                        _variationList, orderDetail.discountOnProduct, orderDetail.quantity,
                        orderDetail.taxAmount, _addOnList, orderDetail.productDetails, [],
                    )
                    );

                  });
                  if(_availableList.contains(false)) {
                    showCustomSnackBar(getTranslated('one_or_more_product_unavailable', context), context);
                  }else {
                    if(orderItem.isProductAvailable) {
                      Navigator.pushNamed(
                        context,
                        Routes.getCheckoutRoute(
                          orderItem.orderAmount, 'reorder', orderItem.orderType,orderItem.couponDiscountTitle?? '',
                        ),
                        arguments: CheckoutScreen(
                          cartList: _cartList,
                          fromCart: false,
                          amount: orderItem.orderAmount,
                          orderType: orderItem.orderType,
                          couponCode: orderItem.couponDiscountTitle ?? '',
                        ),
                      );
                    }else{
                      showCustomSnackBar(getTranslated('one_or_more_product_unavailable', context), context);

                    }
                  }
                }

              },
            ) : SizedBox.shrink()),
          ]),
        ),

      ]),
    );
  }
}

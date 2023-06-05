import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/order/widget/order_cancel_dialog.dart';
import 'package:flutter_restaurant/view/screens/rare_review/rate_review_screen.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;


class ButtonView extends StatelessWidget {
  const ButtonView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Consumer<OrderProvider>(builder: (context, order, _) {
        return Column(children: [
          !order.showCancelled ? Center(
            child: SizedBox(
              width: _width > 700 ? 700 : _width,
              child: Row(children: [
                order.trackModel.orderStatus == 'pending' ? Expanded(child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(1, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(width: 2, color: ColorResources.DISABLE_COLOR),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context, barrierDismissible: false,
                        builder: (context) => OrderCancelDialog(
                          orderID: order.trackModel.id.toString(),
                          callback: (String message, bool isSuccess, String orderID) {
                            if (isSuccess) {
                              showCustomSnackBar('$message. Order ID: $orderID', context, isError: false);
                            } else {
                              showCustomSnackBar(message, context, isError: false);
                            }
                          },
                        ),
                      );
                    },

                    child: Text(
                      getTranslated('cancel_order', context),
                      style: Theme.of(context).textTheme.headline3.copyWith(
                        color: ColorResources.DISABLE_COLOR,
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                      ),
                    ),
                  ),
                )) : SizedBox(),


              ]),
            ),
          ) : Center(
            child: Container(
              width: _width > 700 ? 700 : _width,
              height: 50,
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                getTranslated('order_cancelled', context),
                style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
          ),

          (order.trackModel.orderStatus == 'confirmed'
              || order.trackModel.orderStatus == 'processing'
              || order.trackModel.orderStatus == 'out_for_delivery')
              ?
          Center(
            child: Container(
              width: _width > 700 ? 700 : _width,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: CustomButton(
                btnTxt: getTranslated('track_order', context),
                onTap: () {
                  Navigator.pushNamed(context, Routes.getOrderTrackingRoute(order.trackModel.id));
                },
              ),
            ),
          ) : SizedBox(),

          order.trackModel.orderStatus == 'delivered' ? Center(
            child: Container(
              width: _width > 700 ? 700 : _width,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: CustomButton(
                btnTxt: getTranslated('review', context),
                onTap: () {
                  List<OrderDetailsModel> _orderDetailsList = [];
                  List<int> _orderIdList = [];
                  order.orderDetails.forEach((orderDetails) {
                    if(!_orderIdList.contains(orderDetails.productDetails.id)) {
                      _orderDetailsList.add(orderDetails);
                      _orderIdList.add(orderDetails.productDetails.id);
                    }
                  });
                  Navigator.pushNamed(context, Routes.getRateReviewRoute(), arguments: RateReviewScreen(
                    orderDetailsList: _orderDetailsList,
                    deliveryMan: order.trackModel.deliveryMan,
                  ));
                },
              ),
            ),
          ) : SizedBox(),

          if(order.trackModel.deliveryMan != null && (order.trackModel.orderStatus != 'delivered'))
            Center(
              child: Container(
                width: _width > 700 ? 700 : _width,
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: CustomButton(btnTxt: getTranslated('chat_with_delivery_man', context), onTap: (){
                  Navigator.pushNamed(context, Routes.getChatRoute(orderModel: order.trackModel));
                }),
              ),
            ),
        ],);
      }
    );
  }
}

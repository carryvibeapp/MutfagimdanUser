import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/map_widget.dart';
import 'package:provider/provider.dart';

import 'change_method_dialog.dart';
import 'product_type_view.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
        builder: (context, order, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text('${getTranslated('order_id', context)}:', style: rubikRegular),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Text(order.trackModel.id.toString(), style: rubikMedium),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Expanded(child: SizedBox()),

                    Icon(Icons.watch_later, size: 17),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    order.trackModel.deliveryTime != null ? Text(
                      DateConverter.deliveryDateAndTimeToDate(order.trackModel.deliveryDate, order.trackModel.deliveryTime, context),
                      style: rubikRegular,
                    ) : Text(
                      DateConverter.isoStringToLocalDateOnly(order.trackModel.createdAt),
                      style: rubikRegular,
                    ),

                  ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Row(children: [
                Text('${getTranslated('item', context)}:', style: rubikRegular),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                Text(order.orderDetails.length.toString(), style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                Expanded(child: SizedBox()),

                order.trackModel.orderType == 'delivery' ? TextButton.icon(
                  onPressed: () {
                    if(order.trackModel.deliveryAddress != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MapWidget(address: order.trackModel.deliveryAddress)));
                    }
                    else{
                      showCustomSnackBar(getTranslated('address_not_found', context), context);
                    }
                  },
                  icon: Icon(Icons.map, size: 18),
                  label: Text(getTranslated('delivery_address', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(width: 1)),
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      minimumSize: Size(1, 30)
                  ),
                ) : order.trackModel.orderType == 'pos'
                    ? Text(getTranslated('pos_order', context), style: poppinsRegular) :
                order.trackModel.orderType == 'dine_in' ? Text(getTranslated('dine_in', context), style: poppinsRegular) :
                Text(getTranslated('${order.trackModel.orderType}', context), style: rubikMedium),

              ]),
              Divider(height: 20),

              // Payment info
              Align(
                alignment: Alignment.center,
                child: Text(
                  getTranslated('payment_info', context),
                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
              ),
              SizedBox(height: 10),

              Row(children: [
                Expanded(flex: 2, child: Text(getTranslated('status', context), style: rubikRegular)),

                Expanded(flex: 8, child: Text(
                  getTranslated(order.trackModel.paymentStatus, context),
                  style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                )),
              ]),
              SizedBox(height: 5),

              Row(children: [
                Expanded(flex: 2, child: Text(getTranslated('method', context), style: rubikRegular)),

                Expanded(flex: 8, child: Row(children: [
                  Text(
                    (order.trackModel.paymentMethod != null && order.trackModel.paymentMethod.length > 0)
                        ? '${order.trackModel.paymentMethod[0].toUpperCase()}${order.trackModel.paymentMethod.substring(1).replaceAll('_', ' ')}'
                        : getTranslated('digital_payment', context),
                    style: poppinsRegular.copyWith(color: Theme.of(context).primaryColor),
                  ),

                  (order.trackModel.paymentStatus != 'paid' && order.trackModel.paymentMethod != 'cash_on_delivery'
                      && order.trackModel.orderStatus != 'delivered') ? InkWell(
                    onTap: () {
                      if(Provider.of<SplashProvider>(context, listen: false).configModel.cashOnDelivery != 'true'){
                        showCustomSnackBar(getTranslated('cash_on_delivery_is_not_activated', context), context,isError: true);
                      }else{
                        showDialog(context: context, barrierDismissible: false, builder: (context) => ChangeMethodDialog(
                            orderID: order.trackModel.id.toString(),
                            // fromOrder: widget.orderModel !=null,
                            callback: (String message, bool isSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: Duration(milliseconds: 600), backgroundColor: isSuccess ? Colors.green : Colors.red));
                            }),);
                      }

                    }, child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL, vertical: 2),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.5)),
                    child: Text(getTranslated('change', context), style: rubikRegular.copyWith(fontSize: 10, color: Colors.black)),
                  ),
                  ) : SizedBox(),
                ])),
              ]),
              Divider(height: 40),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: order.orderDetails.length,
                itemBuilder: (context, index) {
                  List<AddOns> _addOns = [];
                  List<AddOns> _addons = order.orderDetails[index].productDetails  == null
                      ? [] : order.orderDetails[index].productDetails.addOns;

                  order.orderDetails[index].addOnIds.forEach((_id) {
                    _addons.forEach((addOn) {
                      if (addOn.id == _id) {
                        _addOns.add(addOn);
                      }
                    });

                  });

                  String _variationText = '';
                  if(order.orderDetails[index].variations != null && order.orderDetails[index].variations.length > 0) {
                    for(Variation variation in order.orderDetails[index].variations) {
                      _variationText += '${_variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
                      for(VariationValue value in variation.variationValues) {
                        _variationText += '${_variationText.endsWith('(') ? '' : ', '}${value.level}';
                      }
                      _variationText += ')';
                    }
                  }else if(order.orderDetails[index].oldVariations != null && order.orderDetails[index].oldVariations.length > 0) {
                    _variationText = order.orderDetails[index].oldVariations[0].type;
                  }


                  return order.orderDetails[index].productDetails != null ?
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder_image, height: 70, width: 80, fit: BoxFit.cover,
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/'
                              '${order.orderDetails[index].productDetails.image}',
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height: 70, width: 80, fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  order.orderDetails[index].productDetails.name,
                                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text('${getTranslated('quantity', context)}:', style: rubikRegular),
                              Text(order.orderDetails[index].quantity.toString(), style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                            ],
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(children: [
                                  Text(
                                    PriceConverter.convertPrice(context, order.orderDetails[index].price - order.orderDetails[index].discountOnProduct),
                                    style: rubikBold,
                                  ),
                                  SizedBox(width: 5),
                                  order.orderDetails[index].discountOnProduct > 0 ? Expanded(child: Text(
                                    PriceConverter.convertPrice(context, order.orderDetails[index].price),
                                    style: rubikBold.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: ColorResources.COLOR_GREY,
                                    ),
                                  )) : SizedBox(),
                                ]),
                              ),

                              Flexible(child: ProductTypeView(productType: order.orderDetails[index].productDetails.productType,)),
                            ],
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          _variationText != '' ? Row(children: [
                              Container(height: 10, width: 10, decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).textTheme.bodyLarge.color,
                              )),
                            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                            Flexible(
                              child: Text(_variationText,
                                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ]):SizedBox(),
                        ]),
                      ),
                    ]),

                    _addOns.length > 0 ? SizedBox(
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                        itemCount: _addOns.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                            child: Row(children: [
                              Text(_addOns[i].name, style: rubikRegular),
                              SizedBox(width: 2),
                              Text(PriceConverter.convertPrice(context, _addOns[i].price), style: rubikMedium),
                              SizedBox(width: 2),
                              Text('(${order.orderDetails[index].addOnQtys[i]})', style: rubikRegular),
                            ]),
                          );
                        },
                      ),
                    )
                        : SizedBox(),

                    Divider(height: 40),
                  ]) : SizedBox.shrink();
                },
              ),

              (order.trackModel.orderNote != null && order.trackModel.orderNote.isNotEmpty) ? Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_LARGE),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: ColorResources.getGreyColor(context)),
                ),
                child: Text(order.trackModel.orderNote, style: rubikRegular.copyWith(color: ColorResources.getGreyColor(context))),
              ) : SizedBox(),



            ],
          );
        }
    );
  }
}

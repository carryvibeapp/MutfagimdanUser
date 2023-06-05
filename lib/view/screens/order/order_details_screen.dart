import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';
import 'widget/buttonView.dart';
import 'widget/details_view.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  final int orderId;
  OrderDetailsScreen({@required this.orderModel, @required this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();


  void _loadData(BuildContext context) async {
    await Provider.of<OrderProvider>(context, listen: false).trackOrder(widget.orderId.toString(), widget.orderModel, context, false);
    if(widget.orderModel == null) {
      await Provider.of<SplashProvider>(context, listen: false).initConfig(context);
    }
    await Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    Provider.of<OrderProvider>(context, listen: false).getOrderDetails(widget.orderId.toString(), context);
  }

  @override
  void initState() {
    super.initState();

    _loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffold,
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100))
          : CustomAppBar(context: context, title: getTranslated('order_details', context)),

      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          double deliveryCharge = 0;
          double _itemsPrice = 0;
          double _discount = 0;
          double _tax = 0;
          double _addOns = 0;
          double _extraDiscount = 0;
          try{
            if(order.orderDetails != null) {
              if(order.trackModel.orderType == 'delivery') {
                deliveryCharge = order.trackModel.deliveryCharge;
              }
              for(OrderDetailsModel orderDetails in order.orderDetails) {
                int _index = 0;
                List<AddOns> _addonsData = orderDetails.productDetails == null
                    ? [] : orderDetails.productDetails.addOns ?? [];

                List<int> _addonsIds = orderDetails.addOnIds != null ? orderDetails.addOnIds : [];


                _addonsIds.forEach((_id) {
                  for(AddOns addOn in _addonsData) {

                    if(_id == addOn.id) {
                      _addOns = _addOns + (addOn.price * orderDetails.addOnQtys[_index]);
                      _index++;
                    }
                  }

                });



                _itemsPrice = _itemsPrice + (orderDetails.price * orderDetails.quantity);
                _discount = _discount + (orderDetails.discountOnProduct * orderDetails.quantity);
                _tax = _tax + (orderDetails.taxAmount * orderDetails.quantity);
              }
            }

          }catch(e) {
            print('order type $e');
          }
          if( order.trackModel != null &&  order.trackModel.extraDiscount!=null) {
            _extraDiscount  = order.trackModel.extraDiscount ?? 0.0;
          }
          double _subTotal = _itemsPrice + _tax + _addOns;
          double _total = _itemsPrice + _addOns - _discount - _extraDiscount + _tax + deliveryCharge - (order.trackModel != null
              ? order.trackModel.couponDiscountAmount : 0);



          return order.orderDetails != null && order.trackModel != null ?
          ResponsiveHelper.isDesktop(context)?
          SingleChildScrollView(
            child: Column(
              children: [

                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600
                        ? _height : _height - 400,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(width: 1170,
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: _width > 700 ? 700 : _width,
                                padding: _width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                                decoration: _width > 700 ? BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(
                                    color: Colors.grey[300],
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  )],
                                ) : null,
                                child: DetailsView(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(width: 400,
                                padding: _width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                                decoration: _width > 700 ? BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(
                                    color: Colors.grey[300],
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  )],
                                ) : null,

                                child: _amountView(
                                  context, _itemsPrice, _tax,
                                  _addOns, _subTotal, _discount,
                                  order, _extraDiscount,
                                  deliveryCharge, _total,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),



                ResponsiveHelper.isDesktop(context)? FooterView() : SizedBox()
              ],
            ),
          ) :
          Column(
            children: [

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      DetailsView(),

                      _amountView(
                        context, _itemsPrice, _tax,
                        _addOns, _subTotal, _discount,
                        order, _extraDiscount,
                        deliveryCharge, _total,
                      ),
                    ]),
                  ),
                ),
              ),

              ButtonView(),



            ],
          )
              : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),);
        },
      ),
    );
  }


  Widget _amountView(
      BuildContext context, 
      double _itemsPrice, 
      double _tax, 
      double _addOns, 
      double _subTotal,
      double _discount, 
      OrderProvider order,
      double _extraDiscount,
      double deliveryCharge,
      double _total,
      ) {
    return Column(children: [
      // Total
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('items_price', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        Text(PriceConverter.convertPrice(context, _itemsPrice), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      ]),
      SizedBox(height: 10),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('tax', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        Text('(+) ${PriceConverter.convertPrice(context, _tax)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      ]),
      SizedBox(height: 10),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('addons', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        Text('(+) ${PriceConverter.convertPrice(context, _addOns)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      ]),

      Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
        child: CustomDivider(),
      ),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('subtotal', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        Text(PriceConverter.convertPrice(context, _subTotal), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      ]),
      SizedBox(height: 10),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('discount', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        Text('(-) ${PriceConverter.convertPrice(context, _discount)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      ]),
      SizedBox(height: 10),

      ///....Extra discount..
      (order.trackModel.orderType=="pos" || order.trackModel.orderType=="dine_in") ?
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('extra_discount', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          Text('(-) ${PriceConverter.convertPrice(context, _extraDiscount ?? 0.0)}', style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ]),
      ):SizedBox(),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('coupon_discount', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        Text(
          '(-) ${PriceConverter.convertPrice(context, order.trackModel.couponDiscountAmount)}',
          style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
        ),
      ]),
      SizedBox(height: 10),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('delivery_fee', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        Text('(+) ${PriceConverter.convertPrice(context, deliveryCharge)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      ]),

      Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
        child: CustomDivider(),
      ),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('total_amount', context), style: rubikMedium.copyWith(
          fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor,
        )),
        Text(
          PriceConverter.convertPrice(context, _total),
          style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
        ),
      ]),

     if(ResponsiveHelper.isDesktop(context)) ButtonView(),

    ],
    );
  }


}





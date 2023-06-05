import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/time_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/track/widget/custom_stepper.dart';
import 'package:flutter_restaurant/view/screens/track/widget/delivery_man_widget.dart';
import 'package:flutter_restaurant/view/screens/track/widget/tracking_map_widget.dart';
import 'package:provider/provider.dart';

import 'widget/timer_view.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderID;
  OrderTrackingScreen({@required this.orderID,});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    Provider.of<OrderProvider>(context, listen: false).getDeliveryManData(widget.orderID, context);
    Provider.of<OrderProvider>(context, listen: false).trackOrder(widget.orderID, null, context, true).whenComplete(() =>
        Provider.of<TimerProvider>(context, listen: false).countDownTimer(Provider.of<OrderProvider>(context, listen: false).trackModel, context));
  }
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final List<String> _statusList = ['pending', 'confirmed', 'processing' ,'out_for_delivery', 'delivered', 'returned', 'failed', 'canceled'];

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : CustomAppBar(context: context, title: getTranslated('order_tracking', context)),
      body: SingleChildScrollView(
        child: Column(
          children: [

            ConstrainedBox(
              constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
              child: Padding(
                padding: EdgeInsets.only(
                  left: Dimensions.PADDING_SIZE_LARGE,
                  right: Dimensions.PADDING_SIZE_LARGE,
                  bottom: Dimensions.PADDING_SIZE_LARGE,
                  top: ResponsiveHelper.isMobile(context) ? 0 : Dimensions.PADDING_SIZE_LARGE
                ),
                child: Center(
                  child: Consumer<OrderProvider>(
                    builder: (context, order, child) {
                      String _status;
                      if(order.trackModel != null) {
                        _status = order.trackModel.orderStatus;
                      }

                      if(_status != null && _status == _statusList[5] || _status == _statusList[6] || _status == _statusList[7]) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text(_status),
                            SizedBox(height: 50),
                            CustomButton(btnTxt: getTranslated('back_home', context), onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                            }),
                          ],
                        );
                      } else if(order.responseModel != null && !order.responseModel.isSuccess) {
                        return Center(child: Text(order.responseModel.message));
                      }


                      return _status != null ? RefreshIndicator(
                        onRefresh: () async {
                          await Provider.of<OrderProvider>(context, listen: false).getDeliveryManData(widget.orderID, context);
                          await Provider.of<OrderProvider>(context, listen: false).trackOrder(widget.orderID, null, context, true);
                        },
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Center(
                              child: Container(
                                // width: _width > 700 ? 700 : _width,
                                padding: _width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                                decoration: _width > 700 ? BoxDecoration(
                                  color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                                ) : null,
                                child: SizedBox(
                                  width: 1170,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      if(_status == _statusList[0] ||
                                          _status == _statusList[1] ||
                                          _status == _statusList[2] ||
                                          _status == _statusList[3]) TimerView(),
                                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                                      order.trackModel.deliveryMan != null ? DeliveryManWidget(deliveryMan: order.trackModel.deliveryMan) : SizedBox(),

                                      order.trackModel.deliveryMan != null ? SizedBox(height: 30) : SizedBox(),

                                      CustomStepper(
                                        title: getTranslated('order_placed', context),
                                        isActive: true,
                                        haveTopBar: false,
                                      ),
                                      CustomStepper(
                                        title: getTranslated('order_accepted', context),
                                        isActive: _status != _statusList[0],
                                      ),
                                      CustomStepper(
                                        title: getTranslated('preparing_food', context),
                                        isActive: _status != _statusList[0] && _status != _statusList[1],
                                      ),
                                      order.trackModel.orderType != 'take_away' ? CustomStepper(
                                        title: getTranslated('food_in_the_way', context),
                                        isActive: _status != _statusList[0] && _status != _statusList[1] && _status != _statusList[2],
                                      ) : SizedBox(),
                                      CustomStepper(
                                        title: getTranslated('delivered_the_food', context),
                                        isActive: _status == _statusList[4], height: _status == _statusList[3] ? 240 : 30,
                                        child: _status == _statusList[3] ? Builder(
                                          builder: (context) {
                                            AddressModel _address;
                                            for(int i = 0 ; i< Provider.of<LocationProvider>(context, listen: false).addressList.length; i++) {
                                              if(Provider.of<LocationProvider>(context, listen: false).addressList[i].id == order.trackModel.deliveryAddressId) {
                                                _address = Provider.of<LocationProvider>(context, listen: false).addressList[i];
                                              }
                                            }
                                            return TrackingMapWidget(
                                              deliveryManModel: order.deliveryManModel,
                                              orderID: widget.orderID,
                                              addressModel: _address,
                                            );
                                          }
                                        ) : null,
                                      ),
                                      SizedBox(height: 50),

                                    ResponsiveHelper.isDesktop(context) ? Center(
                                        child: SizedBox(
                                          width: 400,
                                          child: CustomButton(btnTxt: getTranslated('back_home', context), onTap: () {
                                            Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                          }),
                                        ),
                                      ) : CustomButton(btnTxt: getTranslated('back_home', context), onTap: () {
                                      Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                    }),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ) : Center(
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                    },
                  ),
                ),
              ),
            ),
            if(ResponsiveHelper.isDesktop(context)) FooterView(),
          ],
        ),
      ),
    );
  }
}

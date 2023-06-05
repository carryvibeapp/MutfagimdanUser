import 'dart:collection';
import 'dart:convert'as convert;
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/branch_button_view.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/address/widget/permission_dialog.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/delivery_fee_dialog.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/digital_payment_view.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/slot_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

class CheckoutScreen extends StatefulWidget {
  final double amount;
  final String orderType;
  final List<CartModel> cartList;
  final bool fromCart;
  final String couponCode;
  CheckoutScreen({ @required this.amount, @required this.orderType, @required this.fromCart,
    @required this.cartList, @required this.couponCode});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _noteController = TextEditingController();
  GoogleMapController _mapController;
  bool _loading = true;
  Set<Marker> _markers = HashSet<Marker>();
  bool _isLoggedIn;
  List<CartModel> _cartList;
  List<String> _paymentList = [];
  List<Color> _paymentColor = [];
  Branches currentBranch;

  @override
  void initState() {
    super.initState();

    currentBranch = Provider.of<BranchProvider>(context, listen: false).getBranch();

    if(Provider.of<SplashProvider>(context, listen: false).configModel.cashOnDelivery == 'true') {
      _paymentList.add('cash_on_delivery');
      _paymentColor.add( Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.02));
    }

    if(Provider.of<SplashProvider>(context, listen: false).configModel.walletStatus) {
      _paymentList.add('wallet_payment');
      _paymentColor.add( Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.1));
    }

    Provider.of<SplashProvider>(context, listen: false).configModel.activePaymentMethodList.forEach((_method){
      _paymentList.add(_method);
      _paymentColor.add( Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.1));
    });



    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<OrderProvider>(context, listen: false).initializeTimeSlot(context).then((value) {
        Provider.of<OrderProvider>(context, listen: false).sortTime();
      });

      if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel == null) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      }
      Provider.of<LocationProvider>(context, listen: false).initAddressList(context);


      Provider.of<OrderProvider>(context, listen: false).clearPrevData();


      _cartList = [];
      widget.fromCart ? _cartList.addAll(Provider.of<CartProvider>(context, listen: false).cartList) : _cartList.addAll(widget.cartList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final _height = MediaQuery.of(context).size.height;
    bool _kmWiseCharge = _configModel.deliveryManagement.status == 1;
    bool _takeAway = widget.orderType == 'take_away';

    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : CustomAppBar(context: context, title: getTranslated('checkout', context)),
      body: _isLoggedIn ? Consumer<OrderProvider>(
        builder: (context, order, child) {
          double _deliveryCharge = 0;

          if(!_takeAway && _kmWiseCharge) {
            _deliveryCharge = order.distance * _configModel.deliveryManagement.shippingPerKm;
            if(_deliveryCharge < _configModel.deliveryManagement.minShippingCharge) {
              _deliveryCharge = _configModel.deliveryManagement.minShippingCharge;
            }
          }else if(!_takeAway && !_kmWiseCharge) {
            _deliveryCharge = _configModel.deliveryCharge;
          }

          return Consumer<LocationProvider>(
            builder: (context, address, child) {
              return Column(
                children: [

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                            child: Center(
                              child: SizedBox(
                                width: 1170,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        margin: ResponsiveHelper.isDesktop(context) ?  EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_LARGE) : EdgeInsets.all(0),
                                        decoration:ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color:ColorResources.CARD_SHADOW_COLOR.withOpacity(0.2),
                                                blurRadius: 10,
                                              )
                                            ]
                                        ) : BoxDecoration(),

                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(getTranslated('your_branch', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),

                                                  Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).primaryColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: BranchButtonView(isRow: true),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Container(
                                              height: ResponsiveHelper.isMobile(context) ? 200 : 300,
                                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                              margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Theme.of(context).cardColor,
                                              ),
                                              child: Stack(children: [
                                                GoogleMap(
                                                  mapType: MapType.normal,
                                                  initialCameraPosition: CameraPosition(
                                                    target: LatLng(
                                                      double.parse(currentBranch.latitude),
                                                      double.parse(currentBranch.longitude),
                                                    ), zoom: 5,
                                                  ),
                                                  minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                                                  zoomControlsEnabled: true,
                                                  markers: _markers,
                                                  onMapCreated: (GoogleMapController controller) async {
                                                    await Geolocator.requestPermission();
                                                    _mapController = controller;
                                                    _loading = false;
                                                    _setMarkers(Provider.of<SplashProvider>(context, listen: false).configModel.branches.indexOf(currentBranch));
                                                  },
                                                ),
                                                _loading ? Center(child: CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                                )) : SizedBox(),
                                              ]),
                                            ),
                                          ]),

                                          // Address
                                          !_takeAway ? Column(children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                              child: Row(children: [
                                                Text(getTranslated('delivery_address', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                                Expanded(child: SizedBox()),
                                                TextButton.icon(
                                                  onPressed: () => _checkPermission(context, Routes.getAddAddressRoute('checkout', 'add', AddressModel())),
                                                  icon: Icon(Icons.add),
                                                  label: Text(getTranslated('add', context), style: rubikRegular),
                                                ),
                                              ]),
                                            ),

                                            SizedBox(
                                              height: 60,
                                              child: address.addressList != null ? address.addressList.length > 0 ? ListView.builder(
                                                physics: BouncingScrollPhysics(),
                                                scrollDirection: Axis.horizontal,
                                                padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                                itemCount: address.addressList.length,
                                                itemBuilder: (context, index) {
                                                  bool _isAvailable = currentBranch == null || (currentBranch.latitude == null || currentBranch.latitude.isEmpty);
                                                  if(!_isAvailable) {
                                                    double _distance = Geolocator.distanceBetween(
                                                      double.parse(currentBranch.latitude), double.parse(currentBranch.longitude),
                                                      double.parse(address.addressList[index].latitude), double.parse(address.addressList[index].longitude),
                                                    ) / 1000;

                                                    _isAvailable = _distance < currentBranch.coverage;
                                                  }
                                                  return Padding(
                                                    padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        if(_isAvailable) {
                                                          order.setAddressIndex(index);
                                                          if(_kmWiseCharge) {
                                                            showDialog(context: context, builder: (context) => Center(child: Container(
                                                              height: 100, width: 100, decoration: BoxDecoration(
                                                              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                                                            ),
                                                              alignment: Alignment.center,
                                                              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                                                            )), barrierDismissible: false);
                                                            bool _isSuccess = await order.getDistanceInMeter(
                                                              LatLng(
                                                                double.parse(currentBranch.latitude),
                                                                double.parse(currentBranch.longitude),
                                                              ),
                                                              LatLng(
                                                                double.parse(address.addressList[index].latitude),
                                                                double.parse(address.addressList[index].longitude),
                                                              ),
                                                            );
                                                            Navigator.pop(context);
                                                            if(_isSuccess) {
                                                              showDialog(context: context, builder: (context) => DeliveryFeeDialog(
                                                                amount: widget.amount, distance: order.distance,
                                                              ));
                                                            }else {
                                                              showCustomSnackBar(getTranslated('failed_to_fetch_distance', context), context);
                                                            }
                                                          }
                                                        }
                                                      },
                                                      child: Stack(children: [
                                                        Container(
                                                          height: 60,
                                                          width: 200,
                                                          decoration: BoxDecoration(
                                                            color: index == order.addressIndex ? Theme.of(context).cardColor : Theme.of(context).backgroundColor,
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: index == order.addressIndex ? Border.all(color: Theme.of(context).primaryColor, width: 2) : null,
                                                          ),
                                                          child: Row(children: [
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                              child: Icon(
                                                                address.addressList[index].addressType == 'Home' ? Icons.home_outlined
                                                                    : address.addressList[index].addressType == 'Workplace' ? Icons.work_outline : Icons.list_alt_outlined,
                                                                color: index == order.addressIndex ? Theme.of(context).primaryColor
                                                                    : Theme.of(context).textTheme.bodyLarge.color,
                                                                size: 30,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                Text(address.addressList[index].addressType, style: rubikRegular.copyWith(
                                                                  fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyBunkerColor(context),
                                                                )),
                                                                Text(address.addressList[index].address, style: rubikRegular, maxLines: 1, overflow: TextOverflow.ellipsis),
                                                              ]),
                                                            ),
                                                            index == order.addressIndex ? Align(
                                                              alignment: Alignment.topRight,
                                                              child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                                                            ) : SizedBox(),
                                                          ]),
                                                        ),
                                                        !_isAvailable ? Positioned(
                                                          top: 0, left: 0, bottom: 0, right: 0,
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withOpacity(0.6)),
                                                            child: Text(
                                                              getTranslated('out_of_coverage_for_this_branch', context),
                                                              textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                                                              style: rubikRegular.copyWith(color: Colors.white, fontSize: 10),
                                                            ),
                                                          ),
                                                        ) : SizedBox(),
                                                      ]),
                                                    ),
                                                  );
                                                },
                                              ) : Center(child: Text(getTranslated('no_address_available', context)))
                                                  : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                            ),
                                            SizedBox(height: 20),
                                          ]) : SizedBox(),

                                          // Time Slot
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                            child: Text(getTranslated('preference_time', context), style: rubikMedium),
                                          ),
                                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                          SizedBox(
                                            height: 50,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              physics: BouncingScrollPhysics(),
                                              padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                              itemCount: 2,
                                              itemBuilder: (context, index) {
                                                return SlotWidget(
                                                  title: index == 0 ? getTranslated('today', context) : getTranslated('tomorrow', context),
                                                  isSelected: order.selectDateSlot == index,
                                                  onTap: () => order.updateDateSlot(index),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                          SizedBox(
                                            height: 50,
                                            child: order.timeSlots != null ? order.timeSlots.length > 0 ? ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              physics: BouncingScrollPhysics(),
                                              padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                              itemCount: order.timeSlots.length,
                                              itemBuilder: (context, index) {
                                                return SlotWidget(
                                                  title: (
                                                      index == 0 && order.selectDateSlot == 0  && Provider.of<SplashProvider>(context, listen: false).isRestaurantOpenNow(context))
                                                      ? getTranslated('now', context)
                                                      : '${DateConverter.dateToTimeOnly(order.timeSlots[index].startTime, context)} '
                                                      '- ${DateConverter.dateToTimeOnly(order.timeSlots[index].endTime, context)}',
                                                  isSelected: order.selectTimeSlot == index,
                                                  onTap: () => order.updateTimeSlot(index),
                                                );
                                              },
                                            ) : Center(child: Text(getTranslated('no_slot_available', context))) : Center(child: CircularProgressIndicator()),
                                          ),
                                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                          if (!ResponsiveHelper.isDesktop(context))  detailsWidget(context, _kmWiseCharge, _takeAway, order, _deliveryCharge, address),






                                        ]),
                                      ),
                                    ),
                                    if(ResponsiveHelper.isDesktop(context)) Expanded(
                                      flex: 4,
                                      child: Container(
                                        padding: ResponsiveHelper.isDesktop(context) ?   EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical: Dimensions.PADDING_SIZE_LARGE) : EdgeInsets.all(0),
                                        margin: ResponsiveHelper.isDesktop(context) ?  EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_LARGE) : EdgeInsets.all(0),
                                        decoration:ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color:ColorResources.CARD_SHADOW_COLOR.withOpacity(0.2),
                                                blurRadius: 10,
                                              )
                                            ]
                                        ) : BoxDecoration(),
                                        child: detailsWidget(
                                            context, _kmWiseCharge, _takeAway, order, _deliveryCharge, address),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if(ResponsiveHelper.isDesktop(context)) SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          if(ResponsiveHelper.isDesktop(context)) FooterView(),
                        ],
                      ),
                    ),
                  ),

                  if(!ResponsiveHelper.isDesktop(context))
                    confirmButtonWidget(order, _takeAway, address, _kmWiseCharge, _deliveryCharge, context),

                ],
              );
            },
          );
        },
      ) : NotLoggedInScreen(),
    );
  }

  Container confirmButtonWidget(
      OrderProvider order,
      bool _takeAway,
      LocationProvider address,
      bool _kmWiseCharge,
      double _deliveryCharge,
      BuildContext context,
      ) {
    return Container(
      width: 1170,
      alignment: Alignment.center,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: !order.isLoading ? Builder(
        builder: (context) => CustomButton(
            btnTxt: getTranslated('confirm_order', context),
            onTap: () {
              if(order.paymentMethod != ''){
                bool _isAvailable = true;
                DateTime _scheduleStartDate = DateTime.now();
                DateTime _scheduleEndDate = DateTime.now();
                if(order.timeSlots == null || order.timeSlots.length == 0) {
                  _isAvailable = false;
                }else {
                  DateTime _date = order.selectDateSlot == 0 ? DateTime.now() : DateTime.now().add(Duration(days: 1));
                  DateTime _startTime = order.timeSlots[order.selectTimeSlot].startTime;
                  DateTime _endTime = order.timeSlots[order.selectTimeSlot].endTime;
                  _scheduleStartDate = DateTime(_date.year, _date.month, _date.day, _startTime.hour, _startTime.minute+1);
                  _scheduleEndDate = DateTime(_date.year, _date.month, _date.day, _endTime.hour, _endTime.minute+1);
                  for (CartModel cart in _cartList) {
                    if (!DateConverter.isAvailable(cart.product.availableTimeStarts, cart.product.availableTimeEnds, context, time: _scheduleStartDate ?? null,)
                        && !DateConverter.isAvailable(cart.product.availableTimeStarts, cart.product.availableTimeEnds, context, time: _scheduleEndDate ?? null)
                    ) {
                      _isAvailable = false;
                      break;
                    }
                  }
                }

                if(widget.amount < Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue) {
                  showCustomSnackBar('Minimum order amount is ${Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue}', context);
                }else if(order.paymentMethod == 'wallet_payment'
                    && Provider.of<ProfileProvider>(context, listen: false).userInfoModel.walletBalance != null
                    && Provider.of<ProfileProvider>(context, listen: false).userInfoModel.walletBalance < (widget.amount + _deliveryCharge)
                ){
                  showCustomSnackBar(getTranslated('you_do_not_have_sufficient_balance_in_wallet', context), context);
                } else if(!_takeAway && (address.addressList == null || address.addressList.length == 0 || order.addressIndex < 0)) {
                  showCustomSnackBar(getTranslated('select_an_address', context), context);
                }else if (order.timeSlots == null || order.timeSlots.length == 0) {
                  showCustomSnackBar(getTranslated('select_a_time', context), context);
                }else if (!_isAvailable) {
                  showCustomSnackBar(getTranslated('one_or_more_products_are_not_available_for_this_selected_time', context), context);
                }else if (!_takeAway && _kmWiseCharge && order.distance == -1) {
                  showCustomSnackBar(getTranslated('delivery_fee_not_set_yet', context), context);
                }else {
                  List<Cart> carts = [];
                  for (int index = 0; index < _cartList.length; index++) {
                    CartModel cart = _cartList[index];
                    List<int> _addOnIdList = [];
                    List<int> _addOnQtyList = [];
                    List<OrderVariation> _variations = [];

                    cart.addOnIds.forEach((addOn) {
                      _addOnIdList.add(addOn.id);
                      _addOnQtyList.add(addOn.quantity);
                    });

                    if(cart.product.variations != null){
                      for(int i=0; i<cart.product.variations.length; i++) {
                        if(cart.variations[i].contains(true)) {
                          _variations.add(OrderVariation(
                            name: cart.product.variations[i].name,
                            values: OrderVariationValue(label: []),
                          ));

                          for(int j=0; j<cart.product.variations[i].variationValues.length; j++) {
                            if(cart.variations[i][j]) {
                              _variations[_variations.length-1].values.label.add(cart.product.variations[i].variationValues[j].level);
                            }
                          }
                        }
                      }
                    }


                    carts.add(Cart(
                      cart.product.id.toString(), cart.discountedPrice.toString(), [], _variations,
                      cart.discountAmount, cart.quantity, cart.taxAmount, _addOnIdList, _addOnQtyList,
                    ));
                  }
                  PlaceOrderBody _placeOrderBody = PlaceOrderBody(
                    cart: carts, couponDiscountAmount: Provider.of<CouponProvider>(context, listen: false).discount,
                    couponDiscountTitle: widget.couponCode.isNotEmpty ? widget.couponCode : null,
                    deliveryAddressId: !_takeAway ? Provider.of<LocationProvider>(context, listen: false)
                        .addressList[order.addressIndex].id : 0,
                    orderAmount: double.parse('${(widget.amount).toStringAsFixed(2)}'),
                    orderNote: _noteController.text ?? '', orderType: widget.orderType,
                    paymentMethod: order.paymentMethod,
                    couponCode: widget.couponCode.isNotEmpty ? widget.couponCode : null, distance: _takeAway ? 0 : order.distance,
                    branchId: currentBranch.id,
                    deliveryDate: DateFormat('yyyy-MM-dd').format(_scheduleStartDate),
                    deliveryTime: (order.selectTimeSlot == 0 && order.selectDateSlot == 0) ? 'now' : DateFormat('HH:mm').format(_scheduleStartDate),
                  );
                  print('placeOrder  : ${_placeOrderBody.toJson()}');

                  if(order.paymentMethod == 'wallet_payment' || order.paymentMethod == 'cash_on_delivery' ) {
                    order.placeOrder(_placeOrderBody, _callback);
                  }
                  else {
                    String hostname = html.window.location.hostname;
                    String protocol = html.window.location.protocol;
                    String port = html.window.location.port;
                    final String _placeOrder =  convert.base64Url.encode(convert.utf8.encode(convert.jsonEncode(_placeOrderBody.toJson())));
                    String _url = "customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id}"
                        "&&callback=${AppConstants.BASE_URL}${Routes.ORDER_SUCCESS_SCREEN}&&order_amount=${(widget.amount+_deliveryCharge).toStringAsFixed(2)}";

                    String _webUrl = "customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id}"
                        "&&callback=$protocol//$hostname${kDebugMode ? ':$port' : ''}${Routes.ORDER_WEB_PAYMENT}&&order_amount=${(widget.amount+_deliveryCharge).toStringAsFixed(2)}&&status=";

                    String _tokenUrl = '${convert.base64Encode(convert.utf8.encode(ResponsiveHelper.isWeb() ? _webUrl : _url))}';
                    String selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?token=$_tokenUrl&&payment_method=${order.paymentMethod}';

                    order.clearPlaceOrder().then((_) => order.setPlaceOrder(_placeOrder).then((value) {
                      if(ResponsiveHelper.isWeb()){
                        html.window.open(selectedUrl,"_self");
                      }else{
                       Navigator.pushReplacementNamed(context, Routes.getPaymentRoute(_tokenUrl));
                      }

                    }));
                  }
                }
              } else{
                showCustomSnackBar(getTranslated('select_payment_method', context), context);
              }
            }),
      ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
    );
  }


  Widget detailsWidget(BuildContext context, bool _kmWiseCharge, bool _takeAway, OrderProvider order, double _deliveryCharge, LocationProvider address) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
          child: Text(getTranslated('payment_method', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.PADDING_SIZE_SMALL),
          child: DigitalPaymentView(paymentList: _paymentList, colorList: _paymentColor),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Padding(
          padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.PADDING_SIZE_SMALL),
          child: Card(child: CustomTextField(
            controller: _noteController,
            hintText: getTranslated('additional_note', context),
            maxLines: 5,
            inputType: TextInputType.multiline,
            inputAction: TextInputAction.newline,
            capitalization: TextCapitalization.sentences,
          )),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        _kmWiseCharge ? Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
          child: Column(children: [
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(getTranslated('subtotal', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              Text(PriceConverter.convertPrice(context, widget.amount), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
            ]),
            SizedBox(height: 10),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                getTranslated('delivery_fee', context),
                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
              Text(
                (!_takeAway || order.distance != -1) ?
                '(+) ${PriceConverter.convertPrice(context, _takeAway ? 0 : _deliveryCharge)}'
                    : getTranslated('not_found', context),
                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
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
                PriceConverter.convertPrice(context, widget.amount+_deliveryCharge),
                style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
              ),
            ]),
          ]),
        ) : SizedBox(),
        if(ResponsiveHelper.isDesktop(context))  confirmButtonWidget(order, _takeAway, address, _kmWiseCharge, _deliveryCharge, context),
      ],
    );

  }



  void _callback(bool isSuccess, String message, String orderID, int addressID) async {
    if(isSuccess) {
      if(widget.fromCart) {
        Provider.of<CartProvider>(context, listen: false).clearCartList();
      }
      Provider.of<OrderProvider>(context, listen: false).stopLoader();

      Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/$orderID/success');

    }else {
      showCustomSnackBar(message, context);
    }
  }

  void _setMarkers(int selectedIndex) async {
    BitmapDescriptor _bitmapDescriptor;
    BitmapDescriptor _bitmapDescriptorUnSelect;

    List<Branches> _branches = Provider.of<SplashProvider>(context, listen: false).configModel.branches;

    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(30, 50)), Images.restaurant_marker).then((_marker) {
      _bitmapDescriptor = _marker;
    });

    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(25, 40)), Images.unselected_restaurant_marker).then((_marker) {
      _bitmapDescriptorUnSelect = _marker;
    });


    // Marker
    _markers = HashSet<Marker>();
    for(int index=0; index < _branches.length; index++) {

      _markers.add(Marker(
        markerId: MarkerId('branch_$index'),
        position: LatLng(double.parse(_branches[index].latitude), double.parse(_branches[index].longitude)),
        infoWindow: InfoWindow(title: _branches[index].name, snippet: _branches[index].address),
        icon: selectedIndex == index ? _bitmapDescriptor : _bitmapDescriptorUnSelect,
      ));
    }


    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
        double.parse(currentBranch.latitude),
        double.parse(currentBranch.longitude),
      ),
      zoom: ResponsiveHelper.isMobile(context) ? 12 : 16,
    )));

    setState(() {});
  }


  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 30}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png)).buffer.asUint8List();
  }

  void _checkPermission(BuildContext context, String navigateTo) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar(getTranslated('you_have_to_allow', context), context);
    }else if(permission == LocationPermission.deniedForever) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => PermissionDialog());
    }else {
      Navigator.pushNamed(context, navigateTo);
    }
  }
}

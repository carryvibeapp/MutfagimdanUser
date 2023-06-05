import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/delivery_option_button.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false).setOrderType(
      Provider.of<SplashProvider>(context, listen: false).configModel.homeDelivery ? 'delivery' : 'take_away', notify: false,
    );
  }
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;


    final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) :CustomAppBar(context: context, title: getTranslated('my_cart', context), isBackButtonExist: !ResponsiveHelper.isMobile(context)),
      body: Consumer<OrderProvider>(
          builder: (context, order, child) {
          return Consumer<CartProvider>(
            builder: (context, cart, child) {
              double deliveryCharge = 0;
              (Provider.of<OrderProvider>(context, listen: false).orderType == 'delivery'
                  && Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.status == 0)
                   ? deliveryCharge = Provider.of<SplashProvider>(context, listen: false).configModel.deliveryCharge : deliveryCharge = 0;
              List<List<AddOns>> _addOnsList = [];
              List<bool> _availableList = [];
              double _itemPrice = 0;
              double _discount = 0;
              double _tax = 0;
              double _addOns = 0;
              cart.cartList.forEach((cartModel) {

                List<AddOns> _addOnList = [];
                cartModel.addOnIds.forEach((addOnId) {
                  for(AddOns addOns in cartModel.product.addOns) {
                    if(addOns.id == addOnId.id) {
                      _addOnList.add(addOns);
                      break;
                    }
                  }
                });
                _addOnsList.add(_addOnList);

                _availableList.add(DateConverter.isAvailable(cartModel.product.availableTimeStarts, cartModel.product.availableTimeEnds, context));

                for(int index=0; index<_addOnList.length; index++) {
                  _addOns = _addOns + (_addOnList[index].price * cartModel.addOnIds[index].quantity);
                }
                _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
                print('_discount $_discount + (cartModel.discountAmount- ${cartModel.discountAmount} * cartModel.quantity ${cartModel.quantity});');
                _discount = _discount + (cartModel.discountAmount * cartModel.quantity);

                _tax = _tax + (cartModel.taxAmount * cartModel.quantity);
              });
              double _subTotal = _itemPrice + _tax + _addOns;
              double _total = _subTotal - _discount - Provider.of<CouponProvider>(context).discount + deliveryCharge;
              double _totalWithoutDeliveryFee = _subTotal - _discount - Provider.of<CouponProvider>(context).discount;

              double _orderAmount = _itemPrice + _addOns;

              bool _kmWiseCharge = Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.status == 1;

              return cart.cartList.length > 0 ? Column(
                children: [

                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                                  child: SizedBox(
                                    width: 1170,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if(ResponsiveHelper.isDesktop(context)) Expanded(child: Padding(
                                          padding:  EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical: Dimensions.PADDING_SIZE_LARGE),
                                          child: CartListWidget(cart: cart,addOns: _addOnsList, availableList: _availableList),
                                        )),
                                        if(ResponsiveHelper.isDesktop(context))  SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                                        Expanded(
                                          child: Container(
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
                                        margin: ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_LARGE) : EdgeInsets.all(0),
                                        padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical: Dimensions.PADDING_SIZE_LARGE) : EdgeInsets.all(0),
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                              // Product
                                              if(!ResponsiveHelper.isDesktop(context)) CartListWidget(cart: cart,addOns: _addOnsList, availableList: _availableList),

                                              // Coupon
                                              Consumer<CouponProvider>(
                                                builder: (context, coupon, child) {
                                                  return Row(children: [
                                                    Expanded(
                                                      child: TextField(
                                                        controller: _couponController,
                                                        style: rubikRegular,
                                                        decoration: InputDecoration(
                                                            hintText: getTranslated('enter_promo_code', context),
                                                            hintStyle: rubikRegular.copyWith(color: ColorResources.getHintColor(context)),
                                                            isDense: true,
                                                            filled: true,
                                                            enabled: coupon.discount == 0,
                                                            fillColor: Theme.of(context).cardColor,
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.horizontal(
                                                                left: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 10 : 0),
                                                                right: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 0 : 10),
                                                              ),
                                                              borderSide: BorderSide.none,
                                                            ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        if(_couponController.text.isNotEmpty && !coupon.isLoading) {
                                                          if(coupon.discount < 1) {
                                                            coupon.applyCoupon(_couponController.text, _total).then((discount) {
                                                              if (discount > 0) {
                                                                showCustomSnackBar('You got ${PriceConverter.convertPrice(context, discount)} discount', context, isError: false);
                                                              } else {
                                                                showCustomSnackBar(getTranslated('invalid_code_or', context), context, isError: true);
                                                              }
                                                            });
                                                          } else {
                                                            coupon.removeCouponData(true);
                                                          }
                                                        } else if(_couponController.text.isEmpty) {
                                                          showCustomSnackBar(getTranslated('enter_a_Coupon_code', context), context);
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 50, width: 100,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(context).primaryColor,
                                                          borderRadius: BorderRadius.horizontal(
                                                            left: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 0 : 10),
                                                            right: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 10 : 0),
                                                          ),
                                                        ),
                                                        child: coupon.discount <= 0 ? !coupon.isLoading ? Text(
                                                          getTranslated('apply', context),
                                                          style: rubikMedium.copyWith(color: Colors.white),
                                                        ) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)) : Icon(Icons.clear, color: Colors.white),
                                                      ),
                                                    ),
                                                  ]);
                                                },
                                              ),
                                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                              // Order type
                                              Text(getTranslated('delivery_option', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                              Provider.of<SplashProvider>(context, listen: false).configModel.homeDelivery?
                                              DeliveryOptionButton(value: 'delivery', title: getTranslated('delivery', context), kmWiseFee: _kmWiseCharge):
                                              Padding(
                                                padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL,top: Dimensions.PADDING_SIZE_LARGE),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.remove_circle_outline_sharp,color: Theme.of(context).hintColor,),
                                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                                    Text(getTranslated('home_delivery_not_available', context),style: TextStyle(fontSize: Dimensions.FONT_SIZE_DEFAULT,color: Theme.of(context).primaryColor)),
                                                  ],
                                                ),
                                              ),
                                              Provider.of<SplashProvider>(context, listen: false).configModel.selfPickup?
                                              DeliveryOptionButton(value: 'take_away', title: getTranslated('take_away', context), kmWiseFee: _kmWiseCharge):
                                              Padding(
                                                padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL,bottom: Dimensions.PADDING_SIZE_LARGE),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.remove_circle_outline_sharp,color: Theme.of(context).hintColor,),
                                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                                    Text(getTranslated('self_pickup_not_available', context),style: TextStyle(fontSize: Dimensions.FONT_SIZE_DEFAULT,color: Theme.of(context).primaryColor)),
                                                  ],
                                                ),
                                              ),


                                              // Total
                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Text(getTranslated('items_price', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                                Text(PriceConverter.convertPrice(context, _itemPrice), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
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
                                              SizedBox(height: 10),

                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Text(getTranslated('discount', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                                Text('(-) ${PriceConverter.convertPrice(context, _discount)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                              ]),
                                              SizedBox(height: 10),

                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Text(getTranslated('coupon_discount', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                                Text(
                                                  '(-) ${PriceConverter.convertPrice(context, Provider.of<CouponProvider>(context).discount)}',
                                                  style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                                ),
                                              ]),
                                              SizedBox(height: 10),

                                              _kmWiseCharge ? SizedBox() : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Text(
                                                  getTranslated('delivery_fee', context),
                                                  style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                                ),
                                                Text(
                                                  '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                                                  style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                                ),
                                              ]),

                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                                                child: CustomDivider(),
                                              ),

                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Text(getTranslated(_kmWiseCharge ? 'subtotal' : 'total_amount', context), style: rubikMedium.copyWith(
                                                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor,
                                                )),
                                                Text(
                                                  PriceConverter.convertPrice(context, _total),
                                                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
                                                ),
                                              ]),
                                              if(ResponsiveHelper.isDesktop(context)) SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                              if(ResponsiveHelper.isDesktop(context)) Container(
                                                width: 1170,
                                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                                child: CustomButton(btnTxt: getTranslated('continue_checkout', context), onTap: () {
                                                  if(_orderAmount < Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue) {
                                                    showCustomSnackBar('Minimum order amount is ${PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false).configModel
                                                        .minimumOrderValue)}, you have ${PriceConverter.convertPrice(context, _orderAmount)} in your cart, please add more item.', context);
                                                  } else {
                                                    Navigator.pushNamed(context, Routes.getCheckoutRoute(
                                                      _totalWithoutDeliveryFee, 'cart', Provider.of<OrderProvider>(context, listen: false).orderType,
                                                      Provider.of<CouponProvider>(context, listen: false).code,
                                                    ));
                                                  }
                                                }),
                                              ),

                                            ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if(ResponsiveHelper.isDesktop(context))  FooterView(),
                          ],
                        ),
                      ),
                    ),
                  ),

                 if(!ResponsiveHelper.isDesktop(context)) Container(
                    width: 1170,
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: CustomButton(btnTxt: getTranslated('continue_checkout', context), onTap: () {
                      if(_orderAmount < Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue) {
                        showCustomSnackBar('Minimum order amount is ${PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false).configModel
                            .minimumOrderValue)}, you have ${PriceConverter.convertPrice(context, _orderAmount)} in your cart, please add more item.', context);
                      } else {
                       Navigator.pushNamed(context, Routes.getCheckoutRoute(
                         _totalWithoutDeliveryFee, 'cart', Provider.of<OrderProvider>(context, listen: false).orderType,
                         Provider.of<CouponProvider>(context, listen: false).code,
                       ));
                      }
                    }),
                  ),

                ],
              ) : NoDataScreen(isCart: true);
            },
          );
        }
      ),
    );
  }
}
class CartListWidget extends StatelessWidget {
  final CartProvider cart;
  final List<List<AddOns>> addOns;
  final List<bool> availableList;
  const CartListWidget({Key key, @required this.cart, @required this.addOns, @required this.availableList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cart.cartList.length,
      itemBuilder: (context, index) {
        return CartProductWidget(cart: cart.cartList[index], cartIndex: index, addOns: addOns[index], isAvailable: availableList[index]);
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/read_more_text.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:provider/provider.dart';

class CartBottomSheet extends StatefulWidget {
  final Product product;
  final bool fromSetMenu;
  final Function callback;
  final CartModel cart;
  final int cartIndex;
  final bool fromCart;

  CartBottomSheet({@required this.product, this.fromSetMenu = false, this.callback, this.cart, this.cartIndex, this.fromCart = false});

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  int _cartIndex;

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).initData(widget.product, widget.cart);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<CartProvider>(
        builder: (context, _cartProvider, child) {
        return Stack(
          children: [
            Container(
              width: 600,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: ResponsiveHelper.isMobile(context)
                    ? BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                    : BorderRadius.all(Radius.circular(20)),
              ),
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  List<Variation> _variationList;
                  double _price;

                  if(widget.product.branchProduct != null && widget.product.branchProduct.isAvailable) {
                    _variationList = widget.product.branchProduct.variations;
                    _price = widget.product.branchProduct.price;

                  }else{
                    _variationList = widget.product.variations;
                    _price = widget.product.price;
                  }



                  double _variationPrice = 0;
                  for(int index = 0; index < _variationList.length; index++) {
                    for(int i=0; i< _variationList[index].variationValues.length; i++) {
                      if(productProvider.selectedVariations[index][i]) {
                        _variationPrice += _variationList[index].variationValues[i].optionPrice;
                      }
                    }
                  }
                  double _discount = widget.product.discount;
                  String _discountType =  widget.product.discountType;
                  double priceWithDiscount = PriceConverter.convertWithDiscount(context, _price, _discount, _discountType);
                  double addonsCost = 0;
                  List<AddOn> _addOnIdList = [];
                  List<AddOns> _addOnsList = [];
                  for (int index = 0; index < widget.product.addOns.length; index++) {
                    if (productProvider.addOnActiveList[index]) {
                      addonsCost = addonsCost + (widget.product.addOns[index].price * productProvider.addOnQtyList[index]);
                      _addOnIdList.add(AddOn(id: widget.product.addOns[index].id, quantity: productProvider.addOnQtyList[index]));
                      _addOnsList.add(widget.product.addOns[index]);
                    }
                  }
                  double priceWithAddonsVariation = addonsCost + (PriceConverter.convertWithDiscount(context, _variationPrice + _price , _discount, _discountType) * productProvider.quantity);
                  double priceWithAddonsVariationWithoutDiscount = ((_price + _variationPrice) * productProvider.quantity) + addonsCost;
                  double priceWithVariation = _price + _variationPrice;
                  bool _isAvailable = DateConverter.isAvailable(widget.product.availableTimeStarts, widget.product.availableTimeEnds,context);


                  CartModel _cartModel = CartModel(
                    priceWithVariation,
                    priceWithDiscount,
                    [],
                    (priceWithVariation - PriceConverter.convertWithDiscount(context, priceWithVariation, _discount, _discountType)),
                    productProvider.quantity,
                    priceWithVariation  - PriceConverter.convertWithDiscount(context, priceWithVariation, widget.product.tax, widget.product.taxType),
                    _addOnIdList,
                    widget.product,
                    productProvider.selectedVariations,
                  );




                  _cartIndex = _cartProvider.getCartIndex(widget.product);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 0 : Dimensions.PADDING_SIZE_EXTRA_LARGE),

                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start, children: [
                              //Product
                               _productView(
                                 context,
                                 _price, priceWithDiscount,
                               ),

                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              // Quantity
                             ResponsiveHelper.isMobile(context) ? Column(
                               children: [
                                 _quantityView(context),
                                 SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                               ],
                             ) : _description(context),


                                  ///Variations
                                  _variationList != null ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _variationList.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                        Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                          Text(_variationList[index].name ?? '', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),

                                          Text(
                                            ' (${_variationList[index].isRequired ? 'required' : 'optional'})',
                                            style: rubikMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_SMALL),
                                          ),
                                        ]),
                                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                        Row(children: [
                                          (_variationList[index].isMultiSelect) ? Text(
                                            '${getTranslated('you_need_to_select_minimum', context)} ${'${_variationList[index].min}'
                                                ' ${getTranslated('to_maximum', context)} ${_variationList[index].max} ${getTranslated('options', context)}'}',
                                            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor),
                                          ) : SizedBox(),
                                        ]),
                                        SizedBox(height: (_variationList[index].isMultiSelect) ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),

                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount: _variationList[index].variationValues.length,
                                          itemBuilder: (context, i) {
                                            return InkWell(
                                              onTap: () {
                                                productProvider.setCartVariationIndex(index, i, widget.product, _variationList[index].isMultiSelect);
                                              },
                                              child: Row(children: [

                                                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

                                                  _variationList[index].isMultiSelect ? Checkbox(
                                                    value: productProvider.selectedVariations[index][i],
                                                    activeColor: Theme.of(context).primaryColor,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                                                    onChanged:(bool newValue) {
                                                      productProvider.setCartVariationIndex(
                                                        index, i, widget.product, _variationList[index].isMultiSelect,
                                                      );
                                                    },
                                                    visualDensity: VisualDensity(horizontal: -3, vertical: -3),
                                                  ) : Radio(
                                                    value: i,
                                                    groupValue: productProvider.selectedVariations[index].indexOf(true),
                                                    onChanged: (value) {
                                                      productProvider.setCartVariationIndex(
                                                        index, i,widget.product, _variationList[index].isMultiSelect,
                                                      );
                                                    },
                                                    activeColor: Theme.of(context).primaryColor,
                                                    toggleable: false,
                                                    visualDensity: VisualDensity(horizontal: -3, vertical: -3),
                                                  ),

                                                  Text(
                                                    _variationList[index].variationValues[i].level.trim(),
                                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                                    style: productProvider.selectedVariations[index][i] ? rubikMedium : robotoRegular,
                                                  ),

                                                ]),

                                                Spacer(),

                                                Text(
                                                  '${_variationList[index].variationValues[i].optionPrice > 0 ? '+'+ PriceConverter.convertPrice(context,  _variationList[index].variationValues[i].optionPrice) : 'free'}',
                                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                                  style: productProvider.selectedVariations[index][i] ? rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)
                                                      : robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor),
                                                ),

                                              ]),
                                            );
                                          },
                                        ),

                                        SizedBox(height: index != _variationList.length - 1 ? Dimensions.PADDING_SIZE_LARGE : 0),
                                      ]);
                                    },
                                  ) : SizedBox(),
                                  SizedBox(height: (_variationList != null && _variationList.length > 0) ? Dimensions.PADDING_SIZE_LARGE : 0),


                             if(ResponsiveHelper.isMobile(context)) _description(context),

                              // Addons
                              _addonsView(context, productProvider),

                              Row(children: [
                                Text('${getTranslated('total_amount', context)}:', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(PriceConverter.convertPrice(context, priceWithAddonsVariation),
                                    style: rubikBold.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                    )),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),

                                (priceWithAddonsVariationWithoutDiscount > priceWithAddonsVariation) ? Text(
                                  '(${PriceConverter.convertPrice(context, priceWithAddonsVariationWithoutDiscount)})',
                                  style: rubikMedium.copyWith(
                                    color: Theme.of(context).disabledColor,
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ) : SizedBox(),
                              ]),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                              //Add to cart Button
                             if(ResponsiveHelper.isDesktop(context)) _cartButton(_isAvailable, context, _cartModel, _variationList),
                            ]),
                          ),
                        ),
                      ),

                      if(!ResponsiveHelper.isDesktop(context)) _cartButton(_isAvailable, context, _cartModel, _variationList),
                    ],
                  );
                },
              ),
            ),
            ResponsiveHelper.isMobile(context)
                ? SizedBox()
                : Positioned(
              right: 10,
              top: 5,
              child: InkWell(onTap: () => Navigator.pop(context), child: Icon(Icons.close)),
            ),
          ],
        );
      }
    );
  }

  Widget _addonsView(BuildContext context, ProductProvider productProvider) {
    return widget.product.addOns.length > 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(getTranslated('addons', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
          childAspectRatio: (1 / 1.1),
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.product.addOns.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (!productProvider.addOnActiveList[index]) {
                productProvider.addAddOn(true, index);
              } else if (productProvider.addOnQtyList[index] == 1) {
                productProvider.addAddOn(false, index);
              }
            },

            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: productProvider.addOnActiveList[index] ? 2 : 20),
              decoration: BoxDecoration(
                color: productProvider.addOnActiveList[index]
                    ? Theme.of(context).primaryColor
                    : ColorResources.BACKGROUND_COLOR,
                borderRadius: BorderRadius.circular(5),
                boxShadow: productProvider.addOnActiveList[index]
                    ? [BoxShadow(
                  color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                  blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                  spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                )]
                    : null,
              ),
              child: Column(children: [
                Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(widget.product.addOns[index].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: rubikMedium.copyWith(
                            color: productProvider.addOnActiveList[index]
                                ? ColorResources.COLOR_WHITE
                                : ColorResources.COLOR_BLACK,
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                          )),
                      SizedBox(height: 5),
                      Text(
                        PriceConverter.convertPrice(context, widget.product.addOns[index].price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: rubikRegular.copyWith(
                            color: productProvider.addOnActiveList[index]
                                ? ColorResources.COLOR_WHITE
                                : ColorResources.COLOR_BLACK,
                            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                      ),
                    ])),
                productProvider.addOnActiveList[index] ? Container(
                  height: 25,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).cardColor),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (productProvider.addOnQtyList[index] > 1) {
                            productProvider.setAddOnQuantity(false, index);
                          } else {
                            productProvider.addAddOn(false, index);
                          }
                        },
                        child: Center(child: Icon(Icons.remove, size: 15)),
                      ),
                    ),
                    Text(productProvider.addOnQtyList[index].toString(),
                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                    Expanded(
                      child: InkWell(
                        onTap: () => productProvider.setAddOnQuantity(true, index),
                        child: Center(child: Icon(Icons.add, size: 15)),
                      ),
                    ),
                  ]),
                )
                    : SizedBox(),
              ]),
            ),
          );
        },
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
    ]) : SizedBox();
  }

  Widget _quantityView(
      BuildContext context,
      ) {
    return Row(children: [
      Text(getTranslated('quantity', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      Expanded(child: SizedBox()),
      _quantityButton(context),
    ]);
  }


  Widget _description(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(getTranslated('description', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      Align(
        alignment: Alignment.topLeft,
        child: ReadMoreText(widget.product.description ?? '',
          trimLines: 2,
          trimCollapsedText: getTranslated('show_more', context),
          trimExpandedText: getTranslated('show_less', context),
          moreStyle: robotoRegular.copyWith(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
          ),
          lessStyle: robotoRegular.copyWith(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
          ),
        ),
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
    ]);
  }

  Widget _cartButton(bool _isAvailable, BuildContext context, CartModel _cartModel, List<Variation> variationList) {
    return Column(children: [
      _isAvailable ? SizedBox() :
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
        child: Column(children: [
          Text(getTranslated('not_available_now', context),
              style: rubikMedium.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Dimensions.FONT_SIZE_LARGE,
              )),
          Text(
            '${getTranslated('available_will_be', context)} ${DateConverter.convertTimeToTime(widget.product.availableTimeStarts, context)} '
                '- ${DateConverter.convertTimeToTime(widget.product.availableTimeEnds, context)}',
            style: rubikRegular,
          ),
        ]),
      ),

      CustomButton(
          btnTxt: getTranslated(
             _cartIndex != -1
                ? 'update_in_cart'
                : 'add_to_cart', context,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            final productProvider = Provider.of<ProductProvider>(context, listen: false);
            if(variationList != null){
              for(int index=0; index<variationList.length; index++) {
                if(!variationList[index].isMultiSelect && variationList[index].isRequired
                    && !productProvider.selectedVariations[index].contains(true)) {
                  showCustomSnackBar('${getTranslated('choose_a_variation_from', context)} ${variationList[index].name}', context, isToast: true, isError: true);
                  return;
                }else if(variationList[index].isMultiSelect && (variationList[index].isRequired
                    || productProvider.selectedVariations[index].contains(true)) && variationList[index].min
                    > productProvider.selectedVariationLength(productProvider.selectedVariations, index)) {
                  showCustomSnackBar('${getTranslated('you_need_to_select_minimum', context)} ${variationList[index].min} '
                      '${getTranslated('to_maximum', context)} ${variationList[index].max} ${getTranslated('options_from', context)
                  } ${variationList[index].name} ${getTranslated('variation', context)}', context,isError: true, isToast: true);
                  return;
                }
              }
            }

            Navigator.pop(context);
            Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel,_cartIndex);
          }
      ),
    ]);
  }

  Widget _productView(
      BuildContext context,double price,
      double priceWithDiscount,
      ) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage.assetNetwork(
          placeholder: Images.placeholder_rectangle,
          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${widget.product.image}',
          width: ResponsiveHelper.isMobile(context)
              ? 100
              : ResponsiveHelper.isTab(context)
              ? 140
              : ResponsiveHelper.isDesktop(context)
              ? 140
              : null,
          height: ResponsiveHelper.isMobile(context)
              ? 100
              : ResponsiveHelper.isTab(context)
              ? 140
              : ResponsiveHelper.isDesktop(context)
              ? 140
              : null,
          fit: BoxFit.cover,
          imageErrorBuilder: (c, o, s) => Image.asset(
            Images.placeholder_rectangle,
            width: ResponsiveHelper.isMobile(context)
                ? 100
                : ResponsiveHelper.isTab(context)
                ? 140
                : ResponsiveHelper.isDesktop(context)
                ? 140
                : null,
            height: ResponsiveHelper.isMobile(context)
                ? 100
                : ResponsiveHelper.isTab(context)
                ? 140
                : ResponsiveHelper.isDesktop(context)
                ? 140
                : null,
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
              ),

             if(!ResponsiveHelper.isMobile(context)) WishButton(product: widget.product),



            ],
          ),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RatingBar(rating: widget.product.rating.length > 0 ? double.parse(widget.product.rating[0].average) : 0.0, size: 15),
              widget.product.productType != null ? VegTagView(product: widget.product) : SizedBox(),
            ],
          ),
          SizedBox(height: 20),

          Row( mainAxisSize: MainAxisSize.min, children: [
            Expanded(
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,  children: [
                FittedBox(
                  child: Text(
                    '${PriceConverter.convertPrice(context, price, discount: widget.product.discount, discountType: widget.product.discountType)}',
                    style: rubikMedium.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                      overflow: TextOverflow.ellipsis,
                      color: Theme.of(context).primaryColor,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),


                price > priceWithDiscount ? FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(PriceConverter.convertPrice(context, price),
                      style: rubikMedium.copyWith(color: ColorResources.COLOR_GREY, decoration: TextDecoration.lineThrough, overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                  ),
                ) : SizedBox(),

              ]),
            ),
           if(ResponsiveHelper.isMobile(context)) WishButton(product: widget.product),

          ]),
          if(!ResponsiveHelper.isMobile(context)) _quantityView(context)
        ]),
      ),
    ]);
  }

  Widget _quantityButton(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(5)),
      child: Row(children: [
        InkWell(
          onTap: () => productProvider.quantity > 1 ?  productProvider.setQuantity(false) : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Icon(Icons.remove, size: 20),
          ),
        ),
        Text(productProvider.quantity.toString(), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),

        InkWell(
          onTap: () => productProvider.setQuantity(true),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Icon(Icons.add, size: 20),
          ),
        ),
      ]),
    );
  }
}

class VegTagView extends StatelessWidget {
  final Product product;
  const VegTagView({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [BoxShadow(blurRadius: 5, color: Theme.of(context).backgroundColor.withOpacity(0.05))],
      ),

      child: SizedBox(height:  30,
        child: Row(
          children: [
            Padding(
              padding:  EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Image.asset(
                Images.getImageUrl('${product.productType}',
                ), fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

            Text(
              getTranslated('${product.productType}', context),
              style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          ],
        ),
      ),
    );
  }
}


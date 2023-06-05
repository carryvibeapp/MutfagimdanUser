import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: TitleWidget(title: getTranslated('banner', context)),
        ),

        SizedBox(
          height: 85,
          child: Consumer<BannerProvider>(
            builder: (context, banner, child) {
              return banner.bannerList != null ? banner.bannerList.length > 0 ? ListView.builder(
                itemCount: banner.bannerList.length,
                padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Consumer<CartProvider>(
                      builder: (context, _cartProvider, child) {
                      return InkWell(
                        onTap: () {
                          if(banner.bannerList[index].productId != null) {
                            Product product;
                            for(Product prod in banner.productList) {
                              if(prod.id == banner.bannerList[index].productId) {
                                product = prod;
                                break;
                              }
                            }
                            if(product != null) {
                              int _cartIndex =   _cartProvider.getCartIndex(product);
                              ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (con) => CartBottomSheet(
                                  product: product, cart:  _cartIndex == null || _cartIndex == -1 ? null : _cartProvider.cartList[_cartIndex],
                                  callback: (CartModel cartModel) {
                                    showCustomSnackBar(getTranslated('added_to_cart', context), context,isError: false);
                                  },
                                ),
                              ): showDialog(context: context, builder: (con) => Dialog(
                                child: CartBottomSheet(
                                  product: product, cart:  _cartIndex == null || _cartIndex == -1 ? null : _cartProvider.cartList[_cartIndex],
                                  callback: (CartModel cartModel) {
                                    showCustomSnackBar(getTranslated('added_to_cart', context), context,isError: false);
                                  },
                                ),
                              ));

                            }

                          }else if(banner.bannerList[index].categoryId != null) {
                            CategoryModel category;
                            for(CategoryModel categoryModel in Provider.of<CategoryProvider>(context, listen: false).categoryList) {
                              if(categoryModel.id == banner.bannerList[index].categoryId) {
                                category = categoryModel;
                                break;
                              }
                            }
                            if(category != null) {
                              Navigator.pushNamed(context, Routes.getCategoryRoute(category));
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(
                              color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                              blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                              spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                            )],
                            color: ColorResources.COLOR_WHITE,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder_banner, width: 250, height: 85, fit: BoxFit.cover,
                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl}/${banner.bannerList[index].image}',
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_banner, width: 250, height: 85, fit: BoxFit.cover),
                            ),
                          ),
                        )
                      );
                    }
                  );
                },
              ) : Center(child: Text(getTranslated('no_banner_available', context))) : BannerShimmer();
            },
          ),
        ),
      ],
    );
  }
}

class BannerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Shimmer(
          duration: Duration(seconds: 2),
          enabled: Provider.of<BannerProvider>(context).bannerList == null,
          child: Container(
            width: 250, height: 85,
            margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
              )],
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';

class ProductView extends StatelessWidget {
  final ProductType productType;
  final ScrollController scrollController;
  ProductView({@required this.productType, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final _productProvider = Provider.of<ProductProvider>(context, listen: false);

    if(!ResponsiveHelper.isDesktop(context) && productType == ProductType.LATEST_PRODUCT) {
      scrollController?.addListener(() {

        if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            (_productProvider.latestProductList != null) && !_productProvider.isLoading
        ) {
          int pageSize;
          if (productType == ProductType.LATEST_PRODUCT) {
            pageSize = (_productProvider.latestPageSize / 10).ceil();
          }
          if (_productProvider.latestOffset < pageSize) {
            _productProvider.latestOffset ++;
            _productProvider.showBottomLoader();
            if(productType == ProductType.LATEST_PRODUCT) {
              _productProvider.getLatestProductList(
                context, false, _productProvider.latestOffset.toString(),
                Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
              );
            }

          }
        }
      });

    }
    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList;
        if (productType == ProductType.LATEST_PRODUCT) {
          productList = prodProvider.latestProductList;
        }
        else if (productType == ProductType.POPULAR_PRODUCT) {
          productList = prodProvider.popularProductList;
        }
        if(productList == null ) {
          return productType == ProductType.POPULAR_PRODUCT ?
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  width: 195,
                  child: ProductWidgetWebShimmer(),
                );},
            ),
          ) :
          GridView.builder(
            shrinkWrap: true,
            gridDelegate:ResponsiveHelper.isDesktop(context) ? SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 4,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
            ),
            itemCount: 12,
            itemBuilder: (BuildContext context, int index) {
              return ResponsiveHelper.isDesktop(context) ? ProductWidgetWebShimmer() : ProductShimmer(isEnabled: productList == null);
              },
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
          );
        }
        if(productList.length == 0) {
          return SizedBox();
        }

        return productType == ProductType.POPULAR_PRODUCT
            ? SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    width: 195,
                    child: ProductWidgetWeb(product: productList[index], fromPopularItem: true),
                  );
                },
              ),
        ) :
        Column(children: [

          GridView.builder(
            gridDelegate: ResponsiveHelper.isDesktop(context)
                ? SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 3.5,
              crossAxisCount: ResponsiveHelper.isTab(context) ? 2 : 1,
            ),
            itemCount: productList.length,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ResponsiveHelper.isDesktop(context) ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: ProductWidgetWeb(product: productList[index]),
              ) : ProductWidget(product: productList[index]);
            },
          ),
          SizedBox(height: 30),

          productList != null ? Padding(
            padding: ResponsiveHelper.isDesktop(context)? const EdgeInsets.only(top: 40,bottom: 70) :  const EdgeInsets.all(0),
            child: ResponsiveHelper.isDesktop(context) ?
            prodProvider.isLoading ? Center(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
              ),
            ) : (_productProvider.latestOffset == (Provider.of<ProductProvider>(context, listen: false).latestPageSize / 10).ceil())
                ? SizedBox() :
            SizedBox(
              width: 500,
              child: ElevatedButton(
                style : ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: (){
                  _productProvider.moreProduct(context);
                  },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(getTranslated('see_more', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_OVER_LARGE)),
                ),
              ),
            ) : prodProvider.isLoading
                ? Center(child: Padding(padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,)),
            )) : SizedBox.shrink(),
          ) : SizedBox.shrink(),
        ]);
      },
    );
  }
}

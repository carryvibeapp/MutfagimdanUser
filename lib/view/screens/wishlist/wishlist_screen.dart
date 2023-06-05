import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  bool _isLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<WishListProvider>(context, listen: false).initWishList(
        context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : CustomAppBar(context: context, title: getTranslated('my_favourite', context), isBackButtonExist: !ResponsiveHelper.isMobile(context)),
      body: _isLoggedIn ? Consumer<WishListProvider>(
        builder: (context, wishlistProvider, child) {
          return !wishlistProvider.isLoading ? !wishlistProvider.isLoading && wishlistProvider.wishIdList.length > 0  ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<WishListProvider>(context, listen: false).initWishList(
                context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
              );
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1, vertical:  Dimensions.PADDING_SIZE_DEFAULT),
                          child: SizedBox(
                            width: 1170,
                            child:  GridView.builder(
                              gridDelegate: ResponsiveHelper.isDesktop(context) ? SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
                              SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 4,crossAxisCount: ResponsiveHelper.isTab(context) ? 2 : 1),
                              itemCount: wishlistProvider.wishList.length,
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return ResponsiveHelper.isDesktop(context) ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ProductWidgetWeb(product: wishlistProvider.wishList[index]),
                                ) : ProductWidget(product: wishlistProvider.wishList[index]);
                              },
                            )
                          ),
                        ),
                      ),
                    ),
                    if(ResponsiveHelper.isDesktop(context)) FooterView(),
                  ],
                ),
              ),
            ),
          ): NoDataScreen()
            : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : NotLoggedInScreen(),
    );
  }
}

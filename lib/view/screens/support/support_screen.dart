import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : CustomAppBar(context: context, title: getTranslated('help_and_support', context)),
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    child: Container(
                      width: _width > 700 ? 700 : _width,
                      padding: _width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                      decoration: _width > 700 ? BoxDecoration(
                        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                      ) : null,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Align(alignment: Alignment.center, child: Image.asset(Images.support,height: 300,width: 300,)),
                        SizedBox(height: 20),

                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 25),
                          Text(getTranslated('restaurant_address', context), style: rubikMedium),
                        ]),
                        SizedBox(height: 10),

                        Text(
                          Provider.of<SplashProvider>(context, listen: false).configModel.restaurantAddress,
                          style: rubikRegular, textAlign: TextAlign.center,
                        ),
                        Divider(thickness: 2),
                        SizedBox(height: 50),

                        Padding(
                          padding: ResponsiveHelper.isDesktop(context) ?  const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE) : EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Row(children: [
                            Expanded(child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                                minimumSize: Size(1, 50),
                              ),
                              onPressed: () {
                                launchUrl(Uri.parse('tel:${Provider.of<SplashProvider>(context, listen: false).configModel.restaurantPhone}'));
                              },
                              child: Text(getTranslated('call_now', context), style: Theme.of(context).textTheme.headline3.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                              )),
                            )),
                            SizedBox(width: 10),
                            Expanded(child: SizedBox(
                              height: 50,
                              child: CustomButton(
                                btnTxt: getTranslated('send_a_message', context),
                                onTap: () async {
                                  Navigator.pushNamed(context, Routes.getChatRoute(orderModel: null));
                                },
                              ),
                            )),
                          ]),
                        ),

                      ]),
                    ),
                  ),
                ),
              ),
              if(ResponsiveHelper.isDesktop(context)) FooterView(),
            ],
          ),
        ),
      ),
    );
  }
}

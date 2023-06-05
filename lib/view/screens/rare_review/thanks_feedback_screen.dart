import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';

class ThanksFeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : null,
      body: Center(
        child: Container(
          width: 1170,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Images.done_with_full_background,
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 60),
                Text(
                  getTranslated('thanks_for_your_order', context),
                  style: Theme.of(context).textTheme.headline3.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                        color: ColorResources.getGreyBunkerColor(context),
                      ),
                ),
                SizedBox(height: 23),
                Text(
                  getTranslated('it_will_helps_to_improve', context),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2.copyWith(
                        color: ColorResources.getGreyBunkerColor(context).withOpacity(.75),
                      ),
                ),
                SizedBox(height: 50),
                CustomButton(
                  btnTxt: getTranslated('back_home', context),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, Routes.getMainRoute());
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/menu/web/menu_screen_web.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/options_view.dart';

import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  final Function onTap;
  MenuScreen({ this.onTap});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}
bool _isLoggedIn = false;

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<ProfileProvider>(context,listen: false).getUserInfo(context);
    }
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : null,
      body: ResponsiveHelper.isDesktop(context) ? MenuScreenWeb() : Column(children: [
        Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => Center(
            child: Container(
              width: 1170,
              padding: EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Container(
                  height: 80, width: 80,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ColorResources.COLOR_WHITE, width: 2)),
                  child: ClipOval(
                    child: _isLoggedIn ? FadeInImage.assetNetwork(
                      placeholder: Images.placeholder_user, height: 80, width: 80, fit: BoxFit.cover,
                      image: '${Provider.of<SplashProvider>(context,).baseUrls.customerImageUrl}/'
                          '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.image : ''}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_user, height: 80, width: 80, fit: BoxFit.cover),
                    ) : Image.asset(Images.placeholder_user, height: 80, width: 80, fit: BoxFit.cover),
                  ),
                ),
                Column(children: [
                  SizedBox(height: 20),
                  _isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                    '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                    style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.COLOR_WHITE),
                  ) : Container(height: 15, width: 150, color: Colors.white) : Text(
                    getTranslated('guest', context),
                    style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.COLOR_WHITE),
                  ),
                  SizedBox(height: 10),
                  _isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                    '${profileProvider.userInfoModel.email ?? ''}',
                    style: rubikRegular.copyWith(color: ColorResources.BACKGROUND_COLOR),
                  ) : Container(height: 15, width: 100, color: Colors.white) : Text(
                    'demo@demo.com',
                    style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.COLOR_WHITE),
                  ),

                ]),
              ]),
            ),
          ),
        ),
        Expanded(child: OptionsView(onTap: widget.onTap)),
      ]),
    );
  }
}

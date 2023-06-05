import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:provider/provider.dart';

import '../../../base/custom_dialog.dart';

class OptionsView extends StatelessWidget {
  final Function onTap;
  OptionsView({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final _policyModel = Provider.of<SplashProvider>(context, listen: false).policyModel;
    final _configModel = Provider.of<SplashProvider>(context, listen: false).configModel;


    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: BouncingScrollPhysics(),
      child: Center(
        child: SizedBox(
          width: ResponsiveHelper.isTab(context) ? null : 1170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: ResponsiveHelper.isTab(context) ? 50 : 0),

              SwitchListTile(
                value: Provider.of<ThemeProvider>(context).darkTheme,
                onChanged: (bool isActive) =>Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                title: Text(getTranslated('dark_theme', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                activeColor: Theme.of(context).primaryColor,
              ),

              ResponsiveHelper.isTab(context) ? ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('home')),
                leading: Image.asset(Images.home, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated('home', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ) : SizedBox(),

              ListTile(
                onTap: () => ResponsiveHelper.isMobilePhone() ? onTap(2) : Navigator.pushNamed(context, Routes.getDashboardRoute('order')),
                leading: Image.asset(Images.order, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated('my_order', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ListTile(
                onTap: () =>  Navigator.pushNamed(context, Routes.getProfileRoute()),
                leading: Image.asset(Images.profile, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated('profile', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.getAddressRoute()),
                leading: Image.asset(Images.location, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated('address', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.getChatRoute(orderModel: null)),
                leading: Image.asset(Images.message, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated('message', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.getCouponRoute()),
                leading: Image.asset(Images.coupon, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated('coupon', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ResponsiveHelper.isDesktop(context) ? ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.getNotificationRoute()),
                leading: Image.asset(Images.notification, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated('notifications', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ) : SizedBox(),
              ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.getLanguageRoute('menu')),
                leading: Image.asset(Images.language, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated('language', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.getSupportRoute()),
                leading: Container(width:20,height: 20,child: Image.asset(Images.help_support,color: ColorResources.getWhiteAndBlack(context),)),
                title: Text(getTranslated('help_and_support', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.getPolicyRoute()),
                leading: Container(width:20,height: 20,child: Image.asset(Images.privacy_policy,color: ColorResources.getWhiteAndBlack(context),)),
                title: Text(getTranslated('privacy_policy', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.getTermsRoute()),
                leading: Container(width:20,height: 20,child: Image.asset(Images.terms_and_condition,color: ColorResources.getWhiteAndBlack(context),)),
                title: Text(getTranslated('terms_and_condition', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),

              if(_policyModel != null && _policyModel.returnPage != null && _policyModel.returnPage.status) ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.getReturnPolicyRoute()),
                leading: Image.asset(Images.returnPolicy, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated('return_policy', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),

              if(_policyModel != null && _policyModel.refundPage != null  && _policyModel.refundPage.status) ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.getRefundPolicyRoute()),
                leading: Image.asset(Images.refundPolicy, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated('refund_policy', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              if(_policyModel != null && _policyModel.cancellationPage != null  && _policyModel.cancellationPage.status) ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.getCancellationPolicyRoute()),
                leading: Image.asset(Images.cancellationPolicy, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated('cancellation_policy', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),

              ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.getAboutUsRoute()),
                leading: Container(width:20,height: 20,child: Image.asset(Images.about_us,color: ColorResources.getWhiteAndBlack(context),)),
                title: Text(getTranslated('about_us', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),

             if(_configModel.referEarnStatus && _isLoggedIn) Consumer<ProfileProvider>(
               builder: (context, profileProvider, _) {
                 return profileProvider.userInfoModel != null && profileProvider.userInfoModel.referCode != null ? ListTile(
                   onTap: () =>  Navigator.pushNamed(context, Routes.getReferAndEarnRoute()),
                   leading: Image.asset(Images.referral_icon, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                    title: Text(getTranslated('refer_and_earn', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ) : SizedBox() ;
               }
             ),

              if(_configModel.walletStatus) ListTile(
                onTap: () =>  Navigator.pushNamed(context, Routes.getWalletRoute(true)),
                leading: Image.asset(Images.wallet, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated('wallet', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),

              if(_configModel.loyaltyPointStatus) ListTile(
                onTap: () =>  Navigator.pushNamed(context, Routes.getWalletRoute(false)),
                leading: Image.asset(Images.loyalty_icon, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(0.6)),
                title: Text(getTranslated('loyalty_point', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),

              ListTile(
                leading: Image.asset(Images.version, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text('${getTranslated('version', context)}', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                trailing: Text('${Provider.of<SplashProvider>(context, listen: false).configModel.softwareVersion ?? ''}', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                //
              ),

              _isLoggedIn ? ListTile(
                onTap: () {
                  showAnimatedDialog(context,
                      Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                          return WillPopScope(
                            onWillPop: () async => !authProvider.isLoading,
                            child: authProvider.isLoading ? Center(child: CircularProgressIndicator()) : CustomDialog(
                              icon: Icons.question_mark_sharp,
                              title: getTranslated('are_you_sure_to_delete_account', context),
                              description: getTranslated('it_will_remove_your_all_information', context),
                              buttonTextTrue: getTranslated('yes', context),
                              buttonTextFalse: getTranslated('no', context),
                              onTapTrue: () => Provider.of<AuthProvider>(context, listen: false).deleteUser(context),
                              onTapFalse: () => Navigator.of(context).pop(),
                            )
                          );
                        }
                      ),
                      dismissible: false,
                      isFlip: true);
                },
                leading: Icon(Icons.delete_outline, size: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated('delete_account', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ) : SizedBox(),

              ListTile(
                onTap: () {
                  if(_isLoggedIn) {
                    showDialog(context: context, barrierDismissible: false, builder: (context) => SignOutConfirmationDialog());
                  }else {
                    Navigator.pushNamed(context, Routes.getLoginRoute());
                  }
                },
                leading: Image.asset(Images.login, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge.color),
                title: Text(getTranslated(_isLoggedIn ? 'logout' : 'login', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

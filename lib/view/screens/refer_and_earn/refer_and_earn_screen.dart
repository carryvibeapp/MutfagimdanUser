import 'package:dotted_border/dotted_border.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/refer_and_earn/widget/refer_hint_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({Key key}) : super(key: key);

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final List<String> shareItem = ['messenger', 'whatsapp', 'gmail', 'viber', 'share' ];
  final List<String> hintList = [
    getTranslated('invite_your_friends', Get.context),
    '${getTranslated('they_register', Get.context)} ${AppConstants.APP_NAME} ${getTranslated('with_special_offer', Get.context)}',
    getTranslated('you_made_your_earning', Get.context),
  ];
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100))
          : CustomAppBar(context: context, title: getTranslated('refer_and_earn', context)),

      body: _isLoggedIn ? Center(child: ExpandableBottomSheet(
        background: SingleChildScrollView(
          padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT,
            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          ),
          child: Column(
            children: [
              SizedBox(
                width: ResponsiveHelper.isDesktop(context) ?  750 : double.maxFinite,
                child: Consumer<ProfileProvider>(
                  builder: (context, profileProvider, _) {
                    return profileProvider.userInfoModel != null ? Column(
                      children: [
                        Image.asset(Images.refer_banner, height: _size.height * 0.3),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

                        Text(
                          getTranslated('invite_friend_and_businesses', context),
                          textAlign: TextAlign.center,
                          style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                            color: Theme.of(context).textTheme.bodyLarge.color,
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

                        Text(
                          getTranslated('copy_your_code', context),
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

                        Text(
                          getTranslated('your_personal_code', context),
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            fontWeight: FontWeight.w200,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),

                        DottedBorder(
                          padding: EdgeInsets.all(4),
                          borderType: BorderType.RRect,
                          radius: Radius.circular(20),
                          dashPattern: [5, 5],
                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                          strokeWidth: 2,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                  child: Text('${profileProvider.userInfoModel.referCode ?? ''}',
                                    style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                  ),
                                ),

                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {

                                    if(profileProvider.userInfoModel.referCode != null && profileProvider.userInfoModel.referCode  != ''){
                                      Clipboard.setData(ClipboardData(text: '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.referCode : ''}'));
                                      showCustomSnackBar(getTranslated('referral_code_copied', context), context, isError: false);
                                    }
                                  },
                                  child: Container(
                                    width: 85,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: Text(getTranslated('copy', context),style: rubikRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Colors.white.withOpacity(0.9),
                                    )),
                                  ),
                                ),

                              ]),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),

                        Text(
                          getTranslated('or_share', context),
                          style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                        ),

                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: shareItem.map((_item) => InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => Share.share(profileProvider.userInfoModel.referCode),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Image.asset(
                                  Images.getShareIcon(_item), height: 50, width: 50,
                                ),
                              ),
                            )).toList(),),
                        ),

                        if(ResponsiveHelper.isDesktop(context))
                         Column(children: [
                           SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                           ReferHintView(hintList: hintList),
                           SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                         ]),


                      ],
                    ) : SizedBox();
                  }
                ),
              ),

              if(ResponsiveHelper.isDesktop(context)) FooterView(),
            ],
          ),
        ),
        persistentContentHeight: MediaQuery.of(context).size.height * 0.2,
        expandableContent: ResponsiveHelper.isDesktop(context) ? SizedBox() : ReferHintView(hintList: hintList),
      )) : NotLoggedInScreen(),
    );
  }
}

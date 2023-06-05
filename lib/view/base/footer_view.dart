import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/news_letter_controller.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterView extends StatelessWidget {
  const FooterView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _newsLetterController = TextEditingController();
    return Container(
      color: ColorResources.getFooterColor(context),
      width: double.maxFinite,
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: Dimensions.WEB_SCREEN_WIDTH,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE ),
                          FittedBox(
                            child: Text(Provider.of<SplashProvider>(context).configModel.restaurantName ?? AppConstants.APP_NAME, maxLines: 1,
                              style: TextStyle(fontWeight: FontWeight.w800,fontSize: 48,color: Theme.of(context).primaryColor),),
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Text(getTranslated('news_letter', context), style: robotoRegular.copyWith(fontWeight: FontWeight.w600, color: ColorResources.getGreyBunkerColor(context))),

                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Text(getTranslated('subscribe_to_our', context), style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: ColorResources.getGreyBunkerColor(context))),

                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                          Container(
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorResources.COLOR_BLACK.withOpacity(0.05),
                                    blurRadius: 2,
                                  )
                                ]
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 20),
                                Expanded(child: TextField(
                                  controller: _newsLetterController,
                                  style: rubikMedium.copyWith(color: ColorResources.COLOR_BLACK),
                                  decoration: InputDecoration(
                                    hintText: getTranslated('your_email_address', context),
                                    hintStyle: rubikRegular.copyWith(color: ColorResources.getGreyColor(context),fontSize: Dimensions.FONT_SIZE_LARGE),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: 1,

                                )),
                                InkWell(
                                  onTap: (){
                                    String email = _newsLetterController.text.trim().toString();
                                    if (email.isEmpty) {
                                      showCustomSnackBar(getTranslated('enter_email_address', context), context);
                                    }else if (EmailChecker.isNotValid(email)) {
                                      showCustomSnackBar(getTranslated('enter_valid_email', context), context);
                                    }else{
                                      Provider.of<NewsLetterProvider>(context, listen: false).addToNewsLetter(context, email).then((value) {
                                        _newsLetterController.clear();
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                    child: Text(getTranslated('subscribe', context), style: rubikRegular.copyWith(color: Colors.white,fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                          // const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                          Consumer<SplashProvider>(
                              builder: (context, splashProvider, child) {
                                final _isLtr = Provider.of<LocalizationProvider>(context, listen: false).isLtr;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(splashProvider.configModel.socialMediaLink.length != null && splashProvider.configModel.socialMediaLink.length > 0)  Text(getTranslated('follow_us_on', context), style: rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                                    Container(height: 50,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: splashProvider.configModel.socialMediaLink.length,
                                        itemBuilder: (BuildContext context, index){
                                          String name = splashProvider.configModel.socialMediaLink[index].name;
                                          String icon;
                                          if(name=='facebook'){

                                            icon = Images.facebook_icon;
                                          }else if(name=='linkedin'){
                                            icon = Images.linked_in_icon;
                                          } else if(name=='youtube'){
                                            icon = Images.youtube_icon;
                                          }else if(name=='twitter'){
                                            icon = Images.twitter_icon;
                                          }else if(name=='instagram'){
                                            icon = Images.in_sta_gram_icon;
                                          }else if(name=='pinterest'){
                                            icon = Images.pinterest;
                                          }
                                          return  splashProvider.configModel.socialMediaLink.length > 0 ?
                                          InkWell(
                                            onTap: (){
                                              _launchURL(splashProvider.configModel.socialMediaLink[index].link);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only( left: _isLtr && index  == 0 ? 0 : 4, right: !_isLtr && index == 0 ? 0 : 4),
                                              child: Image.asset(icon,height: Dimensions.PADDING_SIZE_EXTRA_LARGE,width: Dimensions.PADDING_SIZE_EXTRA_LARGE,fit: BoxFit.contain),
                                            ),
                                          ):SizedBox();

                                        },),
                                    ),
                                  ],
                                );
                              }
                          ),

                        ],
                      )),
                  Provider.of<SplashProvider>(context, listen: false).configModel.playStoreConfig.status || Provider.of<SplashProvider>(context, listen: false).configModel.appStoreConfig.status?
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE * 2),
                        Text( Provider.of<SplashProvider>(context, listen: false).configModel.playStoreConfig.status && Provider.of<SplashProvider>(context, listen: false).configModel.appStoreConfig.status
                            ? getTranslated('download_our_apps', context) : getTranslated('download_our_app', context), style: rubikBold.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.FONT_SIZE_LARGE)),
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Provider.of<SplashProvider>(context, listen: false).configModel.playStoreConfig.status?
                            InkWell(onTap:(){
                              _launchURL(Provider.of<SplashProvider>(context, listen: false).configModel.playStoreConfig.link);
                            },child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Image.asset(Images.play_store,height: 50,fit: BoxFit.contain),
                            )):SizedBox(),
                            Provider.of<SplashProvider>(context, listen: false).configModel.appStoreConfig.status?
                            InkWell(onTap:(){
                              _launchURL(Provider.of<SplashProvider>(context, listen: false).configModel.appStoreConfig.link);
                            },child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Image.asset(Images.app_store,height: 50,fit: BoxFit.contain),
                            )):SizedBox(),
                          ],)
                      ],
                    ),
                  ) : SizedBox(),
                  Expanded(flex: 2,child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE * 2),
                      Text(getTranslated('my_account', context), style: rubikBold.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, Routes.getProfileRoute());
                                },
                                child: Text(getTranslated('profile', context), style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, Routes.getAddressRoute());
                                },
                                child: Text(getTranslated('address', context), style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, Routes.getChatRoute(orderModel: null));
                                },
                                child: Text(getTranslated('live_chat', context), style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, Routes.getDashboardRoute('order'));
                                },
                                child: Text(getTranslated('my_order', context), style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),

                    ],)),
                  Expanded(flex: 2,child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE * 2),
                      Text(getTranslated('quick_links', context), style: rubikBold.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: () =>  Navigator.pushNamed(context, Routes.getSupportRoute()),
                                child: Text(getTranslated('contact_us', context), style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: () => Navigator.pushNamed(context, Routes.getPolicyRoute()),
                                child: Text(getTranslated('privacy_policy', context), style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: () => Navigator.pushNamed(context, Routes.getTermsRoute()),
                                child: Text(getTranslated('terms_and_condition', context), style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: () => Navigator.pushNamed(context, Routes.getAboutUsRoute()),
                                child: Text(getTranslated('about_us', context), style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),

                    ],)),
                ],
              ),
            ),
            Divider(thickness: .5),
            SizedBox(
              width: 500.0,
              child: Text(Provider.of<SplashProvider>(context,listen: false).configModel.footerCopyright ??
                  '${getTranslated('copyright', context)} ${Provider.of<SplashProvider>(context,listen: false).configModel.restaurantName}',
                  overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: TextAlign.center),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT)
          ],
        ),
      ),
    );
  }
}
_launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}
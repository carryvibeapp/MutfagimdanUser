import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class CookiesView extends StatelessWidget {
  const CookiesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width  = MediaQuery.of(context).size.width;
    double _padding = (_width - Dimensions.WEB_SCREEN_WIDTH) / 2;
    return Consumer<SplashProvider>(
      builder: (context, splashProvide, _) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.RADIUS_DEFAULT),
                topRight: Radius.circular(Dimensions.RADIUS_DEFAULT),
              )),

             padding: EdgeInsets.symmetric(
               vertical: Dimensions.PADDING_SIZE_DEFAULT,
               horizontal: ResponsiveHelper.isDesktop(context) ? _padding : Dimensions.PADDING_SIZE_SMALL,
             ),

              child: SizedBox(width: Dimensions.WEB_SCREEN_WIDTH, child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Text(
                          getTranslated('your_privacy_matters', context),
                          style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,color: Colors.white),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                        Text(splashProvide.configModel.cookiesManagement.content ?? "",
                          style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white70),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      ]),

                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(80,40),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: ()=>  splashProvide.cookiesStatusChange(null),
                          child:  Text(getTranslated('no_thanks', context), style: poppinsRegular.copyWith(
                          color: Colors.white70, fontSize: Dimensions.FONT_SIZE_SMALL)),
                        ),
                        SizedBox(width: ResponsiveHelper.isDesktop(context)?Dimensions.PADDING_SIZE_EXTRA_LARGE:Dimensions.PADDING_SIZE_LARGE,),


                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: EdgeInsets.zero,
                            minimumSize: Size(80, 40),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: (){
                            splashProvide.cookiesStatusChange(splashProvide.configModel.cookiesManagement.content);
                          },
                          child:  Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                              ),
                              child: Center(child: Text(getTranslated('yes_accept', context), style: poppinsRegular.copyWith(
                                color: Colors.white70,fontSize: Dimensions.FONT_SIZE_SMALL,
                              )),
                            )),
                        ),

                      ]),


                    ],
                  )),
            ),
          ),
        );
      }
    );
  }
}
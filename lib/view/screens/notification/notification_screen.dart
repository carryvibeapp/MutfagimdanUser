import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/notification_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/screens/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : CustomAppBar(context: context, title: getTranslated('notification', context)),
      body: Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) {
            List<DateTime> _dateTimeList = [];
            return notificationProvider.notificationList != null ? notificationProvider.notificationList.length > 0 ? RefreshIndicator(
              onRefresh: () async {
                await Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ?  Dimensions.PADDING_SIZE_LARGE : 0.0),
                        child: Center(
                          child: Container(
                            constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                            width: _width > Dimensions.WEB_SCREEN_WIDTH ? Dimensions.WEB_SCREEN_WIDTH : _width,
                            padding: _width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,

                            child: ListView.builder(
                                itemCount: notificationProvider.notificationList.length,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  DateTime _originalDateTime = DateConverter.isoStringToLocalDate(notificationProvider.notificationList[index].createdAt);
                                  DateTime _convertedDate = DateTime(_originalDateTime.year, _originalDateTime.month, _originalDateTime.day);
                                  bool _addTitle = false;
                                  if(!_dateTimeList.contains(_convertedDate)) {
                                    _addTitle = true;
                                    _dateTimeList.add(_convertedDate);
                                  }
                                  return InkWell(
                                    onTap: () {
                                      showDialog(context: context, builder: (BuildContext context) {
                                        return NotificationDialog(notificationModel: notificationProvider.notificationList[index]);
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _addTitle ? Padding(
                                          padding: EdgeInsets.fromLTRB(10, 10, 10, 2),
                                          child: Text(DateConverter.isoStringToLocalDateOnly(notificationProvider.notificationList[index].createdAt)),
                                        ) : SizedBox(),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 50,width: 50,
                                                    child: FadeInImage.assetNetwork(
                                                      placeholder: Images.placeholder_image,
                                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.notificationImageUrl}/${notificationProvider.notificationList[index].image}',
                                                      height: 60,width: 60,fit: BoxFit.cover,
                                                      imageErrorBuilder: (c,b,v)=> Image.asset(Images.placeholder_image,height: 60,width: 60,fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  SizedBox(width: 24.0),
                                                  Expanded(
                                                    child: Text(
                                                      notificationProvider.notificationList[index].title,
                                                      style: Theme.of(context).textTheme.headline2.copyWith(
                                                        fontSize: Dimensions.FONT_SIZE_LARGE,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),

                                                  Text(
                                                    DateConverter.isoStringToLocalTimeOnly(notificationProvider.notificationList[index].createdAt),
                                                    style: Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20),

                                              Container(height: 1, color: ColorResources.COLOR_GREY.withOpacity(.2))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                      if(ResponsiveHelper.isDesktop(context)) FooterView(),
                    ],
                  ),
                ),
              ),
            )
                : NoDataScreen()
                : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
          }
      ),
    );
  }
}

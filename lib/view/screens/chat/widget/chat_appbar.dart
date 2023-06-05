import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/menu_bar_view.dart';
import 'package:provider/provider.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBackButtonExist;
  final Function onBackPressed;
  final BuildContext context;
  final OrderModel orderModel;
  ChatAppBar({this.isBackButtonExist = true, this.onBackPressed, @required this.context, @required this.orderModel});

  @override
  Widget build(BuildContext context) {
    final _splashProvider =  Provider.of<SplashProvider>(context, listen: false);
    return ResponsiveHelper.isDesktop(context) ? Center(
      child: Container(
          color: Theme.of(context).cardColor,
          width: 1170,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, Routes.getMainRoute()),
                  child: _splashProvider.baseUrls != null?  Consumer<SplashProvider>(
                      builder:(context, splash, child) => FadeInImage.assetNetwork(
                        placeholder: Images.placeholder_rectangle, image:  '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}',
                        width: 120, height: 80,
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_rectangle, width: 120, height: 80),
                      )): SizedBox(),
                ),
              ),
              MenuBarView(true),
            ],
          )
      ),
    ) : AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(orderModel != null ? '${orderModel.deliveryMan.fName} ${orderModel.deliveryMan.lName}' : _splashProvider.configModel.restaurantName, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).textTheme.bodyLarge.color)),
          orderModel == null ? Padding(
            padding: const EdgeInsets.symmetric(horizontal:  Dimensions.PADDING_SIZE_DEFAULT),
            child: CircleAvatar(
              radius: Dimensions.PADDING_SIZE_DEFAULT,
              child: ClipRRect(
                child: Image.asset(Images.placeholder_user), borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ) :
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:  Dimensions.PADDING_SIZE_DEFAULT),
            child: CircleAvatar(
              radius: Dimensions.PADDING_SIZE_DEFAULT,
              child: ClipRRect(
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholder_user, fit: BoxFit.cover, height: 40.0,width: 40.0,
                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.deliveryManImageUrl}/${orderModel.deliveryMan.image ?? ''}',
                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_user, fit: BoxFit.cover),
                ),
                borderRadius: BorderRadius.circular(50.0),
                // child: Image.asset(Images.placeholder_user), borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),

        ],
      ),


      leading: isBackButtonExist ? IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: Theme.of(context).textTheme.bodyLarge.color,
        onPressed: () => onBackPressed != null ? onBackPressed() : Navigator.pop(context),
      ) : SizedBox(),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, ResponsiveHelper.isDesktop(context) ? 80 : 50);
}

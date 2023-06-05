import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/address/widget/address_widget.dart';
import 'package:provider/provider.dart';

import 'widget/add_button_view.dart';


class AddressScreen extends StatefulWidget {
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
     appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : CustomAppBar(context: context, title: getTranslated('address', context)),
      floatingActionButton: _isLoggedIn ? Padding(
        padding:  EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ?  Dimensions.PADDING_SIZE_LARGE : 0),
        child: !ResponsiveHelper.isDesktop(context) ? FloatingActionButton(
          child: Icon(
              Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () =>  Navigator.pushNamed(context, Routes.getAddAddressRoute('address', 'add', AddressModel())),
        ) : null,
      ) : null,
      body: _isLoggedIn ? Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,

            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                      child: SizedBox(
                        width: 1170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                           if(ResponsiveHelper.isDesktop(context)) Padding(
                             padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                             child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                               Text(getTranslated('my_address', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),

                               AddButtonView(onTap: () =>  Navigator.pushNamed(context, Routes.getAddAddressRoute('address', 'add', AddressModel()))),
                             ]),
                           ),

                           locationProvider.addressList == null
                               ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                               : locationProvider.addressList.length > 0
                               ? GridView.builder(
                                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                     crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                                     crossAxisSpacing: Dimensions.PADDING_SIZE_DEFAULT,
                                     mainAxisSpacing: ResponsiveHelper.isMobile(context)
                                         ? Dimensions.PADDING_SIZE_EXTRA_SMALL : Dimensions.PADDING_SIZE_SMALL,

                                     childAspectRatio: ResponsiveHelper.isTab(context) ? 4.8 : 5,
                                   ),

                                   padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
                                       ? 0 : Dimensions.PADDING_SIZE_SMALL),
                                   itemCount: locationProvider.addressList.length,
                                   physics: NeverScrollableScrollPhysics(),
                                   shrinkWrap: true,
                                   itemBuilder: (context, index) => AddressWidget(
                                     addressModel: locationProvider.addressList[index], index: index,
                                   ),
                           ) :  NoDataScreen(isFooter: false, isAddress: true),
                          ],
                        )
                      ),
                    ),
                  ),

                  if(ResponsiveHelper.isDesktop(context)) FooterView(),
                ],
              ),
            ),
          );
        },
      ) : NotLoggedInScreen(),
    );
  }

}

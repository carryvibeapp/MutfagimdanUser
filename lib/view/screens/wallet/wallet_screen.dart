import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/wallet_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/wallet/widget/convert_money_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'widget/history_item.dart';
import 'widget/tab_button_view.dart';

class WalletScreen extends StatefulWidget {
  final bool fromWallet;
  WalletScreen({Key key, @required this.fromWallet}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ScrollController scrollController = ScrollController();
  final bool _isLoggedIn = Provider.of<AuthProvider>(Get.context, listen: false).isLoggedIn();

  @override
  void initState() {
    super.initState();
    final _walletProvide = Provider.of<WalletProvider>(context, listen: false);

    _walletProvide.setCurrentTabButton(
      0,
      isUpdate: false,
    );

    if(_isLoggedIn){
      Provider.of<ProfileProvider>(Get.context, listen: false).getUserInfo(context);
      _walletProvide.getLoyaltyTransactionList('1', false, widget.fromWallet, isEarning: _walletProvide.selectedTabButtonIndex == 1);

      scrollController?.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent
            && _walletProvide.transactionList != null
            && !_walletProvide.isLoading) {

          int pageSize = (_walletProvide.popularPageSize / 10).ceil();
          print('end of the page || pageSize: $pageSize|| offset ${_walletProvide.offset}');
          if (_walletProvide.offset < pageSize) {
            _walletProvide.setOffset = _walletProvide.offset + 1;
            _walletProvide.updatePagination(true);


            _walletProvide.getLoyaltyTransactionList(
              _walletProvide.offset.toString(), false, widget.fromWallet, isEarning: _walletProvide.selectedTabButtonIndex == 1,
            );
          }
        }
      });
    }

  }
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, // dark text for status bar
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
    ));


    scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor.withOpacity(widget.fromWallet ? 1 : 0.2),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context)
            ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100))
            : null,

        body: Consumer<ProfileProvider>(
            builder: (context, profileProvider, _) {
              return _isLoggedIn ? profileProvider.userInfoModel != null ? SafeArea(
                child: Consumer<WalletProvider>(
                  builder: (context, walletProvider, _) {
                    return Column(
                      children: [
                        Center(
                          child: Container(
                            width: Dimensions.WEB_SCREEN_WIDTH,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
                              color: Theme.of(context).primaryColor.withOpacity(widget.fromWallet ? 1 : 0.2),
                            ),
                            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Image.asset(
                                    widget.fromWallet ? Images.wallet : Images.loyal, width: 40, height: 40,
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),

                                  Text(
                                    widget.fromWallet ?
                                    PriceConverter.convertPrice(context, profileProvider.userInfoModel.walletBalance ?? 0) : '${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.point ?? 0}',
                                    style: rubikBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                                      color: widget.fromWallet ? Theme.of(context).cardColor : null,
                                    ),
                                  ),
                                ],),
                                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

                                Text( getTranslated( widget.fromWallet ? 'wallet_amount' : 'withdrawn_amount', context),
                                  style: rubikBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                    color: widget.fromWallet ? Theme.of(context).cardColor : null,
                                  ),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

                                if(!widget.fromWallet) SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: tabButtonList.map((_tabButtonModel) =>
                                        TabButtonView(tabButtonModel: _tabButtonModel,)).toList(),
                                  ),
                                ),
                                if(!widget.fromWallet) SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),

                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async{
                              walletProvider.getLoyaltyTransactionList('1', true, widget.fromWallet,isEarning: walletProvider.selectedTabButtonIndex == 1);
                              profileProvider.getUserInfo(context);
                            },
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: scrollController,
                              child: SizedBox(width: Dimensions.WEB_SCREEN_WIDTH, child: Column(
                                children: [

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [


                                      if(!widget.fromWallet && walletProvider.selectedTabButtonIndex == 0)
                                        ConvertMoneyView(),

                                      if(walletProvider.selectedTabButtonIndex != 0 || widget.fromWallet)
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                          child: Center(
                                            child: SizedBox(
                                              width: Dimensions.WEB_SCREEN_WIDTH,
                                              child: Consumer<WalletProvider>(
                                                  builder: (context, walletProvider, _) {
                                                    return Column(children: [
                                                      Column(children: [

                                                        Padding(
                                                          padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                                          child: TitleWidget(title: getTranslated(
                                                            widget.fromWallet
                                                                ? 'withdraw_history' : walletProvider.selectedTabButtonIndex == 0
                                                                ? 'enters_point_amount' : walletProvider.selectedTabButtonIndex == 1
                                                                ? 'point_earning_history' : 'point_converted_history', context,

                                                          )),
                                                        ),
                                                        walletProvider.transactionList != null ? walletProvider.transactionList.length > 0 ? GridView.builder(
                                                          key: UniqueKey(),
                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisSpacing: 50,
                                                            mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0.01,
                                                            childAspectRatio: widget.fromWallet ? 2.6 : ResponsiveHelper.isDesktop(context) ? 5 : 4.45,
                                                            crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                                                          ),
                                                          physics:  NeverScrollableScrollPhysics(),
                                                          shrinkWrap:  true,
                                                          itemCount: walletProvider.transactionList.length ,
                                                          padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 25),
                                                          itemBuilder: (context, index) {
                                                            return Stack(
                                                              children: [
                                                               widget.fromWallet ? WalletHistory(transaction: walletProvider.transactionList[index] ,) : HistoryItem(
                                                                  index: index,formEarning: walletProvider.selectedTabButtonIndex == 1,
                                                                  data: walletProvider.transactionList,
                                                                ),

                                                                if(walletProvider.paginationLoader && walletProvider.transactionList.length == index + 1)
                                                                  Center(child: CircularProgressIndicator()),
                                                              ],
                                                            );
                                                          },
                                                        ) : NoDataScreen(isFooter: false) : WalletShimmer(walletProvider: walletProvider),

                                                        walletProvider.isLoading ? Center(child: Padding(
                                                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                                          child: CircularProgressIndicator(),
                                                        )) : SizedBox(),
                                                      ])
                                                    ]);
                                                  }
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ) : Center(child: CircularProgressIndicator()) : NotLoggedInScreen();
            }
        ),
      ),
    );
  }
}


class TabButtonModel{
  final String buttonText;
  final String buttonIcon;
  final Function onTap;

  TabButtonModel(this.buttonText, this.buttonIcon, this.onTap);


}





class WalletShimmer extends StatelessWidget {
  final WalletProvider walletProvider;
  WalletShimmer({@required this.walletProvider});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: UniqueKey(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 50,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0.01,
        childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4.6 : 3.5,
        crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
      ),
      physics:  NeverScrollableScrollPhysics(),
      shrinkWrap:  true,
      itemCount: 10,
      padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 25),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(0.08))
          ),
          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL, horizontal: Dimensions.PADDING_SIZE_DEFAULT),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: walletProvider.transactionList == null,
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(height: 10, width: 20, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                    SizedBox(height: 10),

                    Container(height: 10, width: 50, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                    SizedBox(height: 10),
                    Container(height: 10, width: 70, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(height: 12, width: 40, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                    SizedBox(height: 10),
                    Container(height: 10, width: 70, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  ]),
                ],
              ),
              Padding(padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT), child: Divider(color: Theme.of(context).disabledColor)),
            ],
            ),
          ),
        );
      },
    );
  }
}
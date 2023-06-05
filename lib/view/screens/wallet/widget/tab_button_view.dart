import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/wallet_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/wallet/wallet_screen.dart';
import 'package:provider/provider.dart';

class TabButtonView extends StatelessWidget {
  final TabButtonModel tabButtonModel;
  const TabButtonView({
    Key key, this.tabButtonModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
        builder: (context, walletProvider, _) {
          return InkWell(
            hoverColor: Colors.transparent,
            radius: 10,
            highlightColor: Colors.transparent,
            onTap: ()=> walletProvider.setCurrentTabButton(tabButtonList.indexOf(tabButtonModel)),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL, vertical: Dimensions.PADDING_SIZE_DEFAULT),
              decoration: BoxDecoration(
                  color: walletProvider.selectedTabButtonIndex == tabButtonList.indexOf(tabButtonModel) ? Theme.of(context).cardColor : Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: walletProvider.selectedTabButtonIndex == tabButtonList.indexOf(tabButtonModel) ? [BoxShadow(
                    color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(0.1),
                    blurRadius: 15, offset: Offset(0, 4),
                  )] : null,
              ),
              padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
              child: Row(children: [
                Image.asset(
                  tabButtonModel.buttonIcon, height: 20, width: 20,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),

                Text(tabButtonModel.buttonText,
                  style: rubikBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ]),
            ),
          );
        }
    );
  }
}
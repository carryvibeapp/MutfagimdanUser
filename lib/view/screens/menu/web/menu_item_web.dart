
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/menu_model.dart';
import 'package:provider/provider.dart';

import '../../../../provider/auth_provider.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/routes.dart';
import '../../../../utill/styles.dart';
import '../widget/sign_out_confirmation_dialog.dart';

class MenuItemWeb extends StatelessWidget {
  final MenuModel menu;
  const MenuItemWeb({Key key, @required this.menu}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    bool _isLogin = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return InkWell(
      borderRadius: BorderRadius.circular(32.0),
      onTap: () {
        if(menu.route == 'version') {

        }else if(menu.route == 'auth'){
          _isLogin ? showDialog(
            context: context, barrierDismissible: false, builder: (context) => SignOutConfirmationDialog(),
          ) : Navigator.pushNamed(context, Routes.getLoginRoute());
        }else{
          Navigator.pushNamed(context, menu.route);
        }
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.04), borderRadius: BorderRadius.circular(32.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            menu.icon == null || menu.iconWidget != null ? menu.iconWidget
                : Image.asset(menu.icon, width: 50, height: 50, color: Theme.of(context).textTheme.bodyLarge.color),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            Text(menu.title, style: robotoRegular),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showCustomSnackBar(String message, BuildContext context, {bool isError = true, bool isToast = false}) {
  if(isToast){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: isError ? Colors.red : Colors.green,
        textColor: Colors.white,
        webBgColor: isError ? "linear-gradient(to right, #FF0000, #FF0000)"
            : "linear-gradient(to right, #00FF00, #00FF00)" ,
        fontSize: Dimensions.FONT_SIZE_DEFAULT
    );
  }else{
    final _width = MediaQuery.of(context).size.width;
    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(message),
        margin: ResponsiveHelper.isDesktop(context) ?  EdgeInsets.only(right: _width * 0.7, bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL, left: Dimensions.PADDING_SIZE_EXTRA_SMALL) : EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green)
    );
  }

}
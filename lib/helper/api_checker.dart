import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/base/error_response.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class ApiChecker {
  static void checkApi(ApiResponse apiResponse) {
    String _message;
    String _code;
    if(apiResponse.error is String) {
      _message = apiResponse.error;
    }else{
      _message = ErrorResponse.fromJson(apiResponse.error).errors[0].message;
      _code = _code;
    }

    if(_message == 'Unauthorized.' ||  _message == 'Unauthenticated.' || _code == '401'
        && ModalRoute.of(Get.context).settings.name != Routes.getLoginRoute()) {
      Provider.of<SplashProvider>(Get.context, listen: false).removeSharedData();

      if( ModalRoute.of(Get.context).settings.name != Routes.getLoginRoute()) {
        Navigator.pushNamedAndRemoveUntil(Get.context, Routes.getLoginRoute(), (route) => false);
      }
    }else {
      showCustomSnackBar(_message, Get.context);
    }
  }
}
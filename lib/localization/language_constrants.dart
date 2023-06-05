import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';

String getTranslated(String key, BuildContext context) {
  String _text = key;
  try{
    _text = AppLocalization.of(context).translate(key);
  }catch (error){
    print('error --- $error');
  }
  return _text;
}
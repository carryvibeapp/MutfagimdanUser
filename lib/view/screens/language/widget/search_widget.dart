import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/language_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, searchProvider, child) => TextField(
        cursorColor: Theme.of(context).primaryColor,
        onChanged: (String query) {
          searchProvider.searchLanguage(query, context);
        },
        style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).textTheme.bodyLarge.color, fontSize: Dimensions.FONT_SIZE_LARGE),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide(style: BorderStyle.none, width: 0),
          ),
          isDense: true,
          hintText: getTranslated('find_language', context),
          fillColor: Theme.of(context).cardColor,
          hintStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getHintColor(context)),
          filled: true,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_SMALL),
            child: Image.asset(Images.search, width: 15, height: 15, color: Theme.of(context).textTheme.bodyLarge.color),
          ),
        ),
      ),
    );
  }
}

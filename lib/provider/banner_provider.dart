import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/banner_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/banner_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:provider/provider.dart';

import 'localization_provider.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo bannerRepo;
  BannerProvider({@required this.bannerRepo});

  List<BannerModel> _bannerList;
  List<Product> _productList = [];

  List<BannerModel> get bannerList => _bannerList;
  List<Product> get productList => _productList;

  Future<void> getBannerList(BuildContext context, bool reload) async {
    if(bannerList == null || reload) {
      ApiResponse apiResponse = await bannerRepo.getBannerList();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _bannerList = [];
        apiResponse.response.data.forEach((category) {
          BannerModel bannerModel = BannerModel.fromJson(category);
          if(bannerModel.productId != null) {
            getProductDetails(context, bannerModel.productId.toString(),
              Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);
          }
          _bannerList.add(bannerModel);
        });
        notifyListeners();
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    }
  }

  void getProductDetails(BuildContext context, String productID, String languageCode) async {
    ApiResponse apiResponse = await bannerRepo.getProductDetails(productID, languageCode);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _productList.add(Product.fromJson(apiResponse.response.data));
    }
  }
}
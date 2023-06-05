import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class WishListRepo {
  final DioClient dioClient;

  WishListRepo({@required this.dioClient});

  Future<ApiResponse> getWishList(String languageCode) async {
    try {
      final response = await dioClient.get(AppConstants.WISH_LIST_GET_URI,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> addWishList(int productID) async {
    try {
      final response = await dioClient.post(AppConstants.ADD_WISH_LIST_URI, data: {'product_id' : productID});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeWishList(int productID) async {
    print('product id : $productID');
    try {
      final response = await dioClient.post(AppConstants.REMOVE_WISH_LIST_URI, data: {'product_id' : productID, '_method':'delete'});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}

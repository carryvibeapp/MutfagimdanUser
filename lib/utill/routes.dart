import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';

class Routes {

  static const String SPLASH_SCREEN = '/splash';
  static const String LANGUAGE_SCREEN = '/select-language';
  static const String ON_BOARDING_SCREEN = '/on_boarding';
  static const String WELCOME_SCREEN = '/welcome';
  static const String LOGIN_SCREEN = '/login';
  static const String SIGNUP_SCREEN = '/sign-up';
  static const String VERIFY = '/verify';
  static const String FORGOT_PASS_SCREEN = '/forgot-password';
  static const String CREATE_NEW_PASS_SCREEN = '/create-new-password';
  static const String CREATE_ACCOUNT_SCREEN = '/create-account';
  static const String DASHBOARD = '/';
  static const String MAINTAIN = '/maintain';
  static const String UPDATE = '/update';
  static const String DASHBOARD_SCREEN = '/main';
  static const String SEARCH_SCREEN = '/search';
  static const String SEARCH_RESULT_SCREEN = '/search-result';
  static const String SET_MENU_SCREEN = '/set-menu';
  static const String CATEGORY_SCREEN = '/category';
  static const String NOTIFICATION_SCREEN = '/notification';
  static const String CHECKOUT_SCREEN = '/checkout';
  static const String PAYMENT_SCREEN = '/payment';
  static const String ORDER_SUCCESS_SCREEN = '/order-successful';
  static const String ORDER_DETAILS_SCREEN = '/order-details';
  static const String RATE_SCREEN = '/rate-review';
  static const String ORDER_TRACKING_SCREEN = '/order-tracking';
  static const String PROFILE_SCREEN = '/profile';
  static const String ADDRESS_SCREEN = '/address';
  static const String MAP_SCREEN = '/map';
  static const String ADD_ADDRESS_SCREEN = '/add-address';
  static const String SELECT_LOCATION_SCREEN = '/select-location';
  static const String CHAT_SCREEN = '/messages';
  static const String COUPON_SCREEN = '/coupons';
  static const String SUPPORT_SCREEN = '/support';
  static const String TERMS_SCREEN = '/terms';
  static const String POLICY_SCREEN = '/privacy-policy';
  static const String ABOUT_US_SCREEN = '/about-us';
  static const String IMAGE_DIALOG = '/image-dialog';
  static const String MENU_SCREEN_WEB = '/menu_screen_web';
  static const String HOME_SCREEN = '/home';
  static const String ORDER_WEB_PAYMENT = '/order-web-payment';
  static const String POPULAR_ITEM_ROUTE = '/POPULAR_ITEM_ROUTE';
  static const String RETURN_POLICY_SCREEN = '/return-policy';
  static const String REFUND_POLICY_SCREEN = '/refund-policy';
  static const String CANCELLATION_POLICY_SCREEN = '/cancellation-policy';
  static const String WALLET = '/wallet';
  static const String REFER_AND_EARN = '/refer_and_earn';
  static const String BRANCH_LIST_SCREEN = '/branch-list';



  static String getSplashRoute() => SPLASH_SCREEN;
  static String getLanguageRoute(String page) => '$LANGUAGE_SCREEN?page=$page';
  static String getOnBoardingRoute() => ON_BOARDING_SCREEN;
  static String getWelcomeRoute() => WELCOME_SCREEN;
  static String getLoginRoute() => LOGIN_SCREEN;
  static String getSignUpRoute() => SIGNUP_SCREEN;
  static String getForgetPassRoute() => FORGOT_PASS_SCREEN;
  static String getNewPassRoute(String email, String token) => '$CREATE_NEW_PASS_SCREEN?email=$email&token=$token';
  static String getVerifyRoute(String page, String email) {
    String _email = base64Encode(utf8.encode(email));
    return '$VERIFY?page=$page&email=$_email';
  }

  static String getCreateAccountRoute(String email) {
    String _email = base64Encode(utf8.encode(email));
    return '$CREATE_ACCOUNT_SCREEN?email=$_email';
  }
  static String getMainRoute() => DASHBOARD;
  static String getMaintainRoute() => MAINTAIN;
  static String getUpdateRoute() => UPDATE;
  static String getHomeRoute({@required String fromAppBar}) {
    String appBar = fromAppBar ?? 'false';
    return '$HOME_SCREEN?from=$appBar';
  }
  static String getDashboardRoute(String page) => '$DASHBOARD_SCREEN?page=$page';
  static String getSearchRoute() => SEARCH_SCREEN;
  static String getSearchResultRoute(String text) {
    List<int> _encoded = utf8.encode(text);
    String _data = base64Encode(_encoded);
    return '$SEARCH_RESULT_SCREEN?text=$_data';
  }
  static String getSetMenuRoute() => SET_MENU_SCREEN;
  static String getNotificationRoute() => NOTIFICATION_SCREEN;
  static String getCategoryRoute(CategoryModel categoryModel) {
    String _data = base64Url.encode(utf8.encode(jsonEncode(categoryModel.toJson())));
    return '$CATEGORY_SCREEN?category=$_data';
  }
  static String getCheckoutRoute(double amount, String page, String type, String code) {
    String _amount= base64Url.encode(utf8.encode(amount.toString()));
    return '$CHECKOUT_SCREEN?amount=$_amount&page=$page&type=$type&code=$code';
  }

  static String getPaymentRoute(String url) {
    print('url is -----> $url');
    return '$PAYMENT_SCREEN?url=$url';
  }
  static String getOrderDetailsRoute(int id) => '$ORDER_DETAILS_SCREEN?id=$id';
  static String getRateReviewRoute() => RATE_SCREEN;
  static String getOrderTrackingRoute(int id) => '$ORDER_TRACKING_SCREEN?id=$id';
  static String getProfileRoute() => PROFILE_SCREEN;
  static String getAddressRoute() => ADDRESS_SCREEN;
  static String getMapRoute(AddressModel addressModel) {
    List<int> _encoded = utf8.encode(jsonEncode(addressModel.toJson()));
    String _data = base64Encode(_encoded);
    return '$MAP_SCREEN?address=$_data';
  }
  static String getAddAddressRoute(String page, String action, AddressModel addressModel) {
    String _data = base64Url.encode(utf8.encode(jsonEncode(addressModel.toJson())));
    return '$ADD_ADDRESS_SCREEN?page=$page&action=$action&address=$_data';
  }
  static String getSelectLocationRoute() => SELECT_LOCATION_SCREEN;
  static String getChatRoute({OrderModel orderModel}) {
    String _orderModel = base64Encode(utf8.encode(jsonEncode(orderModel)));
    return '$CHAT_SCREEN?order=$_orderModel';
  }
  static String getCouponRoute() => COUPON_SCREEN;
  static String getSupportRoute() => SUPPORT_SCREEN;
  static String getTermsRoute() => TERMS_SCREEN;
  static String getPolicyRoute() => POLICY_SCREEN;
  static String getAboutUsRoute() => ABOUT_US_SCREEN;
  static String getPopularItemScreen() => POPULAR_ITEM_ROUTE;
  static String getReturnPolicyRoute() => RETURN_POLICY_SCREEN;
  static String getCancellationPolicyRoute() => CANCELLATION_POLICY_SCREEN;
  static String getRefundPolicyRoute() => REFUND_POLICY_SCREEN;
  static String getWalletRoute(bool fromWallet) => '$WALLET?page=${fromWallet ? 'wallet' : 'loyalty_points'}';
  static String getReferAndEarnRoute() => '$REFER_AND_EARN';
  static String getBranchListScreen() => '$BRANCH_LIST_SCREEN';
}
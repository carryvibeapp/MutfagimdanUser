import 'package:flutter_restaurant/data/model/response/language_model.dart';
import 'package:flutter_restaurant/utill/images.dart';

class AppConstants {
  static const String APP_NAME = 'Mutfağımdan: Sofranıza';
  static const double APP_VERSION = 9.2;
  static const String BASE_URL =  'https://panel.mutfagimdan.net';
  static const String CATEGORY_URI = '/api/v1/categories';
  static const String BANNER_URI = '/api/v1/banners';
  static const String LATEST_PRODUCT_URI = '/api/v1/products/latest';
  static const String POPULAR_PRODUCT_URI = '/api/v1/products/popular';
  static const String SEARCH_PRODUCT_URI = '/api/v1/products/details/';
  static const String SUB_CATEGORY_URI = '/api/v1/categories/childes/';
  static const String CATEGORY_PRODUCT_URI = '/api/v1/categories/products/';
  static const String CONFIG_URI = '/api/v1/config';
  static const String TRACK_URI = '/api/v1/customer/order/track?order_id=';
  static const String MESSAGE_URI = '/api/v1/customer/message/get';
  static const String SEND_MESSAGE_URI = '/api/v1/customer/message/send';
  static const String FORGET_PASSWORD_URI = '/api/v1/auth/forgot-password';
  static const String VERIFY_TOKEN_URI = '/api/v1/auth/verify-token';
  static const String RESET_PASSWORD_URI = '/api/v1/auth/reset-password';
  static const String CHECK_PHONE_URI = '/api/v1/auth/check-phone?phone=';
  static const String VERIFY_PHONE_URI = '/api/v1/auth/verify-phone';
  static const String CHECK_EMAIL_URI = '/api/v1/auth/check-email';
  static const String VERIFY_EMAIL_URI = '/api/v1/auth/verify-email';
  static const String REGISTER_URI = '/api/v1/auth/registration';
  static const String LOGIN_URI = '/api/v1/auth/login';
  static const String TOKEN_URI = '/api/v1/customer/cm-firebase-token';
  static const String PLACE_ORDER_URI = '/api/v1/customer/order/place';
  static const String ADDRESS_LIST_URI = '/api/v1/customer/address/list';
  static const String REMOVE_ADDRESS_URI = '/api/v1/customer/address/delete?address_id=';
  static const String ADD_ADDRESS_URI = '/api/v1/customer/address/add';
  static const String UPDATE_ADDRESS_URI = '/api/v1/customer/address/update/';
  static const String SET_MENU_URI = '/api/v1/products/set-menu';
  static const String CUSTOMER_INFO_URI = '/api/v1/customer/info';
  static const String COUPON_URI = '/api/v1/coupon/list';
  static const String COUPON_APPLY_URI = '/api/v1/coupon/apply?code=';
  static const String ORDER_LIST_URI = '/api/v1/customer/order/list';
  static const String ORDER_CANCEL_URI = '/api/v1/customer/order/cancel';
  static const String UPDATE_METHOD_URI = '/api/v1/customer/order/payment-method';
  static const String ORDER_DETAILS_URI = '/api/v1/customer/order/details?order_id=';
  static const String WISH_LIST_GET_URI = '/api/v1/customer/wish-list';
  static const String ADD_WISH_LIST_URI = '/api/v1/customer/wish-list/add';
  static const String REMOVE_WISH_LIST_URI = '/api/v1/customer/wish-list/remove';
  static const String NOTIFICATION_URI = '/api/v1/notifications';
  static const String PUSH_NOTIFICATION_URI = 'https://fcm.googleapis.com/fcm/send';
  static const String UPDATE_PROFILE_URI = '/api/v1/customer/update-profile';
  static const String SEARCH_URI = '/api/v1/products/search?name=';
  static const String REVIEW_URI = '/api/v1/products/reviews/submit';
  static const String PRODUCT_DETAILS_URI = '/api/v1/products/details/';
  static const String LAST_LOCATION_URI = '/api/v1/delivery-man/last-location?order_id=';
  static const String DELIVER_MAN_REVIEW_URI = '/api/v1/delivery-man/reviews/submit';
  static const String DISTANCE_MATRIX_URI = '/api/v1/mapapi/distance-api';
  static const String SEARCH_LOCATION_URI = '/api/v1/mapapi/place-api-autocomplete';
  static const String PLACE_DETAILS_URI = '/api/v1/mapapi/place-api-details';
  static const String GEOCODE_URI = '/api/v1/mapapi/geocode-api';
  static const String GET_IMAGES_URL = '/api/v1/customer/message/chat-images';
  static const String GET_DELIVERYMAN_MESSAGE_URI = '/api/v1/customer/message/get-order-message';
  static const String GET_ADMIN_MESSAGE_URL = '/api/v1/customer/message/get-admin-message';
  static const String SEND_MESSAGE_TO_ADMIN_URL = '/api/v1/customer/message/send-admin-message';
  static const String SEND_MESSAGE_TO_DELIVERY_MAN_URL = '/api/v1/customer/message/send/customer';
  static const String EMAIL_SUBSCRIBE_URI = '/api/v1/subscribe-newsletter';
  static const String CUSTOMER_REMOVE = '/api/v1/customer/remove-account';
  static const String POLICY_PAGE = '/api/v1/pages';
  static const String SOCIAL_LOGIN = '/api/v1/auth/social-customer-login';
  static const String WALLET_TRANSACTION_URL = '/api/v1/customer/wallet-transactions';
  static const String LOYALTY_TRANSACTION_URL = '/api/v1/customer/loyalty-point-transactions';
  static const String LOYALTY_POINT_TRANSFER_URL = '/api/v1/customer/transfer-point-to-wallet';



  // Shared Key
  static const String THEME = 'theme';
  static const String TOKEN = 'token';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String CART_LIST = 'cart_list';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_ADDRESS = 'user_address';
  static const String USER_NUMBER = 'user_number';
  static const String USER_LOG_DATA = 'user_log_data';
  static const String SEARCH_ADDRESS = 'search_address';
  static const String TOPIC = 'notify';
  static const String ON_BOARDING_SKIP = 'on_boarding_skip';
  static const String PLACE_ORDER_DATA = 'place_order_data';
  static const String BRANCH = 'branch';
  static const String COOKIES_MANAGEMENT = 'cookies_management';




  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.turkish, languageName: 'Türkçe', countryCode: 'TR', languageCode: 'tr'),
    LanguageModel(imageUrl: Images.english, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.russian, languageName: 'Русский', countryCode: 'RU', languageCode: 'ru'),
    LanguageModel(imageUrl: Images.ukrainian, languageName: 'українська', countryCode: 'UA', languageCode: 'ua'),


  ];
}

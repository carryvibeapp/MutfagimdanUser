import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/cancel_dialog.dart';
import 'package:provider/provider.dart';


class PaymentScreen extends StatefulWidget {
  final String url;
  PaymentScreen({this.url});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedUrl;
  double value = 0.0;
  bool _isLoading = true;
  PullToRefreshController pullToRefreshController;
  MyInAppBrowser browser;
  PlaceOrderBody placeOrderBody;

  @override
  void initState() {
    super.initState();
    selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?token=${widget.url}&&payment_method=${Provider.of<OrderProvider>(context, listen: false).paymentMethod}';

    _initData();
  }

  void _initData() async {
    browser = MyInAppBrowser(context);
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

      bool swAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      bool swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController = AndroidServiceWorkerController.instance();
        await serviceWorkerController.setServiceWorkerClient(AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            print(request);
            return null;
          },
        ));
      }
    }

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.black,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          browser.webViewController.reload();
        } else if (Platform.isIOS) {
          browser.webViewController.loadUrl(urlRequest: URLRequest(url: await browser.webViewController.getUrl()));
        }
      },
    );
    browser.pullToRefreshController = pullToRefreshController;

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: Uri.parse(selectedUrl)),
      options: InAppBrowserClassOptions(
        inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(useShouldOverrideUrlLoading: true, useOnLoadResource: true),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
       // backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(context: context, title: getTranslated('PAYMENT', context), onBackPressed: () => _exitApp(context)),
        body: Center(
          child: Container(
            //width: Dimensions.WEB_SCREEN_WIDTH,
            child: Stack(
              children: [
                _isLoading ? Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                ) : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    return showDialog(context: context,
        builder: (context) => CancelDialog(orderID: null));
  }

}

class MyInAppBrowser extends InAppBrowser {
  final BuildContext context;
  MyInAppBrowser(this.context, {
    int windowId,
    UnmodifiableListView<UserScript> initialUserScripts,
  })
      : super(windowId: windowId, initialUserScripts: initialUserScripts);

  bool _canRedirect = true;
  PlaceOrderBody _placeOrderBody;


  @override
  Future onBrowserCreated() async {
    print("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(url) async {
    print("\n\nStarted: $url\n\n");
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    print("\n\nStopped: $url\n\n");
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    print("Can't load [$url] Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    print("Progress: $progress");
  }

  @override
  void onExit() {
    if(_canRedirect) {
      Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/-1/payment-fail');
    }

    print("\n\nBrowser closed!\n\n");
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    print("\n\nOverride ${navigationAction.request.url}\n\n");
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(response) {
   // print("Started at: " + response.startTime.toString() + "ms ---> duration: " + response.duration.toString() + "ms " + (response.url ?? '').toString());
  }

  @override
  void onConsoleMessage(consoleMessage) {
    print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
  }

  void _pageRedirect(String url) {
    if(_canRedirect) {
      bool _isSuccess = url.contains('success') && url.contains('${AppConstants.BASE_URL}${Routes.ORDER_SUCCESS_SCREEN}');
      bool _isFailed = url.contains('fail') && url.contains('${AppConstants.BASE_URL}${Routes.ORDER_SUCCESS_SCREEN}');
      bool _isCancel = url.contains('cancel') && url.contains('${AppConstants.BASE_URL}${Routes.ORDER_SUCCESS_SCREEN}');
      if(_isSuccess || _isFailed || _isCancel) {
        _canRedirect = false;
        close();
      }
      if(_isSuccess){
        String _token = url.replaceAll('${AppConstants.BASE_URL}${Routes.ORDER_SUCCESS_SCREEN}/success?token=', '');
        if(_token != null) {
          String _decodeValue = utf8.decode(base64Url.decode(_token.replaceAll(' ', '+')));
          String _paymentMethod = _decodeValue.substring(0, _decodeValue.indexOf('&&'));
          String _transactionReference = _decodeValue.substring(_decodeValue.indexOf('&&') + '&&'.length, _decodeValue.length);
          String _placeOrderString =  utf8.decode(base64Url.decode(Provider.of<OrderProvider>(context, listen: false).getPlaceOrder().replaceAll(' ', '+')));
          _placeOrderBody =  PlaceOrderBody.fromJson(jsonDecode(_placeOrderString)).copyWith(
            paymentMethod: _paymentMethod.replaceAll('payment_method=', ''),
            transactionReference: _transactionReference.replaceAll('transaction_reference=', ''),
          );
          Provider.of<OrderProvider>(context, listen: false).placeOrder(_placeOrderBody, _callback);
        }else{
          Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/${-1}/payment-fail');
        }

      }else if(_isFailed) {
        Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/${-1}/payment-fail');
      }else if(_isCancel) {
        Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/${-1}/payment-cancel');
      }
    }

  }

  void _callback(bool isSuccess, String message, String orderID, int addressID) async {
    Provider.of<CartProvider>(context, listen: false).clearCartList();
    Provider.of<OrderProvider>(context, listen: false).stopLoader();
    if(isSuccess) {
      Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/$orderID/success');
    }else {
      Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/${-1}/order-fail');
    }
  }

}





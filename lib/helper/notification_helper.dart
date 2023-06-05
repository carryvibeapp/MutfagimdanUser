import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/chat_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/screens/notification/widget/notifiation_popup_dialog.dart';
import 'package:flutter_restaurant/view/screens/order/order_details_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class NotificationHelper {


  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = new AndroidInitializationSettings('notification_icon');
    var iOSInitialize = new DarwinInitializationSettings();
    var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {

        PayloadModel _payload = PayloadModel.fromJson(jsonDecode('${notificationResponse.payload}'));

        try{
          if(notificationResponse != null && notificationResponse.payload.isNotEmpty) {
            if(_payload.orderId != null) {

              Get.navigator.push(MaterialPageRoute(builder: (context) =>
                  OrderDetailsScreen(orderModel: null, orderId: int.tryParse(_payload.orderId))),
              );
            }else if(_payload.orderId == null && _payload.type == 'message') {
              Navigator.pushNamed(Get.context, Routes.getChatRoute(orderModel: null));
            }
          }
        }catch (e) {}
        return;
      },);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      if(message.data['type'] == 'message') {
        int _id;
        _id = int.tryParse('${message.data['order_id']}');
        Provider.of<ChatProvider>(Get.context, listen: false).getMessages(Get.context, 1, _id , false);
      }

      showNotification(message, flutterLocalNotificationsPlugin, kIsWeb);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if(message.data['type'] == 'message') {
        int _id;
        _id = int.tryParse('${message.data['order_id']}');
        Provider.of<ChatProvider>(Get.context, listen: false).getMessages(Get.context, 1, _id , false);
      }

      try{
        if(message.notification.titleLocKey != null && message.notification.titleLocKey.isNotEmpty) {
          Get.navigator.push(
              MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderModel: null, orderId: int.parse(message.notification.titleLocKey))));
        }
      }catch (e) {}
    });

  }

  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln, bool data) async {
    String _title;
    String _body;
    String _orderID;
    String _image;
    String _type = '';

    if(data) {
      _title = message.data['title'];
      _body = message.data['body'];
      _orderID = message.data['order_id'];
      _image = (message.data['image'] != null && message.data['image'].isNotEmpty)
          ? message.data['image'].startsWith('http') ? message.data['image']
          : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.data['image']}' : null;


    }else {
      _title = message.notification.title;
      _body = message.notification.body;
      _orderID = message.notification.titleLocKey;
      if(Platform.isAndroid) {
        _image = (message.notification.android.imageUrl != null && message.notification.android.imageUrl.isNotEmpty)
            ? message.notification.android.imageUrl.startsWith('http') ? message.notification.android.imageUrl
            : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.notification.android.imageUrl}' : null;
      }else if(Platform.isIOS) {
        _image = (message.notification.apple.imageUrl != null && message.notification.apple.imageUrl.isNotEmpty)
            ? message.notification.apple.imageUrl.startsWith('http') ? message.notification.apple.imageUrl
            : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.notification.apple.imageUrl}' : null;
      }
    }

    if(message.data['type'] != null) {
      _type = message.data['type'];
    }

    Map<String, String> _payloadData = {
      'title' : '$_title',
      'body' : '$_body',
      'order_id' : '$_orderID',
      'image' : '$_image',
      'type' : '$_type',
    };

    PayloadModel _payload = PayloadModel.fromJson(_payloadData);

    if(kIsWeb) {
      showDialog(
          context: Get.context,
          builder: (context) => Center(
            child: NotificationPopUpDialog(_payload),
          )
      );
    }

    if(_image != null && _image.isNotEmpty) {
      try{
        await showBigPictureNotificationHiddenLargeIcon(_payload, fln);
      }catch(e) {
        await showBigTextNotification(_payload, fln);
      }
    }else {
      await showBigTextNotification(_payload, fln);
    }
  }


  static Future<void> showBigTextNotification(PayloadModel _payload, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      _payload.body, htmlFormatBigText: true,
      contentTitle: _payload.title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'efood', 'efood', importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, _payload.title, _payload.body, platformChannelSpecifics, payload: jsonEncode(_payload.toJson()));
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      PayloadModel _payload, FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile( _payload.image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile( _payload.image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: _payload.title, htmlFormatContentTitle: true,
      summaryText:  _payload.body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'efood', 'efood',
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max, playSound: true,
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0,  _payload.title,  _payload.body, platformChannelSpecifics, payload: jsonEncode(_payload.toJson()));
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }



}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print("onBackground: ${message.notification.title}/${message.notification.body}/${message.notification.titleLocKey}");

}

class PayloadModel {
  PayloadModel({
    this.title,
    this.body,
    this.orderId,
    this.image,
    this.type,
  });

  String title;
  String body;
  String orderId;
  String image;
  String type;

  factory PayloadModel.fromRawJson(String str) => PayloadModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PayloadModel.fromJson(Map<String, dynamic> json) => PayloadModel(
    title: json["title"],
    body: json["body"],
    orderId: json["order_id"],
    image: json["image"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "body": body,
    "order_id": orderId,
    "image": image,
    "type": type,
  };
}


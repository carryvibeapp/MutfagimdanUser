import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/body/message_body.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/user_type.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';


class ChatRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  ChatRepo({@required this.dioClient, @required this.sharedPreferences});


  Future<ApiResponse> getDeliveryManMessage(int orderId,int offset) async {
    try {
      final response = await dioClient.get('${AppConstants.GET_DELIVERYMAN_MESSAGE_URI}?offset=$offset&limit=100&order_id=$orderId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAdminMessage(int offset) async {
    try {
      final response = await dioClient.get('${AppConstants.GET_ADMIN_MESSAGE_URL}?offset=$offset&limit=100');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<http.StreamedResponse> sendMessageToDeliveryMan(String message, List<XFile> file, int orderId, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SEND_MESSAGE_TO_DELIVERY_MAN_URL}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    for(int i=0; i<file.length;i++){
      if(file != null) {
        Uint8List _list = await file[i].readAsBytes();
        var part = http.MultipartFile('image[]', file[i].readAsBytes().asStream(), _list.length, filename: basename(file[i].path), contentType: MediaType('image', 'jpg'));
        request.files.add(part);
      }
    }
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'message': message,
      'order_id': orderId.toString(),
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> sendMessageToAdmin(String message, List<XFile> file, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SEND_MESSAGE_TO_ADMIN_URL}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    for(int i=0; i<file.length;i++){
      if(file != null) {
        Uint8List _list = await file[i].readAsBytes();
        var part = http.MultipartFile('image[]', file[i].readAsBytes().asStream(), _list.length, filename: basename(file[i].path), contentType: MediaType('image', 'jpg'));
        request.files.add(part);
      }
    }
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'message': message,
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }


  Future<http.StreamedResponse> sendMessage(String message, List<XFile> images, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.GET_IMAGES_URL}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(images != null && ResponsiveHelper.isMobilePhone()) {
      for(int i = 0; i < images.length; i++) {
        File _file = File(images[i].path);
        request.files.add(http.MultipartFile('image[]', _file.readAsBytes().asStream(), _file.lengthSync(), filename: _file.path.split('/').last));

      }
    }else if(images != null && ResponsiveHelper.isWeb()) {
      for(int i = 0; i < images.length; i++) {
        Uint8List _list = await images[i].readAsBytes();
        request.files.add(http.MultipartFile('image[]', images[i].readAsBytes().asStream(), _list.length, filename: basename(images[0].path)));
      }
    }
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'message': message
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<ResponseModel> sendRealTimeMessage(int senderID, UserType senderType, int receiverID, UserType receiverType,
      String message, List<XFile> images, {int orderID}) async {
    ResponseModel _responseModel;
    List<String> _imageUrlList = [];
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    CollectionReference _ref;
    CollectionReference _receiverRef;
    MessageBody _message;
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.GET_IMAGES_URL}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer ${sharedPreferences.getString(AppConstants.TOKEN)}'});

    if(images != null && ResponsiveHelper.isMobilePhone()) {
      for(int i = 0; i < images.length; i++) {
        File _file = File(images[i].path);
        request.files.add(http.MultipartFile('image[]', _file.readAsBytes().asStream(), _file.lengthSync(), filename: _file.path.split('/').last));

      }
    }else if(images != null && ResponsiveHelper.isWeb()) {
      for(int i = 0; i < images.length; i++) {
        Uint8List _list = await images[i].readAsBytes();
        request.files.add(http.MultipartFile('image[]', images[i].readAsBytes().asStream(), _list.length, filename: basename(images[0].path)));
      }
    }
    http.StreamedResponse response = await request.send();
    final respStr = await response.stream.bytesToString();

    if(images != null) for(int i = 0; i < images.length; i++) {
      _imageUrlList.add('${jsonDecode(respStr)['image_urls'][i]}');
    }

    if(orderID != null) {
      _ref = _fireStore.collection('order').doc(orderID.toString()).collection('messages');
      _fireStore.collection('order').doc(orderID.toString()).set({'is_seenDM' : false, 'is_seenCS' : true});
    }else {
      _fireStore.collection('general').doc('${_getTypeFromEnum(senderType)}$senderID')
          .collection('receivers').doc('${_getTypeFromEnum(receiverType)}$receiverID').set({'is_seen' : true});
      _ref = _fireStore.collection('general').doc('${_getTypeFromEnum(senderType)}$senderID').collection('receivers')
          .doc('${_getTypeFromEnum(receiverType)}$receiverID').collection('messages');
    }
    _fireStore.collection('general').doc('${_getTypeFromEnum(receiverType)}$receiverID')
        .collection('receivers').doc('${_getTypeFromEnum(senderType)}$senderID').set({'is_seen' : false});
    _receiverRef = _fireStore.collection('general').doc('${_getTypeFromEnum(receiverType)}$receiverID').collection('receivers')
        .doc('${_getTypeFromEnum(senderType)}$senderID').collection('messages');

    String _id = _ref.doc().id;
    String _receiverId = _receiverRef.doc().id;
    _message = MessageBody(
      id: _id, orderId: orderID, senderId: '${_getTypeFromEnum(senderType)}$senderID',
      receiverId: '${_getTypeFromEnum(receiverType)}$receiverID', message: message, imageUrls: _imageUrlList,
    );
    await _ref.doc(_id).set(_message.toJson());

    await _receiverRef.doc(_receiverId).set(_message.toJson()).then((value) => _responseModel = ResponseModel(true, 'added')).catchError((error) {
      _responseModel = ResponseModel(false, error.toString());
    });
    return _responseModel;
  }

  Map<String, dynamic> getRealTimeMessages(int senderID, UserType senderType, int receiverID, UserType receiverType, {int orderID}) {
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    Query _ref;
    DocumentReference _isSeenRef;
    if(orderID != null) {
      _ref = _fireStore.collection('order').doc(orderID.toString()).collection('messages').orderBy('time');
      _isSeenRef = _fireStore.collection('order').doc(orderID.toString());
    }else {
      _ref = _fireStore.collection('general').doc('${_getTypeFromEnum(senderType)}$senderID').collection('receivers')
          .doc('${_getTypeFromEnum(receiverType)}$receiverID').collection('messages').orderBy('time');
      _isSeenRef = _fireStore.collection('general').doc('${_getTypeFromEnum(receiverType)}$receiverID').collection('receivers').doc('${_getTypeFromEnum(senderType)}$senderID');
    }
    return {'ref' : _ref, 'isSeenRef' : _isSeenRef, 'orderId' : orderID};
  }
  void setSeen(int senderID, UserType senderType, int receiverID, UserType receiverType, {int orderID}) {
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    if(orderID == null) {
      _fireStore.collection('general').doc('${_getTypeFromEnum(senderType)}$senderID')
          .collection('receivers').doc('${_getTypeFromEnum(receiverType)}$receiverID').set({'is_seen' : true});
    }else{
      _fireStore.collection('order').doc(orderID.toString()).update({'is_seenCS' : true});
    }


  }

  String _getTypeFromEnum(UserType userType) {
    return userType == UserType.customer ? 'CS' : userType == UserType.admin ? 'AD'
        : userType == UserType.deliveryMan ? 'DM' : '';
  }

}
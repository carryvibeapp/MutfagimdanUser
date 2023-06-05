import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBody {
  String id;
  int orderId;
  String senderId;
  String receiverId;
  String message;
  DateTime time;
  List<String> imageUrls;

  MessageBody({this.id, this.orderId, this.senderId, this.receiverId, this.message, this.time, this.imageUrls});

  MessageBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    time = json['time'] != null ? json['time'].toDate() : DateTime.now();
    imageUrls = json['image_urls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['message'] = this.message;
    data['time'] = FieldValue.serverTimestamp();
    data['image_urls'] = this.imageUrls;
    return data;
  }
}

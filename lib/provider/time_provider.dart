import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimerProvider with ChangeNotifier {
  Duration _duration;
  Timer _timer;
  Duration get duration => _duration;

  Future<void> countDownTimer(OrderModel order, BuildContext context) async {
    DateTime _orderTime;
    if(Provider.of<SplashProvider>(context, listen: false).configModel.timeFormat == '12') {
      _orderTime =  DateFormat("yyyy-MM-dd HH:mm").parse('${order.deliveryDate} ${order.deliveryTime}');

    }else{
      _orderTime =  DateFormat("yyyy-MM-dd HH:mm").parse('${order.deliveryDate} ${order.deliveryTime}');
    }

    DateTime endTime = _orderTime.add(Duration(minutes: int.parse(order.preparationTime)));
    print('object === $endTime');

    // _duration = DateTime.now().difference(endTime);
    _duration = endTime.difference(DateTime.now());
    print('duration === ${_duration.inMinutes}');
    _timer?.cancel();
    _timer = null;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(!_duration.isNegative && _duration.inSeconds > 0) {
        _duration = _duration - Duration(seconds: 1);
        notifyListeners();
      }

    });
    if(_duration.isNegative) {
      _duration = Duration();
    }_duration = endTime.difference(DateTime.now());

  }

}
